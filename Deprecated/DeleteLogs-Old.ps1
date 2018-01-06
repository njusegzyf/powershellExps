# 与 DeleteLogs.ps1 功能相同，但是可以运行于较老的 Windows Server 2008 中

$logLinksDir = Get-Item 'D:\PS\Resources\LogDirs'
$logLinks = $logLinksDir | Get-ChildItem

$Shell = New-Object -ComObject WScript.Shell

function Is-LogFile {
    Param([System.IO.FileSystemInfo]$file)
    Process{
        return $file.Name -match '.*\.log';
    }
}

# only delete log files (.log) in the dir recursively
function Remove-LogFiles {
    Param([System.IO.FileSystemInfo]$file)
    Process {
		# Write-Host "$file : $($file.getType())"
        if ($file -is [System.IO.FileInfo]){
            # process files
            if (Is-LogFile $file) {
                Write-Host "Delete log file: $file"
                $file.Delete()
            }
        } elseif ($file -is [System.IO.DirectoryInfo]){		
			# recursive preocess files in sub folders
			foreach ($childFile in ([System.IO.DirectoryInfo]$file).GetFileSystemInfos()) {
				Remove-LogFiles($childFile)
			}
        } else {
			Write-Host "Unknown file type: $file"
		}
    }
}

# only delete log files (.log) in the log dirs
ForEach ($logLink in $logLinks) {
  $logDir = $Shell.CreateShortcut($logLink.FullName).Targetpath | Get-Item
  Remove-LogFiles $logDir
}

Read-Host