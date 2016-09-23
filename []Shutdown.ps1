# do staff before shutdown

# print current time
Write-Host "At $(Get-Date), Start backup."

# ram disk path
$ramdiskPath = 'Z:'
# hard disks path
$hardDiskPath = 'E:', 'W:'

# archive IDEA project and copy to hard

$projectFolderName = "ZYFProj"
$projectArchiveName = "$projectFolderName.rar"
# delete archive if it already exists
if (Test-Path  "$ramdiskPath\$projectArchiveName") {
    Remove-Item "$ramdiskPath\$projectArchiveName" -Force
}
# archive porject
.'C:/Program Files/WinRAR/WinRAR.exe' a "$ramdiskPath\$projectArchiveName" "$ramdiskPath\$projectFolderName\" -r -m5
# wait for comperssion done
Wait-Process -Name 'winrar'
Write-Host "Archive folder $ramdiskPath\$projectFolderName\ to $ramdiskPath\$projectArchiveName"

# copy to hard disks
foreach ($hddPath in $hardDiskPath){
    Copy-Item "$ramdiskPath\$projectArchiveName" -Destination "$hddPath\"
    Write-Host "Copy archive $ramdiskPath\$projectArchiveName to $hddPath\$projectArchiveName"
}
# delete archive after copy
Remove-Item "$ramdiskPath\$projectArchiveName"

# archive other working folders and copy to hard
[String[]]$workingFolders = @('ModularDriver-ASPLOS2017')

foreach ($workingFolder in $workingFolders){
    # continue if folder not exists
    if (-not (Test-Path "$ramdiskPath\$workingFolder")){ # -not (Get-Item "$ramdiskPath\$workingFolder").Exists
        continue;
    }

    if (Test-Path  "$ramdiskPath\$workingFolder.rar") {
        Remove-Item "$ramdiskPath\$workingFolder.rar" -Force
    } 
    # archive folder
    .'C:/Program Files/WinRAR/WinRAR.exe' a "$ramdiskPath\$workingFolder.rar" "$ramdiskPath\$workingFolder\" -r -m5 
    Wait-Process -Name 'winrar'
    Write-Host "Archive folder $ramdiskPath\$workingFolder\ to $ramdiskPath\$workingFolder.rar"

    # copy to hard disks
    foreach ($hddPath in $hardDiskPath){
        Copy-Item "$ramdiskPath\$workingFolder.rar" -Destination "$hddPath\"
        Write-Host "Copy archive $ramdiskPath\$workingFolder.rar to $hddPath\$workingFolder.rar"
    }
    # delete archive after copy
    Remove-Item "$ramdiskPath\$workingFolder.rar"
}

# print current time
Write-Host "At $(Get-Date), End backup."

# shutdown PC in 60 seconds
#shutdown -s -t 60
