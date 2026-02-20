PS C:\Users\The-Biggest-Chungus\Documents\metasploitable3\chef\cookbooks\metasploitable\recipes> Get-ChildItem -Recurse .\ | Select-String "docker"

docker.rb:3:# Recipe:: docker
docker.rb:6:docker_service 'default' do
docker.rb:10:  group 'docker'
docker.rb:13:group 'docker' do
docker.rb:16:  members node[:metasploitable][:docker_users]
flags.rb:22:include_recipe 'metasploitable::docker'
flags.rb:24:directory '/opt/docker' do
flags.rb:28:cookbook_file '/opt/docker/Dockerfile' do
flags.rb:29:  source '/flags/Dockerfile'
flags.rb:33:cookbook_file '/opt/docker/7_of_diamonds.zip' do
flags.rb:38:docker_image '7_of_diamonds' do
flags.rb:40:    source '/opt/docker/'
flags.rb:43:docker_container '7_of_diamonds' do
flags.rb:50:file '/opt/docker/7_of_diamonds.zip' do

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

  vmware-iso: Recipe: iptables::default
    vmware-iso:   * execute[rebuild-iptables] action run
    vmware-iso:     - execute /usr/sbin/rebuild-iptables
    vmware-iso:
    vmware-iso: Running handlers:
    vmware-iso: [2026-02-20T18:45:28+00:00] ERROR: Running exception handlers
    vmware-iso: [2026-02-20T18:45:28+00:00] ERROR: Running exception handlers
    vmware-iso: Running handlers complete
    vmware-iso: [2026-02-20T18:45:28+00:00] ERROR: Exception handlers complete
    vmware-iso: [2026-02-20T18:45:28+00:00] ERROR: Exception handlers complete
    vmware-iso: Chef Client failed. 226 resources updated in 08 minutes 03 seconds
    vmware-iso: [2026-02-20T18:45:28+00:00] FATAL: Stacktrace dumped to /tmp/packer-chef-solo/local-mode-cache/cache/chef-stacktrace.out
    vmware-iso: [2026-02-20T18:45:28+00:00] FATAL: Stacktrace dumped to /tmp/packer-chef-solo/local-mode-cache/cache/chef-stacktrace.out
    vmware-iso: [2026-02-20T18:45:28+00:00] FATAL: Please provide the contents of the stacktrace.out file if you file a bug report
    vmware-iso: [2026-02-20T18:45:28+00:00] FATAL: Please provide the contents of the stacktrace.out file if you file a bug report
    vmware-iso: [2026-02-20T18:45:28+00:00] ERROR: docker_service[default] (metasploitable::docker line 6) had an error: Chef::Exceptions::Package: docker_installation_package[default] (/tmp/packer-chef-solo/local-mode-cache/cache/cookbooks/docker/libraries/docker_service.rb line 62) had an error: Chef::Exceptions::Package: apt_package[docker-ce] (/tmp/packer-chef-solo/local-mode-cache/cache/cookbooks/docker/libraries/docker_installation_package.rb line 42) had an error: Chef::Exceptions::Package: No candidate version available for docker-ce
    vmware-iso: [2026-02-20T18:45:28+00:00] ERROR: docker_service[default] (metasploitable::docker line 6) had an error: Chef::Exceptions::Package: docker_installation_package[default] (/tmp/packer-chef-solo/local-mode-cache/cache/cookbooks/docker/libraries/docker_service.rb line 62) had an error: Chef::Exceptions::Package: apt_package[docker-ce] (/tmp/packer-chef-solo/local-mode-cache/cache/cookbooks/docker/libraries/docker_installation_package.rb line 42) had an error: Chef::Exceptions::Package: No candidate version available for docker-ce
    vmware-iso: [2026-02-20T18:45:28+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
    vmware-iso: [2026-02-20T18:45:28+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
==> vmware-iso: Provisioning step had errors: Running the cleanup provisioner, if present...
==> vmware-iso: Stopping virtual machine...
==> vmware-iso: Deleting output directory...
Build 'vmware-iso' errored after 11 minutes 44 seconds: Error executing Chef: Non-zero exit status: 1

==> Wait completed after 11 minutes 44 seconds

==> Some builds didn't complete successfully and had errors:
--> vmware-iso: Error executing Chef: Non-zero exit status: 1

==> Builds finished but no artifacts were created.
