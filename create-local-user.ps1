Add-Type -AssemblyName System.Web

$computers = (Get-ADComputer -Filter *).Name
$username = "DannyBoy"

$local_security_group = "Administrators"
$returnObj = @()

Foreach ($computer in $computers) {
    $users = $null
    $comp = [ADSI]"WinNT://$computer"
    $password = [System.Web.Security.Membership]::GeneratePassword(12,2)
    Try {
        $users = $comp.psbase.children | select -expand name

        if ($users.contains("$username")) {
        Write-Host "$username already exists on $computer"
        } 
        else {
        Write-Host "$username does not exists on $computer"
        Write-Host "Attempting to create user"
        $user = $comp.Create("User","$username")
        $user.SetPassword("$password")
        $ADS_UF_DONT_EXPIRE_PASSWD = 0x10000
        $ADS_UF_PASSWD_CANT_CHANGE = 0x40
        $user.userflags = $ADS_UF_DONT_EXPIRE_PASSWD + $ADS_UF_PASSWD_CANT_CHANGE
        $user.SetInfo()
        Write-Host "Created User attempting Group"
        $group = [ADSI]"WinNT://$computer/$local_security_group,group"
        $group.add("WinNT://$computer/$username")
        Write-Host "Check This end group "
        $users = $comp.psbase.children | select -expand name
        if ($users.contains("$username")) {
             Write-Host "Adding to output "
             $returnObj += [pscustomobject]@{Computer=$computer;Username=$username;Password=$password}
        }
        }
    }
    Catch {
        Write-Host "Error creating $username on $($computer.path):  $($Error[0].Exception.Message)"
    }
    }
$returnObj | format-table
$returnObj | Export-CSV -NoTypeInformation "passwords.csv"
