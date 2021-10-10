
$scriptFileDirPath = if ($PSScriptRoot) { $PSScriptRoot } else { 'C:/Tools/PS' }

# disables Windows Update
. "$scriptFileDirPath/Windows/WindowsUpdate.ps1"
Disable-WindowsUpdateRelatedService
