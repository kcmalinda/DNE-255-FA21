# Storyline: Review the Security Event Log

# Directory to save files:

$myDir = "C:\Users\alice.marni\Desktop\"

# List all the available windows Event logs
Get-EventLog -List
# you could type: Get-EventLog Security 
## -When run it shows what would show up when you are in event viewer (all the logs)

# Create a prompt to allow user to select the log to view
$readLog = Read-host -Prompt "Please select a log to review from the list above"
$keyWord = Read-host -Prompt "Please type a keyword or a phrase to search on"

# Print the results for the log

Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$keyWord*"} | export-csv -NoTypeInformation -Path "$myDir\$readLog.csv"