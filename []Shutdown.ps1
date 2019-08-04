# do staff before shutdown

# settings

# ram disk path
$ramdiskPath = 'Z:'
# hard disks path
$hardDiskPath = 'C:/Backup', 'D:/Backup'
$projectFolderName = "ZYFProj"

# archive other working folders and copy to hard (`$PSScriptRoot` points to the folder of the script file)
[String]$backupConfigScriptPath = "$PSScriptRoot/Get-BackupConfig"
Write-Host "Get backup config from '$backupConfigScriptPath.ps'"
[String[]]$workingFolders = .$backupConfigScriptPath
Write-Host "Folders to backup: { $($workingFolders -join ', ') }"

# WinRAR configs
$isRunRarInBackground = $false
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'
[String]$recoveryRecordOption = '' # '-rr2' # `-rr[N]` adds a data recovery record

function Get-CompressArgumentArgs([String]$archive, [String]$compressFolder) {
  # generate argument list, `a` is compress command, `-r` means recursive, `-m5` means use best compression method
  # and `$recoveryRecordOption`(like `-rr5`) means add a data recovery record
  # @see WinRAR Help for more information .'C:/Program Files/WinRAR/WinRAR EN.chm'
  $compressArgs = @('a', $archive, $compressFolder, '-r', '-m5')
  if ($recoveryRecordOption) {
    $compressArgs = $compressArgs + @($recoveryRecordOption)
  } 
  if ($isRunRarInBackground) {
    $compressArgs = $compressArgs + @('-ibck')
  }
  return $compressArgs
}



# print current time and record it as last backup time
$lastBackupTime = Get-Date
Write-Host "At $lastBackupTime, Start backup."

# archive IDEA project and copy to hard
if (Test-Path "$ramdiskPath/$projectFolderName") { # only do work if the project exists
    $projectArchiveName = "$projectFolderName.rar"
    # delete archive if it already exists
    if (Test-Path  "$ramdiskPath/$projectArchiveName") {
        Remove-Item "$ramdiskPath/$projectArchiveName" -Force
    }

    # generate argument list
    $compressArgs = Get-CompressArgumentArgs "$ramdiskPath/$projectArchiveName" "$ramdiskPath/$projectFolderName"

    Write-Host "Archive folder $ramdiskPath/$projectFolderName to $ramdiskPath/$projectArchiveName"
    Start-Process -FilePath $winRarExePath -ArgumentList $compressArgs -Wait
    # .$winRarExePath a "$ramdiskPath/$projectArchiveName" "$ramdiskPath/$projectFolderName" -r -m5 # archive porject 
    # Wait-Process -Name 'winrar' # wait for comperssion done 

    # copy to hard disks
    foreach ($hddPath in $hardDiskPath){
        Copy-Item "$ramdiskPath/$projectArchiveName" -Destination "$hddPath"
        Write-Host "Copy archive $ramdiskPath/$projectArchiveName to $hddPath/$projectArchiveName"
    }
    # delete archive after copy
    Remove-Item "$ramdiskPath/$projectArchiveName"
}

foreach ($workingFolder in $workingFolders){
    # continue if folder not exists
    if (-not (Test-Path "$ramdiskPath/$workingFolder")){ # -not (Get-Item "$ramdiskPath/$workingFolder").Exists
        continue;
    }

    if (Test-Path  "$ramdiskPath/$workingFolder.rar") {
        Remove-Item "$ramdiskPath/$workingFolder.rar" -Force
    }

    # generate argument list
    $compressArgs = Get-CompressArgumentArgs "$ramdiskPath/$workingFolder.rar" "$ramdiskPath/$workingFolder"

    $ramdiskWorkingFolderArchiveFullPath = "$ramdiskPath/$workingFolder.rar"
    Write-Host "Archive folder $ramdiskPath/$workingFolder to $ramdiskWorkingFolderArchiveFullPath"
    Start-Process -FilePath $winRarExePath -ArgumentList $compressArgs -Wait

    # copy to hard disks
    foreach ($hddPath in $hardDiskPath){
        Copy-Item $ramdiskWorkingFolderArchiveFullPath -Destination $hddPath
        Write-Host "Copy archive $ramdiskWorkingFolderArchiveFullPath to $hddPath/$workingFolder.rar"
    }
    # delete archive after copy
    Remove-Item "$ramdiskPath/$workingFolder.rar"
}

# print current time
Write-Host "At $(Get-Date), End backup."

# shutdown PC in 60 seconds
# shutdown -s -t 60
