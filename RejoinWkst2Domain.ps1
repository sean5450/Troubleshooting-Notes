# Specify the path to the file containing host names
$hostsFile = "hosts.txt"

# Specify the domain name
$domainName = "yourdomain.com"

# Specify the admin credentials for joining/unjoining the domain
$adminUsername = "domain\admin"
$adminPassword = "adminpassword"

# Specify the local admin credentials for logging in to each device
$localAdminUsername = "localadmin"
$localAdminPassword = "localadminpassword"

# Read the host names from the file
$hostNames = Get-Content $hostsFile

# Loop through each host name
foreach ($hostName in $hostNames) {
    Write-Host "Processing host: $hostName"

        $enableWinRMCommand = "Enable-PSRemoting -Force -SkipNetworkProfileCheck"
            Invoke-Expression $enableWinRMCommand

                Write-Host "Unjoining host $hostName from the domain..."

                    # Unjoin the host from the domain
                        $unjoinCommand = "Remove-Computer -Force -ComputerName $hostName -UnjoinDomainCredential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminUsername, (ConvertTo-SecureString -String $adminPassword -AsPlainText -Force)) -PassThru -Restart -ErrorAction SilentlyContinue"
                            Invoke-Expression $unjoinCommand

                                # Wait until the host is restarted and check if it is up
                                    while (!(Test-Connection -ComputerName $hostName -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
                                            Start-Sleep -Seconds 5
                                                }

                                                    Write-Host "Host $hostName has been unjoined from the domain."

                                                        Write-Host "Joining host $hostName to the domain..."

                                                            # Join the host to the domain
                                                                $joinCommand = "Add-Computer -ComputerName $hostName -DomainName $domainName -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminUsername, (ConvertTo-SecureString -String $adminPassword -AsPlainText -Force)) -LocalCredential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $localAdminUsername, (ConvertTo-SecureString -String $localAdminPassword -AsPlainText -Force)) -Restart"
                                                                    Invoke-Expression $joinCommand

                                                                        Write-Host "Host $hostName has been joined to the domain."
                                                                        }

                                                                        Write-Host "All hosts have been processed."