# WinRAR configs
$isRunRarInBackground = $false

[String]$winRarDirPath = 'C:/Program Files/WinRAR'
[String]$winRarExePath = "$winRarDirPath/WinRAR.exe"
# rar and unrar console tools are available for multiple platforms
[String]$rarExePath = "$winRarDirPath/rar.exe"

Set-Alias -Name WinRar -Value $winRarExePath
Set-Alias -Name Rar -Value $rarExePath

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



function Run-WinRarExample() {
  # generate argument list
  # $compressArgs = Get-CompressArgumentArgs "$ramdiskPath/$projectArchiveName" "$ramdiskPath/$projectFolderName"

  # Write-Host "Archive folder $ramdiskPath/$projectFolderName to $ramdiskPath/$projectArchiveName"
  # Start-Process -FilePath $winRarExePath -ArgumentList $compressArgs -Wait

  $archivePath = 'D:\BaiduNetdiskDownload\35945\[TSDM][2018][Sword Art Online Alicization][BDRIP][1080P][1-24+SP].part01.rar'
  .$rarExePath 'l' '-v' $archivePath
  # command l: 压缩文件的内容列表
  # 可以使用 -v 参数列出卷组中所有卷的内容

  Start-Process -FilePath $rarExePath -ArgumentList @('l', '-v', '"D:\BaiduNetdiskDownload\35945\[TSDM][2018][Sword Art Online Alicization][BDRIP][1080P][1-24+SP].part01.rar"')

}


