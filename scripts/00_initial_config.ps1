 Force the en-US keyboard layout
Set-WinUserLanguageList -LanguageList en-US -Force
Get-WinUserLanguageList

# Stop Server Manager auto startup on login
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose

# Enable Telnet Client
Install-WindowsFeature Telnet-Client