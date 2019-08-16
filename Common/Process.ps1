# Get-Process
Get-Process | Where {$_.mainWindowTItle} | Format-Table id,name,mainwindowtitle -AutoSize



# Run processes

$sourceDirPath = 'C:\ProjVs'
$projectName = 'CppSolution'
$slnName = "$projectName.sln"

$vsPath = 'C:\Program Files (x86)\VS2017\Community\Common7\IDE'
$vsExePath = "$vsPath\devenv.exe"

# run vs
&$vsExePath "$sourceDirPath\$projectName\$slnName"
.$vsExePath "$sourceDirPath\$projectName\$slnName"