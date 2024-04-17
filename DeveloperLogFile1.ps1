# Set the execution policy to bypass for the current session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Define the path to your log file
$logFilePath = "C:\ProgramData\ScriptLog.txt"

# Clear the log file if it already exists
Clear-Content -Path $logFilePath -ErrorAction SilentlyContinue

# Run "winget list" command to get the installed applications
$availableAppsCommand = "echo Y | winget upgrade"
$upgradeApps = Invoke-Expression -Command $availableAppsCommand

# Specify the list of application names you want to upgrade
$appNames = @(
    "Google.Chrome",
    "7zip.7zip",
    "Mozilla.Firefox",
    "Adobe.Acrobat.Reader.64-bit",
    "SonicWALL.GlobalVPN",
    "Git.Git",
    "Notepad++.Notepad++",
    "Microsoft.VisualStudioCode",
    "TortoiseGit.TortoiseGit", 
    "TortoiseSVN.TortoiseSVN"
)

# Loop through each application in the list
foreach ($appName in $appNames) {
    if ($upgradeApps -contains $appName) {
        # Run "winget upgrade" command
        $upgradeCommand = "winget upgrade $appName"
        $upgradeOutput = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $upgradeCommand" -Wait -PassThru -NoNewWindow | Out-String

        if ($upgradeOutput -like "*A newer version was found, but the install technology is different from the current version installed.*") {
            # Log the upgrade output to the file
            $upgradeOutput | Out-File -FilePath $logFilePath -Append
        }
    }
    elseif ($upgradeApps -notcontains $appName) {
        # Log the installation command to the file
        $installCommand = "winget install --id $appName --silent"
        $installOutput = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $installCommand" -Wait -PassThru -NoNewWindow | Out-String
        $installOutput | Out-File -FilePath $logFilePath -Append
    }
}

# Informative message
Write-Host "Script execution completed. Log file saved to: $logFilePath"
