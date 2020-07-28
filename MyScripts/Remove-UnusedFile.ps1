# `logLinksDir` contains shortcuts to directories, whose contents will be deleted
$logLinksDir = Get-Item 'C:/Tools/_LogDirs'

# specify dirctories to delete
$userName = 'dell'
$userDir = "C:/Users/$userName"
$userAppDataDir = "$userDir/AppData"

$tempDir = 'Z:/temp'

# directories whose content will be deleted
$unusedDirs = @($tempDir, "$userAppDataDir/Local/CrashDumps")

# whether delete files to recycle bin
$isMoveToRecycleBin = $true

# whether skip errors during execution
$isSkipError = $true



function Remove-ItemToRecycleBin([String]$itemFullName, $shell=(New-Object -ComObject "Shell.Application")) {
  $item = $shell.Namespace(0).ParseName((Resolve-Path $itemFullName).Path)
  $item.InvokeVerb("delete")
}

$applicationShell = New-Object -ComObject "Shell.Application"

function Remove-UnusedItem([String]$itemFullName) {
  Write-Host "Delete $itemFullName"
  if ($isMoveToRecycleBin) {
    Remove-ItemToRecycleBin $itemFullName $applicationShell
  } else {
    # 注意，如果写成 `Remove-Item $itemFullName ...` 则会出错，此时 $itemFullName 作为 String 传入函数，只包含了文件名，Remove-Item 会在当前路径下定位文件
    # 需要写成 `$itemFullName | Remove-Item`， 此时 $itemFullName 作为 Pipeline 参数传入，可以正常处理
    $itemFullName | Remove-Item -Force -Recurse
  }
}



# delete everything in the log dirs but not the log dirs themselves
$logLinks = $logLinksDir | Get-ChildItem
$scriptShell = New-Object -ComObject WScript.Shell
ForEach ($logLink in $logLinks) {
  $logDir = $scriptShell.CreateShortcut($logLink.FullName).Targetpath
  $logItems = $logDir | Get-ChildItem
  ForEach ($logItem in $logItems) {
    Remove-UnusedItem $logItem.FullName
  }
}

ForEach ($unusedDir in $unusedDirs) {
  $unusedDirItems = $unusedDir | Get-ChildItem
  ForEach ($unusedDirItem in $unusedDirItems) {
    Remove-UnusedItem $unusedDirItem.FullName
  }
}

<#
function Is-LogFile {
    Param([System.IO.FileSystemInfo]$file)
    Process{
        # 注意 ： Powershell 的转义字符是 ` 而非 \ , 因此此处的正则表达式中的 \. (字面量.) 不需要转义
        return $file.Name -match '.*\.log';
    }
}

# only delete log files (.log) in the dir recursively
function Remove-LogFiles {
    Param([System.IO.FileSystemInfo]$file)
    Process {
        if ($file | Test-Path -PathType Leaf){ # $file -is [System.IO.FileInfo]
            # process files
            if (Is-LogFile $file) {
                Write-Host "Delete $file"
                $file | Remove-Item -Force
            }
        } else {
            # recursive preocess folders
            foreach ($childFile in $file | Get-ChildItem) { # $childFileName in ([System.IO.DirectoryInfo]$file).EnumerateFiles()
                Remove-LogFiles($childFile)
            }
        }
    }
}

# only delete log files (.log) in the log dirs
ForEach ($logLink in $logLinks) {
  $logDir = $Shell.CreateShortcut($logLink.FullName).Targetpath
  $logItems = $logDir | Get-ChildItem 
  ForEach ($logItem in $logItems) {
    Remove-LogFiles $logItem
  }
}

function Get-StartMenuShortcuts{
    $Shortcuts = Get-ChildItem -Recurse "C:\Apps" -Include *.lnk
    $Shell = New-Object -ComObject WScript.Shell
    foreach ($Shortcut in $Shortcuts)
    {
        $Properties = @{
        ShortcutName = $Shortcut.Name;
        ShortcutFull = $Shortcut.FullName;
        ShortcutPath = $shortcut.DirectoryName
        Target = $Shell.CreateShortcut($Shortcut.FullName).Targetpath
        }
        New-Object PSObject -Property $Properties
    }

    [Runtime.InteropServices.Marshal]::ReleaseComObject($Shell) | Out-Null
}

$Output = Get-StartMenuShortcuts
Write-Host $Output

# remove shortcuts pointing to a specific executable

function Get-StartMenuShortcuts{
    $DesktopShortcuts = Get-ChildItem -ErrorAction SilentlyContinue -Recurse "C:\Users" -Include *.lnk
    $StartMenuShortcuts = Get-ChildItem -ErrorAction SilentlyContinue -Recurse "C:\ProgramData\Microsoft\Windows\Start Menu" -Include *.lnk

    $Shortcuts = $DesktopShortcuts + $StartMenuShortcuts

    $Shell = New-Object -ComObject WScript.Shell
    foreach ($Shortcut in $Shortcuts)
    {
        $Properties = @{
        ShortcutName = $Shortcut.Name;
        Path = $Shortcut.FullName;
        ShortcutDirectory = $shortcut.DirectoryName
        Target = $Shell.CreateShortcut($Shortcut.FullName).targetpath
        }
        New-Object PSObject -Property $Properties
    }

    [Runtime.InteropServices.Marshal]::ReleaseComObject($Shell) | Out-Null
}

$ShortcutList = Get-StartMenuShortcuts
$ShortcutList | Where-Object{$_.Target -like "*MyProgram.exe"} | Remove-Item -ErrorAction SilentlyContinue
#>
