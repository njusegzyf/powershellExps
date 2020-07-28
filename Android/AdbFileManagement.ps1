# @see [[https://www.cnblogs.com/DreamDrive/p/7706585.html Shell文件操作]]

function Remove-AndroidEmptyDirectory($dirPath) {
  adb shell rmdir $dirPath
}

function Remove-AndroidDirectoryOrFile($dirPath) {
  adb shell rm -r $dirPath
}

function Clear-AndroidDirectory($dirPath, $fileMask = "*") {
  adb shell rm -r "$dirPath/$fileMask"
}

# function New-AndroidDirectory([String]$dirPath) { adb shell mkdir $dirPath }

# Usage: 'folder', 'FilePath' | New-AndroidDirectory 
function New-AndroidDirectory([Parameter(Mandatory=$true, ValueFromPipeline=$true)][String]$dirPathPart) {
  
  begin {
    # Note: 由于 Begin 块中，如果参数是通过管道传入，则此时函数还没有接收到来自管道的输入数据，因此 $dirPathPart 变量为 default value ($null)
    # ($args 为空数组，代表来自管道的输入对象的自动变量 $input 也为 null)
    # 故此处我们无法判断从管道输入的参数是否为 null 或为数组空

    # if ((-not $dirPathPart) -or ($dirPathPart.Length -eq 0)) { throw "Directory parts can not be null or empty." }

    [String]$realDirPath = ''
  }

  process {
    # add `$dirPathPart` and a path seperator if it is not the first path
    $realDirPath += if ($realDirPath.Length -ne 0) { "/$dirPathPart" } else { $dirPathPart }
    # Write-Host "Make dir: $realDirPath."
    adb shell mkdir $realDirPath
  }
}

# Usage: New-AndroidDirectory2 'folder', 'FilePath'
function New-AndroidDirectory2([String[]]$dirPathParts) {
  if ((-not $dirPathParts) -or ($dirPathParts.Length -eq 0)) { 
    throw "Directory parts can not be null or empty."
  }

  [String]$realDirPath = ''

  foreach ($dirPathPart in $dirPathParts) {
    # add `$dirPathPart` and a path seperator if it is not the first path
    $realDirPath += if ($realDirPath.Length -ne 0) { "/$dirPathPart" } else { $dirPathPart }
    # Write-Host "Make dir: $realDirPath."
    adb shell mkdir $realDirPath
  }
}

function New-AndroidEmptyFile($filePath) {
  adb shell touch $filePath
  # adb shell echo > $filePath
}

function New-AndroidNonEmptyFile($filePath, [String]$fileContent = 'fakeContent') {
  if (-not $fileContent) { $fileContent = 'fakeContent'}
  adb shell echo $fileContent > $filePath
}

function New-AndroidNonEmptyDirectory($dirPath, [String]$filePath = 'fakeFile', [String]$fileContent = 'fakeContent') {
  New-AndroidDirectory $dirPath
  New-AndroidNonEmptyFile "$dirPath/$filePath" $fileContent
}

function List-AllAndroidChildItem($dirPath) {
  adb shell ls -a $dirPath
}

# sudo chmod [u所属用户  g所属组  o其他用户   a所有用户]    [+增加权限   -减少权限]   [r   w   x]   目录名
# @see [[https://blog.csdn.net/jerrytomcat/article/details/81744860]]
