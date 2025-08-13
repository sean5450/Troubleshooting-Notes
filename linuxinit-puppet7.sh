#!/bin/bash
TMP_DIR="/tmp/simspace"
AGENT_VERSION="7.34.0-1"
confirm() {
    # https://stackoverflow.com/questions/3231804/
    read -r -p "${1:-Do you want to set the timezone to New York? [Y/n]} " response
    case "$response" in
        [nN][oO]|[nN])
            false
            ;;
        *)
            true
            ;;
    esac
}

command_exists(){
	command -v "$1" > /dev/null 2>&1
}

set-timezone() {
	if [ -e "/usr/lib/systemd/" ]; then
		set-timezone-systemd
		return 0
	else
		if [ -e "/etc/redhat-release" ]; then
			CENTOSVERSION=`grep -o -E [0-9]* /etc/redhat-release | head -1`
			if [ $CENTOSVERSION = "6" ] ; then
				set-timezone-centos
				return
			fi
		fi
		if [ -e "/etc/lsb-release" ]; then
			UBUNTUVERSION=`grep RELEASE /etc/lsb-release | cut -d'=' -f2 | cut -d'.' -f1`
			if [ $UBUNTUVERSION = "12" ] ; then
				set-timezone-ubuntu
				return
			fi
		fi
		echo "Unknown OS, exiting"
		exit 1
	fi
}
set-timezone-ubuntu() {
	echo "America/New_York" > /etc/timezone
	dpkg-reconfigure -f noninteractive tzdata
}
			
set-timezone-systemd() {
	timedatectl set-timezone America/New_York
	timedatectl
}
set-timezone-centos() {
	rm /etc/localtime
	ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
	echo "A reboot might be needed for the timezone change to take effect everywhere"
	date
}

if [ ! "$(whoami)" = "root" ] ; then
	echo "Please run this as root"
	exit 1
fi

# Check for pre-reqs, Ubuntu installs in particular
# don't seem to have curl installed
if ! command -v curl &> /dev/null ; then
	echo "Curl is not installed and is required but simspace-sethostname"
	echo "Please install curl and run this script again" 
	exit 1
fi 

echo "Extracting SimSpace files"
payload_start=$(grep --text --line-number '^PAYLOAD:$' $0 | cut -d ':' -f 1)
payload_start=$((payload_start + 1))
mkdir $TMP_DIR
tail -n +$payload_start $0 | base64 --decode > $TMP_DIR/simspace.tar.gz

# --no-same-owner will extract the files as the current user (which will be root) instead of how they are packaged 
# Added the k option to tar to prevent it from changing permissions on folders that exist (like /usr /usr/bin /etc etcetera)

# there is also --no-same-permissions but I am going to leave that off and use the permissions as they are in the archive
# and the k option should prevent from writing over existing permissions

tar xmfk $TMP_DIR/simspace.tar.gz  -C / --no-same-owner 

echo "Downloading and installing packages"
INSTALLFAIL=0
if command_exists dpkg; then
  # Ubuntu/Debian
  OS_TYPE="debian"
  if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
	OS_VERSION=$DISTRIB_RELEASE
	OS_NAME=$DISTRIB_ID
  elif [ -f /etc/debian_version ]; then
    . /etc/os-release
    OS_VERSION=$VERSION_ID
    if [[ $ID == "kali" ]]; then
      OS_NAME="Kali"
    else
      OS_NAME="Debian"
    fi
  else
    echo "Cannot determine Ubuntu/Debian version"
    exit 1
  fi
  OS_NAME=$(echo $OS_NAME | tr '[:upper:]' '[:lower:]')

  echo "Detected $OS_NAME version: $OS_VERSION"

  CODENAME=""
  case $OS_NAME in
    "ubuntu") CODENAME=$DISTRIB_CODENAME ;;
	"debian") CODENAME=$VERSION_CODENAME ;;
	"kali") CODENAME="bookworm" ;;
	*) echo "Unknown Debian version"
	   exit 1 ;;
  esac

  PUPPET_URL="http://apt.puppet.com/pool/$CODENAME/puppet7/p/puppet-agent/puppet-agent_${AGENT_VERSION}${CODENAME}_amd64.deb"
  PACKAGE_PATH="$TMP_DIR/puppet-agent.deb"
  INSTALL_CMD="dpkg -G -i --force-confnew $PACKAGE_PATH &> $TMP_DIR/simspace-install.log || INSTALLFAIL=1"
