# do staff before shutdown

# get config (`$PSScriptRoot` points to the folder of the script file)
[String]$backupConfigScriptPath = "$PSScriptRoot/Get-BackupConfig"
Write-Host "Get backup config from '$backupConfigScriptPath.ps'"
. $backupConfigScriptPath

# print other working folders to be archived and copied
Write-Host "Directories to backup: { $($workingDirectories -join ', ') }"

# test directories exists
Test-BackupDirectory

# print current time and record it as last backup time
$lastBackupTime = Get-Date
Write-Host "At $lastBackupTime, Start backup."

# archive IDEA project and copy to hard
Backup-Directory $ideaProjectName

# archive other working folders
foreach ($workingDirectory in $workingDirectories){
  Backup-Directory $workingDirectory
}

# print current time
Write-Host "At $(Get-Date), End backup."

# shutdown PC in 60 seconds
# shutdown -s -t 60

# FIXME: Fix error when in a dir like `C:\Tools\[]DiskTools\storcli`,
# which occurs when we start WinRAR:
# Start-Process : 指定的通配符模式无效: []DiskTools
# it does not help using `WorkingDirectory ` parameter in `Start-Process`
