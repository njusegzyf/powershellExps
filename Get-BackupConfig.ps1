# settings, should be imported by use dot source notation (`. ./scriptFile.ps1`)

$isOutputErrorToFile = $true
$errorLogFileRootDir = 'Z:/ZyfScriptError'
$errorLogFilePath = "$errorLogFileRootDir/Error.log"
$rarErrorLogFilePath = "$errorLogFileRootDir/ErrorRar.log"

if (-not (Test-Path $errorLogFileRootDir)) {
  mkdir -p $errorLogFileRootDir
}

function Set-LogFile([String]$filePath) {
  if (-not (Test-Path $filePath)) {
    New-Item $filePath -ItemType File
  }
}
Set-LogFile $errorLogFilePath
Set-LogFile $rarErrorLogFilePath

# ram disk path
$ramdiskPath = 'Z:'
# hard disks path for get archives to extract
$sourceHardDiskPath = 'C:/Backup'
# hard disks paths to backup archives
$hardDiskPath = @($sourceHardDiskPath, 'D:/Backup')


# WinRAR configs
$isRunRarInBackground = $false
[String]$winRarExeDirPath = 'C:\Program Files\WinRAR'
[String]$winRarExePath = "$winRarExeDirPath\WinRAR.exe"
[String]$recoveryRecordOption = '' # '-rr2' # `-rr[N]` adds a data recovery record

[String]$ideaExePath = 'C:/Program Files/IDEAC2019/bin/idea64.exe'

# project configs
[String]$ideaProjectName = 'ZYFProj'
[String]$ideaProjectArchiveName = "$ideaProjectName.rar"

[String[]]$workingDirectories = @('GraduationThesisLatexProj', 'GraduationThesisPPT', 'ExcelLinqApp') # 'GraduationThesis', 
#@('LFF'， 'ModularDriver', 'Dataflow-CN', 'TableTest', 'MatlabProjs', 'SafetyBilinear')



# help functions

function Test-BackupDirectory() {
  foreach ($path in $hardDiskPath + $ramdiskPath) {
    if (-not (Test-Path $path -PathType Container)) {
      throw "Path $path is invalid, stop execution."
    }
  }
}

# Generate WinRAR compression arguments from config.
function Get-CompressArgumentArgs([String]$archive, [String]$compressFolder) {
  # generate argument list, `a` is compress command, `-r` means recursive, `-m5` means use best compression method
  # and `$recoveryRecordOption`(like `-rr5`) means add a data recovery record
  # @see WinRAR Help for more information .'C:/Program Files/WinRAR/WinRAR EN.chm'
  $compressArgs = @('a', $archive, $compressFolder, '-r', '-m5')
  if ($recoveryRecordOption) {
    $compressArgs = $compressArgs + @($recoveryRecordOption)
  } 
  if ($isRunRarInBackground) {
    $compressArgs = $compressArgs + @('-ibck')
  }
  if ($isOutputErrorToFile) {
    $compressArgs = $compressArgs + @("-ilog$rarErrorLogFilePath")
  }
  return $compressArgs
}

function Backup-Directory([String]$directoryName, [String]$directoryParent) {

  if (-not $directoryParent) {
    $directoryParent = $ramdiskPath # set to default
  }
  $directoryPath = "$directoryParent/$directoryName"
  if (Test-Path $directoryPath) { # only do work if the directory exists
    $directoryArchiveName = "$directoryName.rar"
    $directoryArchivePath = "$ramdiskPath/$directoryArchiveName"
  
    # delete archive if it already exists
    if (Test-Path  $directoryArchivePath) {
      Remove-Item $directoryArchivePath -Force
    }

    # generate argument list
    $compressArgs = Get-CompressArgumentArgs $directoryArchivePath $directoryPath

    Write-Host "Archive folder $directoryPath to $directoryArchivePath"
    Start-Process -FilePath $winRarExePath -ArgumentList $compressArgs -Wait -NoNewWindow

    <# other ways to start WinRAR
    Start-Process -FilePath "WinRar.exe" -WorkingDirectory $winRarExeDirPath -ArgumentList $compressArgs -Wait -NoNewWindow
    
    .$winRarExePath a $directoryArchivePath $directoryPath -r -m5 # archive porject 
    Wait-Process -Name 'winrar' # wait for comperssion 
    #>

    # copy to hard disks
    foreach ($hddPath in $hardDiskPath){
      Copy-Item $directoryArchivePath -Destination $hddPath
      Write-Host "Copy archive $directoryArchivePath to $hddPath/$directoryArchiveName"
    }
   
    # delete archive after copy
    Remove-Item $directoryArchivePath
  }
  
}

<#

function Get-OtherBackupFolder {

[String[]]$itemNames = @('GraduationThesisLatexProj', 'GraduationThesisPPT', 'ExcelLinqApp') # 'GraduationThesis', 
#@('LFF'， 'ModularDriver', 'Dataflow-CN', 'TableTest', 'MatlabProjs', 'SafetyBilinear')

return $itemNames;
}

return Get-OtherBackupFolder

#>