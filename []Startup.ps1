# do staff after startup

# ram disk path
$ramdiskPath = 'Z:'
# hard disks path
$sourceHardDiskPath = 'E:'

[String]$projectName = 'ZYFProj'
[String]$projectArchiveName = "$projectName.rar"

if (-not (Test-Path "$ramdiskPath/$projectName")) { # only do the work when the folder not exists
    # copy and extract IDEA project
    $sourceProjectArchivePath = "$sourceHardDiskPath/$projectArchiveName"
    $ramDiskProjectArchivePath = "$ramdiskPath/$projectArchiveName"
    if (Test-Path $sourceProjectArchivePath) {
    Copy-Item $sourceProjectArchivePath -Destination $ramdiskPath
    .'C:/Program Files/WinRAR/WinRAR.exe' x $ramDiskProjectArchivePath $ramdiskPath
    Wait-Process -Name 'winrar'
    # remove the temp archive
    Remove-Item $ramDiskProjectArchivePath
    # run IDEA
    .'W:\Program\IDEA2016\bin\idea.exe'
    }
}

# extract other working folders
[String[]]$extractItemNames = @('ModularDriver-ASPLOS2017')

foreach ($itemName in $extractItemNames){
  if (-not (Test-Path "$ramdiskPath/$itemName")) {
      .'C:/Program Files/WinRAR/WinRAR.exe' x  "$sourceHardDiskPath/$itemName.rar" $ramdiskPath
      Wait-Process -Name 'winrar'
  }
}
