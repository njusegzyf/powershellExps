$backgroundRunScripts = @('[]Startup.ps1')
$iseScripts = @('[]Shutdown.ps1')

$isOutputErrorToFile = $true
$errorFilePath = 'Z:/Error.txt'

$vs2019IdePath = 'C:\Program Files (x86)\VS2019C\Common7\IDE\devenv.exe'

Set-Location $PSScriptRoot

# run background scripts first
foreach ($backgroundRunScript in $backgroundRunScripts){
  if ($isOutputErrorToFile) {
    powershell -file $backgroundRunScript -Wait -NoNewWindow 2>$errorFilePath
  } else {
    powershell -file $backgroundRunScript -Wait -NoNewWindow
  }
}

# start Powershell ISE with scripts
powershell_ise.exe $iseScripts

# start Visual Studio 2019
# .$vs2019IdePath

# retrieve IPv6 address
ipconfig /renew6
