 
# $configRes =  .'~/Desktop/PS/ForApps/Adb/Config-AdbEnvironment.ps1'
if (-not (."$PSScriptRoot/Config-AdbEnvironment.ps1")) {
  throw "Failed to start adb server or can not linke to device."
}

. "$PSScriptRoot/AdbFileManagement.ps1"

$appToPackageNameMap = ."$PSScriptRoot/Get-AndroidPackageNames.ps1"
$appToPackageNameMapWithPrefix = New-MapWithPrefix($appToPackageNameMap, 'package:')



# clean settings

$isCleanWexin = $false

$isFullClean = $true

# clean all data folders created by some app after installed
$isCleanUninstalledAppData = $true
$isConfirmCleanUninstalledAppData = $true
$allInstallAppNames = adb shell pm list packages



# store files and directories that should be cleaned
[String[]]$cleanFiles = @()
[String[]]$cleanDirectories = @()
[String[][]]$cleanDirectoriesWithMasks = @()

function Prepare-CleanContentForUninstalledApp($appName, [String[]]$appCleanDirectories = @(), [String[]]$appCleanFiles = @()) {
  $appPackageName = $appToPackageNameMap[$appName]
  if (-not $appPackageName) {
    throw "Unknown app name: $appName."
  }

  if ($isCleanUninstalledAppData -and (-not $allInstallAppNames -contains $appPackageName)) {
    if ($isConfirmCleanUninstalledAppData) {
      # TODO: Show confirm dialog
      Write-Host "Clean unistalled app data: $appName."
      # $Global:cleanDirectories += $appCleanDirectories
      # $Global:cleanFilse += $appCleanFiles
    }
  }
}



# Ali

# 高德地图
Prepare-CleanContentForUninstalledApp -appName 'autoNaviMap' -appCleanDirectories @("$internalStorageRootPath/autonavi", "$internalStorageRootPath/at")


# Tencent
$tencentRootFolderName = 'TENCENT'

# JD

# 京东读书
$jdReaderRootFolderName = 'JDReader'
$cleanDirectories += "$internalStorageRootPath/$jdReaderRootFolderName/cache"
Prepare-CleanContentForUninstalledApp -appName 'jdReader' -appCleanDirectories @("$internalStorageRootPath/$jdReaderRootFolderName")


# Others

# 什么值得买
$smzdmRootFolderName = 'SMZDM'
$smadmPackageName = $appToPackageNameMap['smzdm']
$cleanDirectoriesWithMasks += ,("$internalStorageAndroidDataPath/$smadmPackageName/cache", '*.apk') # installed updates
Prepare-CleanContentForUninstalledApp -appName 'smzdm' -appCleanDirectories @("$internalStorageRootPath/$smzdmRootFolderName")



# do clean

function Log-CleanFile($filePath) { 
  if ($isDebug) { Write-Host "Delete file: $filePath." } 
}

function Log-CleanDirectory($directoryPath) { 
  if ($isDebug) { Write-Host "Delete all files in directory: $directoryPath." } 
}

function Log-CleanDirectoryWithMask($directoryPath, $fileMask) { 
  if ($isDebug) { Write-Host "Delete files with mask $fileMask in directory: $directoryPath." } 
}

foreach ($cleanFile in $cleanFiles) {
  Log-CleanFile $cleanFile
  Remove-AndroidDirectoryOrFile $cleanFile
}

foreach ($cleanDirectory in $cleanDirectories) {
  Log-CleanDirectory $cleanDirectory
  Clear-AndroidDirectory $cleanDirectory
}

foreach ($cleanDirectoryWithMask in $cleanDirectoriesWithMasks) {
  $cleanDirectory, $mask = $cleanDirectoryWithMask
  Log-CleanDirectory $cleanDirectory
  Clear-AndroidDirectory $cleanDirectory -fileMask $mask
}
