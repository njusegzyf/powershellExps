
. "$PSScriptRoot/../MyScripts/Test-Directory.ps1"
. "$PSScriptRoot/../MyScripts/Test-File.ps1"

function Set-LinuxEnvironmentVariable(
  [String]$envVarName, 
  [String]$envVarValue,
  [String]$configFilePath = '/etc/profile') {

  if (($envVarName -eq $null) -or ($envVarName.Length -eq 0) -or ($envVarValue -eq $null) -or ($envVarValue.Length -eq 0)) {
    throw "Environment variable's name and value can not be null or empty."
  }

  if (-not (Test-File $configFilePath)) {
    throw "Config file: $configFilePath is not a vaild file."
  }

  "export $envVarName=$envVarValue" | Out-File -FilePath $configFilePath -Append
}
