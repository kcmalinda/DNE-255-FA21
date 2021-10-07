# use the Get-WMI cmdlet
#Get-WmiObject -Class Win32_service | select Name, PathName, ProcessIds
## Run this cmdlet and save it to a file and if there is a suspected compromise system, you could compare this orginal file to the suspected compromised system to see if there is a new service that is running 
## Rath will be different if malicious, pay attention to path, not just the name.


# Get-WMIobject -list
## On the left hand side there are classes that you can modify
 
# get-wmiobject -list | where { $_.Name -ilike "win32_*" } | sort-object
## "win32_n*" or "win32_[n-o]*" is going to sort 'n' and 'o' and it will only list those paticular classes
## sort-object is going to look at the first collum and sort in alphabetical order.
## Added the (*) to only receive the classes I'm looking for. In this case, I am only looking for win32 service classes.

#Get-wmiobject -Class win32_Account | Get-Member
## ^ List all accounts for local systems and domain as well (users and groups on a system)
## (when adding get-memeber to the line) Install date is important to see if the user is legit 
## SID is great since there is a local string for administrators, you can see if someone created an account or elevated an exisiting account as admin
## Password required is important because a person would like to not have a password to get into an account, so they could set that up for them to log in later on
## Password expires and password required good for system admins to review
## Some of the settings you will not be able to see if you are no an administrator 

# Task: Grab the network adapter information using the WMI classes ("FILTER AND LOOK FOR THE ADAPTER INFORMATION AND THEN PRINT THE INFORMATION TO THE SCREEN AND THE OUTPUT DOES NOT NEED TO LOOK LIKE IPCONFIG")
# Get the IP address, default gateway, and the DNS servers.
# BONUS: get the DHCP server (some malware install their own DHCP server, so that clients will be forced to use it for whatever the malicious purposes are).


#Get-WmiObject -Class Win32_Service -Filter "State='Running'"
#Get-wmiobject -Class win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE
#ipconfig /all 

#get-wmiobject -list | where { $_.Name -ilike "win32_[n]*" } | sort-object

#Get-WmiObject -Class Win32_NetworkAdapterSetting
#Get-wmiobject -Class Win32_NetworkAdapterConfiguration | Get-Member
#Get-WmiObject -Class Win32_NetworkAdapter

Get-WmiObject -Class Win32_NetworkAdapterConfiguration | select IPAddress, DefaultIPGateway, DNSServerSearch0rder, DHCPServer

