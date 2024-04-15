# Direct link to the raw content of the script on GitHub
$scriptPath = "https://raw.githubusercontent.com/RavichandranMe/SoftwareUpdater/main/Developers.ps1"

# Get the current hour
$currentHour = (Get-Date).Hour

# Calculate the next run time based on the current hour
$nextRunTime = (Get-Date).Date.AddDays(1).AddHours($currentHour)

# Create a TimeSpan object for the repetition interval
$repetitionInterval = New-TimeSpan -Hours 1

# Create a new scheduled task trigger
$trigger = New-ScheduledTaskTrigger -Once -At $nextRunTime -RepetitionInterval $repetitionInterval

# Define the action with elevated privileges
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File $scriptPath -Verb runas -WindowStyle hidden"

# Register the scheduled task
try {
    Register-ScheduledTask -TaskName "Updater" -Trigger $trigger -Action $action -RunLevel Highest -ErrorAction Stop

    # Informative message
    Write-Host "Successfully created a scheduled task to run '$scriptPath' every hour with admin privileges."
}
catch {
    Write-Host "Failed to create the scheduled task: $_" -ForegroundColor Red
}

# Verbose output
$VerbosePreference = "Continue"
Write-Verbose "Script execution completed."

# Pause to keep the window open
Read-Host -Prompt "Press Enter to exit"
