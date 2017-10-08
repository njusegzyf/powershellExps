# settings

# TomTom MySports records folder path
$tomtomRecordsFolder = ''
# dest folder path
$destFolderPath = 'Z:'

$isDeleteRecords = $false

$isRunRarInBackground = $false
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'

$isInAutoMode = $false



# print current time
Write-Host "At $(Get-Date), Start compress TomTom MySports records."

# archive IDEA project and copy to hard
if (Test-Path $tomtomRecordsFolder) { # only do work if the records folder exists
  foreach ($recordFolder in Get-ChildItem $tomtomRecordsFolder) {
    if ($recordFolder -is [IO.DirectoryInfo]) { # Test-Path $recordFolder -PathType Container
      $archiveName = "$($recordFolder.Name).zip"
      $recordFolder | Compress-Archive -DestinationPath $archiveName -CompressionLevel Optimal

      if ($isDeleteRecords) {
        $recordFolder | Remove-Item -Force -Recurse
      }
    }
  }
}

# print current time
Write-Host "At $(Get-Date), End compress TomTom MySports records."

if (-not $isInAutoMode) {
  Read-Host
}
