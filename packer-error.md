  vmware-iso:     (new content is binary, diff output suppressed)
    vmware-iso:     - change mode from '' to '0610'
    vmware-iso:     - change owner from '' to 'kylo_ren'
    vmware-iso:     - change group from '' to 'users'
    vmware-iso:   * execute[build locate database] action run
    vmware-iso:     - execute updatedb
    vmware-iso: Recipe: metasploitable::ifnames
    vmware-iso:   * link[/etc/udev/rules.d/75-persistent-net-generator.rules] action create
    vmware-iso:     - create symlink at /etc/udev/rules.d/75-persistent-net-generator.rules to /dev/null
    vmware-iso: Recipe: iptables::default
    vmware-iso:   * execute[rebuild-iptables] action run
    vmware-iso:     - execute /usr/sbin/rebuild-iptables
    vmware-iso:
    vmware-iso: Running handlers:
    vmware-iso: Running handlers complete
    vmware-iso: Chef Client finished, 247/283 resources updated in 07 minutes 57 seconds
==> vmware-iso: Gracefully halting virtual machine...
    vmware-iso: Waiting for VMware to clean up after itself...
==> vmware-iso: Deleting unnecessary VMware files...
    vmware-iso: Deleting: output-vmware-iso\metasploitable3-ub1404.scoreboard
    vmware-iso: Deleting: output-vmware-iso\vmware.log
==> vmware-iso: Compacting all attached virtual disks...
    vmware-iso: Compacting virtual disk 1
==> vmware-iso: Cleaning VMX prior to finishing up...
    vmware-iso: Detaching ISO from CD-ROM device ide0:0...
    vmware-iso: Disabling VNC server...
==> vmware-iso: Skipping export of virtual machine...
==> vmware-iso: Running post-processor: vagrant
==> vmware-iso (vagrant): Creating a dummy Vagrant box to ensure the host system can create one correctly
==> vmware-iso (vagrant): Creating Vagrant box for 'vmware' provider
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s001.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s002.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s003.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s004.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s005.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s006.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s007.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s008.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s009.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk-s010.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\disk.vmdk
    vmware-iso (vagrant): Copying: output-vmware-iso\metasploitable3-ub1404.nvram
    vmware-iso (vagrant): Copying: output-vmware-iso\metasploitable3-ub1404.vmsd
    vmware-iso (vagrant): Copying: output-vmware-iso\metasploitable3-ub1404.vmx
    vmware-iso (vagrant): Copying: output-vmware-iso\metasploitable3-ub1404.vmxf
    vmware-iso (vagrant): Compressing: Vagrantfile
    vmware-iso (vagrant): Compressing: disk-s001.vmdk
    vmware-iso (vagrant): Compressing: disk-s002.vmdk
    vmware-iso (vagrant): Compressing: disk-s003.vmdk
    vmware-iso (vagrant): Compressing: disk-s004.vmdk
    vmware-iso (vagrant): Compressing: disk-s005.vmdk
    vmware-iso (vagrant): Compressing: disk-s006.vmdk
    vmware-iso (vagrant): Compressing: disk-s007.vmdk
    vmware-iso (vagrant): Compressing: disk-s008.vmdk
    vmware-iso (vagrant): Compressing: disk-s009.vmdk
    vmware-iso (vagrant): Compressing: disk-s010.vmdk
    vmware-iso (vagrant): Compressing: disk.vmdk
    vmware-iso (vagrant): Compressing: metadata.json
    vmware-iso (vagrant): Compressing: metasploitable3-ub1404.nvram
    vmware-iso (vagrant): Compressing: metasploitable3-ub1404.vmsd
    vmware-iso (vagrant): Compressing: metasploitable3-ub1404.vmx
    vmware-iso (vagrant): Compressing: metasploitable3-ub1404.vmxf
Build 'vmware-iso' finished after 12 minutes 20 seconds.

==> Wait completed after 12 minutes 20 seconds

==> Builds finished. The artifacts of successful builds are:
--> vmware-iso: 'vmware' provider box: C:\Users\The-Biggest-Chungus\Documents\metasploitable3\packer\templates/../builds/ubuntu_1404_vmware_0.1.12.box

---

"run_list": [
        "apt::default",
        "metasploitable::users",
        "metasploitable::mysql",
        "metasploitable::apache_continuum",
        "metasploitable::apache",
        "metasploitable::php_545",
        "metasploitable::phpmyadmin",
        "metasploitable::proftpd",
        "metasploitable::docker",
        "metasploitable::samba",
        "metasploitable::sinatra",
        "metasploitable::unrealircd",
        "metasploitable::chatbot",
        "metasploitable::payroll_app",
        "metasploitable::readme_app",
        "metasploitable::cups",
        "metasploitable::drupal",
        "metasploitable::knockd",
        "metasploitable::iptables",
        "metasploitable::flags",
        "metasploitable::ifnames"
      ]
    }


---

  drupal.rb:73:  source 'flags/5_of_hearts.png'
drupal.rb:78:  source 'flags/5_of_hearts.png'
flags.rb:3:# Recipe:: flags
flags.rb:15:  source 'flags/10_of_clubs.wav'
flags.rb:29:  source '/flags/Dockerfile'
flags.rb:34:  source '/flags/7_of_diamonds.zip'
flags.rb:54:# Easy mode flags
flags.rb:59:  source 'flags/flag_images/10 of spades.png'
flags.rb:77:  source 'flags/flag_images/8 of clubs.png'
flags.rb:85:  source 'flags/flag_images/3 of hearts.png'
flags.rb:97:  source 'flags/my_recordings_do_not_open.iso'
flags.rb:107:# Hard mode flags
flags.rb:117:    source 'flags/five_of_diamonds'
flags.rb:122:    source 'flags/five_of_diamonds_srv'
flags.rb:132:    source 'flags/2_of_spades.pcapng'
flags.rb:144:    mysql -h 127.0.0.1 --user="root" --password="sploitme" super_secret_db <
#{File.join(Chef::Config[:file_cache_path], 'cookbooks', 'metasploitable', 'files', 'flags', 'super_secret_db.sql')}
flags.rb:151:    source 'flags/joker.png'
knockd.rb:26:  lines "-I FORWARD 1 -p tcp -m tcp --dport #{node[:flags][:five_of_diamonds][:vuln_port]} -j DROP"
