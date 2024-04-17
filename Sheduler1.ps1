# Define the path to your PowerShell script
$url = "https://raw.githubusercontent.com/RavichandranMe/SoftwareUpdater/main/DeveloperLogFile.ps1"
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
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File $scriptPath -WindowStyle Hidden" 

# Register the scheduled task
Register-ScheduledTask -TaskName "Updater" -Trigger $trigger -Action $action -RunLevel Highest

# Informative message
Write-Host "Successfully created a scheduled task to run '$scriptPath' every hour with admin privileges."

# Start the scheduled task to execute immediately
Start-ScheduledTask -TaskName "Updater"

# Wait for the task to complete
Start-Sleep -Seconds 10

# Check if the log file exists
if (Test-Path $outputLogFile) {
    Write-Host "Log file generated successfully: $outputLogFile"
} else {
    Write-Host "Failed to generate log file."
}
