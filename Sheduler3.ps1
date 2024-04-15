# Define the path to your PowerShell script
$scriptPath = "C:\Users\RavichandranEttappar\Desktop\AutoUpdate\New\Developers.ps1"  # Replace with your actual script path

# Get the current hour
$currentHour = (Get-Date).Hour

# Calculate the next run time based on the current hour
$nextRunTime = (Get-Date).Date.AddDays(1).AddHours($currentHour)
$trigger = New-ScheduledTaskTrigger -Once -Daily -At $nextRunTime

# Start the script as a background job
Start-Job -ScriptBlock { & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath } -At $nextRunTime -RepetitionInterval "01:00:00"

# Informative message
Write-Host "Successfully scheduled '$scriptPath' to run every hour in the background."