elif command_exists rpm;  then
  # RHEL/CentOS
  OS_TYPE="rhel"
  if [ -f /etc/centos-release ]; then
    OS_VERSION=`grep -o -E [0-9]* /etc/centos-release | head -1`
	OS_NAME="CentOS"
  elif [ -f /etc/redhat-release ]; then
    OS_VERSION=`grep -o -E [0-9]* /etc/redhat-release | head -1`
	OS_NAME="RHEL"
  else
    echo "Cannot determine Centos/RHEL version"
	exit 1
  fi

  echo "Detected $OS_NAME version: $OS_VERSION"

  if (( OS_VERSION >= 7 && OS_VERSION <= 9 )); then
    PUPPET_URL="http://yum.puppet.com/puppet7/el/$OS_VERSION/x86_64/puppet-agent-$AGENT_VERSION.el$OS_VERSION.x86_64.rpm"
  elif (( OS_VERSION = 10 )); then
    echo "WARNING: No prebuilt package for $OS_NAME $OS_VERSION. Using package built for $OS_NAME 9 instead"
    PUPPET_URL="http://yum.puppet.com/puppet7/el/9/x86_64/puppet-agent-$AGENT_VERSION.el9.x86_64.rpm"
  else
	echo "Unsupported version $OS_NAME $OS_VERSION"
	echo "Versions <7 do not support puppet 7."
	exit 1
  fi

  PACKAGE_PATH="$TMP_DIR/puppet-agent.rpm"
  INSTALL_CMD="rpm -i $PACKAGE_PATH &> $TMP_DIR/simspace-install.log || INSTALLFAIL=1"
else
  echo "This is an unsupported OS"
  exit 1    
fi

curl -s -L $PUPPET_URL -o $PACKAGE_PATH
eval $INSTALL_CMD

if [ "$INSTALLFAIL" = 1 ]; then
	echo "Package install failed, log in /tmp/simspace/simspace-install.log"
	echo "Exiting"
	exit 1
fi

### Facter overrides ###
# Make kali list as Debian 8 instead of older debian
# This is specifically for the mcollective agents module but
# will probably save some headaches on other stuff later 
# specifically this was to change the service_provide fact
# from "debian" to "systemd" 
if [ -f /etc/lsb-release ]; then
  grep --silent kali-rolling /etc/lsb-release && echo "operatingsystemmajrelease=8" > /opt/puppetlabs/facter/facts.d/kali-override.txt
fi
### Disable cloud-init ###
# cloud-init is installed and enabled/running by default on Ubuntu 18
# it messes with networking and the hostname, we do not utilize it at
# all and so we are disabling it here.
# https://cloudinit.readthedocs.io/en/latest/topics/boot.html
if [ -e "/etc/cloud/" ]; then
	echo "Disabling cloud init"
	touch /etc/cloud/cloud-init.disabled
fi

if [ -e /etc/systemd/system ]; then
	echo "Installing systemd service files" 
	cp /etc/simspace/simspace-sethostname.service /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable simspace-sethostname
else
	echo "Installing cron file"
	cp /etc/simspace/simspace.cron /etc/cron.d/
	chown root:root /etc/cron.d/simspace
	chmod 600 /etc/cron.d/simspace
	chown root:root /usr/bin/simspace-sethostname
fi

cp /etc/simspace/puppet.conf /etc/puppetlabs/puppet/

echo "Restarting services"
if [ "$(ps --no-headers -o comm 1)" = "systemd" ]; then
	systemctl restart puppet
	systemctl enable puppet
else
	service puppet restart
fi

confirm && set-timezone
# This exit must be here since the payload tarball will be appended to this file
exit 0
PAYLOAD:
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
