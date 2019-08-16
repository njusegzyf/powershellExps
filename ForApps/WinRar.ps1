# WinRAR configs
$isRunRarInBackground = $false
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'
[String]$recoveryRecordOption = '' # '-rr2' # `-rr[N]` adds a data recovery record

function Get-CompressArgumentArgs([String]$archive, [String]$compressFolder) {
  # generate argument list, `a` is compress command, `-r` means recursive, `-m5` means use best compression method
  # and `$recoveryRecordOption`(like `-rr5`) means add a data recovery record
  # @see WinRAR Help for more information .'C:/Program Files/WinRAR/WinRAR EN.chm'
  # 参数 -EP1 -从名称中排除主文件夹 
  $compressArgs = @('a', $archive, $compressFolder, '-r', '-m5', '-ep1')
  if ($recoveryRecordOption) {
    $compressArgs = $compressArgs + @($recoveryRecordOption)
  } 
  if ($isRunRarInBackground) {
    $compressArgs = $compressArgs + @('-ibck')
  }
  return $compressArgs
}

# generate argument list
# $compressArgs = Get-CompressArgumentArgs "$ramdiskPath/$projectArchiveName" "$ramdiskPath/$projectFolderName"

# Write-Host "Archive folder $ramdiskPath/$projectFolderName to $ramdiskPath/$projectArchiveName"
# Start-Process -FilePath $winRarExePath -ArgumentList $compressArgs -Wait


