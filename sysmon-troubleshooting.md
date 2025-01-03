1. Verify Event Log Reader Group Membership
For Event Forwarding to work correctly, the Event Log Readers group must be configured correctly on both the source and destination machines.

Check if the user is part of the "Event Log Readers" group: To verify that the user or service account running Sysmon has the correct permissions, check if they are part of the Event Log Readers group:

**powershell**

`Get-LocalGroupMember -Group "Event Log Readers"`
This command lists all users and groups in the Event Log Readers group. Ensure that the account running Sysmon (or the account you use to configure event forwarding) is a member of this group.

Add the user to the Event Log Readers group: If necessary, you can add a user to the group using:

**powershell**

`Add-LocalGroupMember -Group "Event Log Readers" -Member "<username>"`
Replace <username> with the actual username or service account.

2. Verify Permissions on Event Forwarding Subscription
If you're using Event Forwarding via Event Subscriptions, ensure the account used to configure or send the logs has the necessary permissions.

Check for Event Forwarding permissions: To ensure proper configuration of event forwarding, the sender machine (Sysmon machine) should have permission to forward events. One of the key requirements is for the forwarding client to have permission to read event logs and access Event Collector services.

On the destination (collector) machine, ensure the correct user or service account is part of the Event Log Readers group or has equivalent permissions.

3. Verify DCOM and Remote Event Log Permissions
For remote event forwarding, the Distributed COM (DCOM) permissions and Remote Event Log permissions must be properly configured.

Check DCOM permissions: You can check and configure DCOM permissions using the following steps:

Open Component Services: Press Win + R, type dcomcnfg, and press Enter.
Navigate to Component Services > Computers > My Computer.
Right-click on My Computer and select Properties.
Go to the COM Security tab.
Under Access Permissions and Launch and Activation Permissions, click on Edit Limits and Edit Default.
Ensure that the relevant user accounts or groups have Remote Access, Launch, and Activation permissions.
Verify Remote Event Log Permissions: On the destination machine, make sure that the Event Log Readers group has permission to read from remote event logs. Check the permissions of the EventLog service by running this command:

**powershell**

`Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property Caption, Version, BuildNumber`
This will give you the OS version and build, which you can use to confirm if remote event log permissions are configured for your OS version.

4. Check Access to the Event Log on Remote Machines
You can manually verify if the user account has access to the remote machine’s event logs. You can test this by attempting to connect to the remote machine's event logs with this command:

**powershell**

`wevtutil qe Security /c:5 /f:text /rd:true /s:<remote_machine_name>`
Replace <remote_machine_name> with the actual name or IP address of the remote machine. If there are permission issues, you will get an access denied error.

5. Verify Network Permissions
Ensure that there are no network or firewall issues preventing communication between the source and destination for event forwarding.

Check that the Windows Event Forwarding ports are open on both the sender and collector machines (ports 5985 for HTTP and 5986 for HTTPS).

You can test connectivity using PowerShell or telnet:

**powershell**

`Test-NetConnection -ComputerName <collector_computer> -Port 5985`
Replace <collector_computer> with the name or IP address of the event collector machine.

6. Verify Subscription Configuration
If you’re still having issues, it’s also a good idea to check the permissions associated with your event subscriptions. The Event Subscription must have the correct permissions on the destination machine. You can check the subscription configuration using:

**powershell**

`Get-WinEventSubscription`
This command will list all active subscriptions. If a subscription fails, you can check the detailed error messages in the Event Viewer for further clues.

7. Check Group Policy Settings for Event Forwarding
Group Policy settings can restrict event forwarding permissions. Ensure that the Group Policy is correctly configured to allow event forwarding.

Run the following command to see if there are any Group Policy restrictions:

**powershell**

gpresult /r
Look for Event Forwarding settings, especially under:

vbnet

Computer Configuration > Administrative Templates > Windows Components > Event Forwarding

**Conclusion**
To verify the correct permissions for Sysmon event forwarding, ensure that:

The account has the necessary membership in the Event Log Readers group.
DCOM permissions are configured properly for remote access.
Remote Event Log permissions are in place for the user/service account.
Firewalls and network settings allow communication between the source and collector machine.
Group Policy settings are not restricting event forwarding.
By following these steps, you can ensure that the required permissions are set up properly to allow Sysmon logs to be forwarded successfully.
