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
Start-Process -FilePath $vsExePath -ArgumentList @("$sourceDirPath\$projectName\$slnName")

# -Wait will block the comlet until the process completes/stops
# @see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/start-process
Start-Process 'C:\Program Files (x86)\Npp\notepad++.exe' -WindowStyle Maximized -Wait

# -PassThru returns a process object for each process that the cmdlet started.
# TypeName:System.Diagnostics.Process
$wineditProcess = Start-Process 'C:\Program Files (x86)\Npp\notepad++.exe' -PassThru -Wait

Start-Process 'C:\Program Files (x86)\Npp\notepad++.exe' -Wait `
  -RedirectStandardOutput 'Z:/out.txt' -RedirectStandardError 'Z:/error.txt'
