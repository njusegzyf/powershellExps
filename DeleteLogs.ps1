$logLinksDir = Get-Item 'C:\Tools\`[`]LogDirs'
$logLinks = $logLinksDir | Get-ChildItem

$Shell = New-Object -ComObject WScript.Shell

# delete everything in the log dirs
ForEach ($logLink in $logLinks) {
  $logDir = $Shell.CreateShortcut($logLink.FullName).Targetpath
  $logItems = $logDir | Get-ChildItem
  ForEach ($logItem in $logItems) {
    Write-Host "Delete $logItem"
    # 注意，如果写成 `Remove-Item $logItem ...` 则会出错，此时 $logItem 作为 String 传入函数，只包含了文件名， Remove-Item 会在当前路径下定位文件
    # 需要写成 `$logItem | Remove-Item`， 此时 $logItem 作为 Pipeline 参数传入，可以正常处理
    $logItem | Remove-Item -Force -Recurse
  }
}

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