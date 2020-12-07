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

  $lsRes = adb shell ls -a $dirPath
  if ($lsRes -ne $null) {
    $rawItems =  $lsRes.trim() -split '\s+'
    $rawItems | Where-Object { ($_ -ne '.') -and ($_ -ne '..') }
  } else {
    @()
  }
  
  # Note: `adb shell ls -a $dirPath` 返回 string 数组，且每个 string 末尾有多个空白符，使用 `\s+` 分隔将产生单个空白符，因此调用 `-split` 需先调用 `trim()` :
  # `.                                6749ceffcdde19eb31dd5cf13049f4a0  `
  # `..                               710831a21b7d3dd3a081f9a14839316e  ` 
  # `047a9f4055c18c2f957e3aacd20b9207 7c0164cd13052e1517f0286eb911bc69  `
}

function List-AllAndroidChildItemOfFullPath($dirPath) {
  $childItems = List-AllAndroidChildItem $dirPath
  $childItems | ForEach-Object { "$dirPath/$_" }
}

function Test-AndroidItem($dirPath, $itemName) {
  (List-AllAndroidChildItem $dirPath | Where-Object { $_ -eq $itemName}) -ne $null
}



# sudo chmod [u所属用户  g所属组  o其他用户   a所有用户]    [+增加权限   -减少权限]   [r   w   x]   目录名
# @see [[https://blog.csdn.net/jerrytomcat/article/details/81744860]]
