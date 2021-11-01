
# This script shutdown the pc if the RAMDisk does not contains any working directories.

$nonWorkingDirectories = @('Internet 临时文件', 'Temp', 'Tmp', '回收站', 'Cache')
$ramDiskPath = 'Z:/'
$shutdownCommand = 'ls z:/'  # 'shutdown -s -t 30'

$isIgnoreEmptyDirecories = $true
function Test-WorkingDirectory($dir) {
  if ($isIgnoreEmptyDirecories) {
    return (Get-ChildItem $dir).Length -ne 0
  } else {
    return $true
  }
}

# @note There are problems using `Get-ChildItem -Path $ramDiskPath -Exclude $nonWorkingDirectories`, use `-LiteralPath` instead.
# @see [[https://stackoverflow.com/questions/38269209/using-get-childitem-exclude-or-include-returns-nothing]]
$workingDirectories = Get-ChildItem -LiteralPath $ramDiskPath -Exclude $nonWorkingDirectories
if ($isIgnoreEmptyDirecories) {
  $workingDirectories = $workingDirectories | Where-Object -FilterScript { Test-WorkingDirectory $_ }
} 

if ($workingDirectories) {
  $joinedWsString = $workingDirectories -join ', '
  Write-Host "Some working directories still exist: $joinedWsString !"
} else {
  Write-Host "No working directorie exists, will execute shutdown command: $shutdownCommand !"
  Invoke-Expression $shutdownCommand
}
