
. "$PSScriptRoot/../MyScripts/Test-Directory.ps1"
. "$PSScriptRoot/../MyScripts/Test-File.ps1"

function Start-SudoWithPassword([String]$password, [String]$command) {
  Invoke-Expression "$password | sudo -S $command"
}

# Example: Execute-SudoWithPassword "'njuseg'" 'echo x'
# Note: We should pass string `'njuseg'`, so that it is consider as a string in the expression.

function Start-SudoPsCommandWithPassword([String]$password, [String]$command) {
  Invoke-Expression "$password | sudo -S powershell -Command $command"
}

function Start-SudoPsFileWithPassword([String]$password, [String]$psFilePath) {
  if (-not (Test-File $psFilePath)) {
    Write-Error "$psFilePath is not a vaild file." -ErrorAction Stop
  }
  
  Invoke-Expression "$password | sudo -S powershell -File $psFilePath"
}
