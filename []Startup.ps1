# do staff after startup

# get config (`$PSScriptRoot` points to the folder of the script file)
[String]$backupConfigScriptPath = "$PSScriptRoot/Get-BackupConfig"
Write-Host "Get backup config from '$backupConfigScriptPath.ps'"
. $backupConfigScriptPath

# only do the works when the target folder not exists, otherwise do nothing and just return
if (Test-Path "$ramdiskPath/$ideaProjectName") {
  Write-Error "The target directory $ramdiskPath/$ideaProjectName exists, stop work." -ErrorAction Stop
  # return
}

# extract other working folders
foreach ($itemName in $workingDirectories){
  if (-not (Test-Path "$ramdiskPath/$itemName")) {
    Start-Process -FilePath $winRarExePath -ArgumentList 'x',"$sourceHardDiskPath/$itemName.rar",$ramdiskPath -Wait
  }
}

# extract IDEA project

# copy and extract IDEA project
$sourceIdeaProjectArchivePath = "$sourceHardDiskPath/$ideaProjectArchiveName"
$ramDiskIdeaProjectArchivePath = "$ramdiskPath/$ideaProjectArchiveName"
if (Test-Path $sourceIdeaProjectArchivePath) {
  Copy-Item $sourceIdeaProjectArchivePath -Destination $ramdiskPath
  # start WinRAR to extract files and wait for it done
  Start-Process -FilePath $winRarExePath -ArgumentList @('x', $ramDiskIdeaProjectArchivePath, $ramdiskPath) -Wait
  # or use:
  # .'C:/Program Files/WinRAR/WinRAR.exe' x $ramDiskIdeaProjectArchivePath $ramdiskPath
  # Wait-Process -Name 'winrar'

  # remove the temp archive
  Remove-Item $ramDiskIdeaProjectArchivePath

  # run IDEA 
  Start-Process -FilePath $ideaExePath
  # or use:
  # .$ideaExePath
}
