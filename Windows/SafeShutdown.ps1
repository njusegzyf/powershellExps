
# This script shutdown the pc if the RAMDisk does not contains any working directories.

$nonWorkingDirectories = @('Internet 临时文件', 'Temp', 'Tmp', '回收站')
$ramDiskPath = 'Z:\'
$shutdownCommand = 'ls z:\'  # 'shutdown -s -t 30'

$workingDirectories = Get-ChildItem $ramDiskPath -Exclude $nonWorkingDirectories
if ($workingDirectories) {
  $joinedWsString = $workingDirectories -join ','
  Write-Host "Some working directories still exist: $joinedWsString !"
} else {
  Write-Host "No working directorie exists, will execute shutdown command: $shutdownCommand !"
  Invoke-Expression $shutdownCommand
}
