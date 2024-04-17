# Set the execution policy to bypass for the current session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

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

# Check each application in the list for upgrade
foreach ($appName in $appNames) {
    if ($upgradeApps -contains $appName) {
        # Run "winget upgrade" command
        $upgradeCommand = "winget upgrade $appName"
        $upgradeOutput = Invoke-Expression -Command $upgradeCommand

        if ($upgradeOutput -like "*A newer version was found, but the install technology is different from the current version installed.*") {
            # Uninstall the current version
            $uninstallCommand = "winget uninstall --id $appName --silent"
            $uninstallOutput = Invoke-Expression -Command $uninstallCommand

            # Install the newer version
            $installCommand = "winget install --id $appName --silent"
            $installOutput = Invoke-Expression -Command $installCommand
        }
    }
    elseif ($upgradeApps -notcontains $appName) {
        $wingetAppsList = "echo Y | winget list"
        $availableApps = Invoke-Expression -Command $wingetAppsList
        if ($availableApps -contains $appName) {
            # Application is already up to date
        }
        else {
            # Install the application
            $installCommand = "winget install --id $appName --silent"
            $installOutput = Invoke-Expression -Command $installCommand
        }
    }
}
