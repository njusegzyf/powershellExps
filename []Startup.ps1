# do staff after startup

# settings

# ram disk path
$ramdiskPath = 'Z:'
# hard disks path
$sourceHardDiskPath = 'E:'

[String]$projectName = 'ZYFProj'
[String]$projectArchiveName = "$projectName.rar"

$isRunRarInBackground = $false
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'
[String]$ideaExePath = 'W:\Program\IDEA2016\bin\idea.exe'



if (-not (Test-Path "$ramdiskPath/$projectName")) { # only do the work when the folder not exists
    # copy and extract IDEA project
    $sourceProjectArchivePath = "$sourceHardDiskPath/$projectArchiveName"
    $ramDiskProjectArchivePath = "$ramdiskPath/$projectArchiveName"
    if (Test-Path $sourceProjectArchivePath) {
        Copy-Item $sourceProjectArchivePath -Destination $ramdiskPath
        # .'C:/Program Files/WinRAR/WinRAR.exe' x $ramDiskProjectArchivePath $ramdiskPath
        # Wait-Process -Name 'winrar'
        Start-Process -FilePath $winRarExePath -ArgumentList 'x',$ramDiskProjectArchivePath,$ramdiskPath -Wait
        # remove the temp archive
        Remove-Item $ramDiskProjectArchivePath
        # run IDEA
        # .$ideaExePath
        Start-Process -FilePath $ideaExePath
    }
}

# extract other working folders
[String[]]$extractItemNames = @('ModularDriver-TACO') #@('ModularDriver-ASPLOS2017')

foreach ($itemName in $extractItemNames){
  if (-not (Test-Path "$ramdiskPath/$itemName")) {
    Start-Process -FilePath $winRarExePath -ArgumentList 'x',"$sourceHardDiskPath/$itemName.rar",$ramdiskPath -Wait
  }
}
