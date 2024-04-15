# Define the path to your PowerShell script
#$scriptPath = "C:\Users\RavichandranEttappar\Desktop\AutoUpdate\New\Developers.ps1"  # Replace with your actual script path
$scriptPath = "https://github.com/RavichandranMe/SoftwareUpdater/blob/main/Developers.ps1"

# Get the current hour
$currentHour = (Get-Date).Hour

# Calculate the next run time based on the current hour
$nextRunTime = (Get-Date).Date.AddDays(1).AddHours($currentHour)

# Create a new scheduled task trigger
$trigger = New-ScheduledTaskTrigger -Once -At $nextRunTime -RepetitionInterval "01:00:00"


# Define the action with elevated privileges
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File $scriptPath -Verb runas"

# Create a credential object with administrator credentials
#$cred = Get-Credential

# Register the scheduled task with credentials
Register-ScheduledTask -TaskName "Updater" -Trigger $trigger -Action $action -RunLevel Highest 
#-Credential $cred

# Informative message
Write-Host "Successfully created a scheduled task to run '$scriptPath' every hour with admin privileges."