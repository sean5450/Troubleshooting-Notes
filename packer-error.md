  vmware-iso: Running handlers:
    vmware-iso: [2026-02-20T18:23:27+00:00] ERROR: Running exception handlers
    vmware-iso: [2026-02-20T18:23:27+00:00] ERROR: Running exception handlers
    vmware-iso: Running handlers complete
    vmware-iso: [2026-02-20T18:23:27+00:00] ERROR: Exception handlers complete
    vmware-iso: [2026-02-20T18:23:27+00:00] ERROR: Exception handlers complete
    vmware-iso: Chef Client failed. 122 resources updated in 04 minutes 15 seconds
    vmware-iso: [2026-02-20T18:23:27+00:00] FATAL: Stacktrace dumped to /tmp/packer-chef-solo/local-mode-cache/cache/chef-stacktrace.out
    vmware-iso: [2026-02-20T18:23:27+00:00] FATAL: Stacktrace dumped to /tmp/packer-chef-solo/local-mode-cache/cache/chef-stacktrace.out
    vmware-iso: [2026-02-20T18:23:27+00:00] FATAL: Please provide the contents of the stacktrace.out file if you file a bug report
    vmware-iso: [2026-02-20T18:23:27+00:00] FATAL: Please provide the contents of the stacktrace.out file if you file a bug report
    vmware-iso: [2026-02-20T18:23:27+00:00] ERROR: docker_service[default] (metasploitable::docker line 6) had an error: Chef::Exceptions::Package: docker_installation_package[default] (/tmp/packer-chef-solo/local-mode-cache/cache/cookbooks/docker/libraries/docker_service.rb line 62) had an error: Chef::Exceptions::Package: apt_package[docker-ce] (/tmp/packer-chef-solo/local-mode-cache/cache/cookbooks/docker/libraries/docker_installation_package.rb line 42) had an error: Chef::Exceptions::Package: No candidate version available for docker-ce
    vmware-iso: [2026-02-20T18:23:27+00:00] ERROR: docker_service[default] (metasploitable::docker line 6) had an error: Chef::Exceptions::Package: docker_installation_package[default] (/tmp/packer-chef-solo/local-mode-cache/cache/cookbooks/docker/libraries/docker_service.rb line 62) had an error: Chef::Exceptions::Package: apt_package[docker-ce] (/tmp/packer-chef-solo/local-mode-cache/cache/cookbooks/docker/libraries/docker_installation_package.rb line 42) had an error: Chef::Exceptions::Package: No candidate version available for docker-ce
    vmware-iso: [2026-02-20T18:23:27+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
    vmware-iso: [2026-02-20T18:23:27+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
==> vmware-iso: Provisioning step had errors: Running the cleanup provisioner, if present...
==> vmware-iso: Stopping virtual machine...
==> vmware-iso: Deleting output directory...
Build 'vmware-iso' errored after 8 minutes 5 seconds: Error executing Chef: Non-zero exit status: 1

==> Wait completed after 8 minutes 5 seconds

==> Some builds didn't complete successfully and had errors:
--> vmware-iso: Error executing Chef: Non-zero exit status: 1

==> Builds finished but no artifacts were created.
PS C:\Users\The-Biggest-Chungus\Documents\metasploitable3>
