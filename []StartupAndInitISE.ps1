$backgroundRunScripts = @('[]Startup.ps1')
$iseScripts = @('[]Shutdown.ps1')

$vs2019IdePath = 'C:\Program Files (x86)\VS2019C\Common7\IDE\devenv.exe'

Set-Location $PSScriptRoot

# run background scripts first
foreach ($backgroundRunScript in $backgroundRunScripts){
  powershell -file $backgroundRunScript -Wait -NoNewWindow
}

# start Powershell ISE with scripts
powershell_ise.exe $iseScripts

# start Visual Studio 2019
# .$vs2019IdePath

ipconfig /renew6
