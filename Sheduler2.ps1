# Define the path to your PowerShell script
$url = "https://raw.githubusercontent.com/RavichandranMe/SoftwareUpdater/main/Developers.ps1"
$scriptPath = "C:\ProgramData\DevelopersNew.ps1"
$outputLogFile = "C:\ProgramData\DevelopersNew.log"  # Define the path to the log file

# Download the script
Invoke-WebRequest -Uri $url -OutFile $scriptPath

# Get the current hour
$currentHour = (Get-Date).Hour

# Calculate the next run time based on the current hour
$nextRunTime = (Get-Date).Date.AddDays(1).AddHours($currentHour)

# Create a new scheduled task trigger
$trigger = New-ScheduledTaskTrigger -Once -At $nextRunTime -RepetitionInterval "01:00:00"

# Define the action with elevated privileges
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -NonInteractive -WindowStyle hidden  -File $scriptPath -Verb runas | Out-File $outputLogFile"  # Redirect output to the log file

# Register the scheduled task
Register-ScheduledTask -TaskName "Updater" -Trigger $trigger -Action $action -RunLevel Highest

# Informative message
Write-Host "Successfully created a scheduled task to run '$scriptPath' every hour with admin privileges. Output will be logged to '$outputLogFile'."
