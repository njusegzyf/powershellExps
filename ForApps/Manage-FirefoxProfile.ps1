# Note: Firefox should be closed before backup.

$userName = 'dell'
$profileId = '8f9hc7x1'

$backupFolderPath = 'Z:'

$isBackupLocalProfile = $false

$localAllProfilesFolderPath = "C:\Users\$userName\AppData\Local\Mozilla\Firefox\Profiles"
$roamingAllProfilesFolderPath = "C:\Users\$userName\AppData\Roaming\Mozilla\Firefox\Profiles"

$localProfileFolderPath = "$localAllProfilesFolderPath\$profileId.default"
$roamingProfileFolderPath = "$roamingAllProfilesFolderPath\$profileId.default"

# import WinRar script
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'
$winRarScriptPath = "$PSScriptRoot/WinRar.ps1"
.$winRarScriptPath

# check Firefox is not running
if (Get-Process -Name 'Firefox' -ErrorAction SilentlyContinue) {
  throw 'Firefox should be closed before backup.'
}

# check profile path
if (!(Test-Path $localProfileFolderPath -PathType Container) -or !(Test-Path $roamingProfileFolderPath -PathType Container)) {
  throw 'Error profile path.'
}

# for local profile
if ($isBackupLocalProfile) {
  $localProfileBackupArchivePath = "$backupFolderPath/$profileId.default.local.rar"
  $compressArgs = Get-CompressArgumentArgs $localProfileBackupArchivePath $localProfileFolderPath
  # delete archive if it already exists
  if (Test-Path  $localProfileBackupArchivePath) {
    Remove-Item $localProfileBackupArchivePath -Force
  }
  Start-Process -FilePath $winRarExePath -ArgumentList $compressArgs -Wait
}

# for roaming profile (which contains plugins and configs)
$roamingProfileBackupArchivePath = "$backupFolderPath/$profileId.default.roaming.rar"
$compressArgs = Get-CompressArgumentArgs $roamingProfileBackupArchivePath $roamingProfileFolderPath
# delete archive if it already exists
if (Test-Path  $roamingProfileBackupArchivePath) {
  Remove-Item $roamingProfileBackupArchivePath -Force
}
Start-Process -FilePath $winRarExePath -ArgumentList $compressArgs -Wait
