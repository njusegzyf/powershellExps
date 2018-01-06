# do staff after startup

# settings

# ram disk path
$ramdiskPath = 'Z:'
# hard disks path
$sourceHardDiskPath = 'E:'

[String]$projectName = 'ZYFProj'
[String]$projectArchiveName = "$projectName.rar"

[String[]]$extractItemNames = @('MatlabProjs', 'TableTest') 
#@('LFF', 'ModularDriver-ASPLOS2017'， 'ModularDriver-TACO', 'Dataflow-CN', 'ICSE2018')

$isRunRarInBackground = $false
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'
[String]$ideaExePath = 'W:/Program/IDEA17/bin/idea64.exe'

# extract other working folders
foreach ($itemName in $extractItemNames){
  if (-not (Test-Path "$ramdiskPath/$itemName")) {
    Start-Process -FilePath $winRarExePath -ArgumentList 'x',"$sourceHardDiskPath/$itemName.rar",$ramdiskPath -Wait
  }
}

# extract IDEA projects
if (-not (Test-Path "$ramdiskPath/$projectName")) { # only do the work when the folder not exists
  # copy and extract IDEA project
  $sourceProjectArchivePath = "$sourceHardDiskPath/$projectArchiveName"
  $ramDiskProjectArchivePath = "$ramdiskPath/$projectArchiveName"
  if (Test-Path $sourceProjectArchivePath) {
    Copy-Item $sourceProjectArchivePath -Destination $ramdiskPath

    # start WinRAR to extract files and wait for it done
    Start-Process -FilePath $winRarExePath -ArgumentList 'x',$ramDiskProjectArchivePath,$ramdiskPath -Wait
    # or use:
    # .'C:/Program Files/WinRAR/WinRAR.exe' x $ramDiskProjectArchivePath $ramdiskPath
    # Wait-Process -Name 'winrar'
    
    # remove the temp archive
    Remove-Item $ramDiskProjectArchivePath

    # run IDEA 
    Start-Process -FilePath $ideaExePath
    # or use:
    # .$ideaExePath
  }
}
