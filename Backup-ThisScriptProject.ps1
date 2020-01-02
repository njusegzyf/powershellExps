
# get config (`$PSScriptRoot` points to the folder of the script file)
[String]$backupConfigScriptPath = "$PSScriptRoot/Get-BackupConfig"
Write-Host "Get backup config from '$backupConfigScriptPath.ps'"
. $backupConfigScriptPath

Backup-Directory 'PS' "$PSScriptRoot/.."
