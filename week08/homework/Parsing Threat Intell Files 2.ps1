# Array of websties containing threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt','https://feodotracker.abuse.ch/downloads/ipblocklist_recommended.txt')

# Loop through the URLS for the rules list
foreach ($u in $drop_urls) {
   
   # Extract the filename
   $temp = $u.split("/")
   $file_name = $temp[4]
   
   if (Test-Path $file_name) {

    continue

   } else {
   # The last element in the array plucked off is the filename

        # Download the rules list
        Invoke-WebRequest -Uri $u -OutFile $file_name

       } # close if statment 

   } # close the foreach loop

# Array containing the filename
$input_paths = @('.\compromised-ips.txt','emerging-botcc.rules','ipblocklist_recommended.txt')

# Extract the IP addresses.
# 108.190.109.107
# 108.191.2.72
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list.
Select-String -Path $input_paths -Pattern $regex_drop | `
ForEach-Object {$_.Matches } |`
ForEach-Object {$_.Value } | Sort-Object | get-unique | `
Out-File -FilePath "ips-bad.tmp"

# Get the IP addresses to the temporary IP list. 
# After the IP address add the reamining IPTables syntax and save the results to a file.
# iptables -A INPUT -s 108.191.2.72 (IP) -j DROP
# Creating a prompt to allow the user to search what they want



$roles = Read-host -Prompt "Select a ruleset between, IPTables, CISCO, and WINDOWS"

switch ($roles) {

    'IPTables'    {   (Get-Content -Path ".\ips-bad.tmp") | % `
    { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} `
    | Out-File -FilePath "iptables.bash"

    }

    'CISCO'    {   (Get-Content -Path ".\ips-bad.tmp") | % `
    { $_ -replace "^", "access-list 1 deny host " -replace ""} `
    | Out-File -FilePath "CISCO.txt"

    }

    'WINDOWS'    {   (Get-Content -Path ".\ips-bad.tmp") | % `
    { $_ -replace "^", "netsh advfirewall firewall add rule name='IP Block' dir=in interface=any action=block remoteip=" -replace ""} `
    | Out-File -FilePath "WINDOWS.bat"

    }
}
