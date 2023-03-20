**Enable WinRM**

LAB: Enable WinRM Via Group Policy
Using the site-dc VM, open a command prompt.
Run the gpmc.msc command to open the Group Policy Management snap-in.
Expand the forest branches to navigate to Domains > site.lan > Group Policy Objects.
Right-click the Group Policy Objects branch, then select New.
Type "WinRM Policy" in the Name field of the New GPO popup, then click OK.
Right-click the newly created WinRM Policy and select Edit.
Navigate to Computer Configuration > Preferences > Control Panel Settings > Services.
Right-click Services, then select New > Service.
In the New Service Properties popup, configure the following:
Startup: Automatic
Service Name: WinRM
Service Action: Start Service
Navigate to Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Remote Management > WinRM Service.
Open the "Allow remote server management through WinRM" setting and configure the following:
Enabled
IPv4 filter: *
IPv6 filter: *
Navigate to Computer Configuration > Policies > Windows Settings > Security Settings > Windows Firewall with Advance Security.
Right-click Inbound Rules, then select New Rule.
Select the Predefined radio button and choose Windows Remote Management from the dropdown, then click Next.
Ensure only the rule containing "Domain, Private" in the Profile column is checked, then select Next.
Select Allow the connection, then click Finish.
Link the WinRM Policy to the domain by dragging and dropping it in the site.lan branch.
LAB: Verify WinRM
Open a cmd prompt in the site-wef VM.
Run the gpupdate /force command to update the policies enforced on the client.
Run the gpresult /R command.
Verify the WinRM Policy appears in the results and note the output of the previous command to use in answering the next Knowledge Check.
Switch back to the site-dc VM and use a PowerShell terminal to run the following command:
```
Invoke-Command -ComputerName site-wef -ScriptBlock {1}

---

```
O:BAG:SYD:(A;;0xf0007;;;SY)(A;;0x7;;;BA)(A;;0x1;;;BO)(A;;0x1;;;SO)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;S-1-5-20)
```

 Computer Configuration\Windows Settings\Security Settings\Local Policies\User Rights Assignment

```
Test-WSMan -ComputerName
