
# Enable usage like:
#   Expand-Archive -Path ($ideaTarPath.FullName) -DestinationPath './IDEA'

# Usage:
#   Expand-TarXzArchive -path './Downloads/LLVM 9.0.0/Pre-Built Binaries/clang+llvm-9.0.0-x86_64-pc-linux-gnu.tar.xz' -destinationPath './LLVM' -removeDuplicateRootDirectory

. "$PSScriptRoot/../MyScripts/Test-Directory.ps1"
. "$PSScriptRoot/../MyScripts/Test-File.ps1"

function Expand-TarXzArchive(
  [String]$path, 
  [String]$destinationPath,
  [String]$tempDirectoryPath = './Temp',
  [Switch]$removeDuplicateRootDirectory) {

  # check arguments
  if ($path -notlike '*.tar.xz') {
    Write-Error "$path is not a vaild tar xz archive path." -ErrorAction Stop
  }
  if (-not (Test-File $path)) {
    Write-Error "$path is not a vaild file." -ErrorAction Stop
  }
  # make `$path` absolute path 
  $path = (Get-Item $path).FullName

  $isMadeTempFolder = $false
  if (-not (Test-Directory $tempDirectoryPath)) {
    $isMadeTempFolder = $true
    if (-not (New-Item $tempDirectoryPath -ItemType Directory)) {
      Write-Error "Temp folder path: $tempDirectoryPath is not a directory and can not be created." -ErrorAction Stop
    }
  }
  $tempDirectoryPath = (Get-Item $tempDirectoryPath).FullName
 
  if ((-not (Test-Directory $destinationPath)) -and (-not (New-Item $destinationPath -ItemType Directory))) {
    Write-Error "Destination path: $destinationPath is not a directory and can not be created." -ErrorAction Stop
  }
  $destinationPath = (Get-Item $destinationPath).FullName

  $archive = Get-Item $path
  $archiveName = $archive.Name
  $archiveDirectory = $archive.Directory

  $tempWorkDirectoryPath = "$tempDirectoryPath/Temp$archiveName"
  if (-not (New-Item $tempWorkDirectoryPath -ItemType Directory)) {
    Write-Error "Failed to create temp folder: $tempWorkDirectoryPath." -ErrorAction Stop
  }

  $movedArchivePath = "$tempWorkDirectoryPath/$archiveName"
  # move the archive to temp directory
  Move-Item $path $tempWorkDirectoryPath

  # extract the archive
  $currentLocatin = Get-Location
  Set-Location $tempWorkDirectoryPath 
  tar xvJf $movedArchivePath
  Set-Location $currentLocatin

  # move archive back
  Move-Item $movedArchivePath $archiveDirectory

  $extractedItems = Get-ChildItem $tempWorkDirectoryPath

  if ($removeDuplicateRootDirectory) {
    # if only 1 root directory extracted, remove it if required
    if (($extractedItems.Length -eq 1) -and (Test-Directory $extractedItems[0])) {
      $extractedItems = Get-ChildItem $extractedItems[0]
    }
  }

  # move extracted items to destination directory
  # Note: Use `-LiteralPath` to ensure `Move-Item` works when a path contains escape characters like `[`
  Move-Item -LiteralPath $extractedItems $destinationPath -Force

  # remove the temp folder if we created it
  if ($isMadeTempFolder) {
    Remove-Item $tempDirectoryPath -Recurse -Force
  }

}

# For .tar.xz
# tar xvJf './TestArchive1.tar.xz'

# For .tar.gz
# tar -zxvf $ideaTarPath.FullName
