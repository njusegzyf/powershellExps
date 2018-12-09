# @see https://blog.csdn.net/qwertyupoiuytr/article/details/75085753

# import all the functions in the script file
# Note: `$PSScriptRoot` is the folder that contains current script
. "$PSScriptRoot/../[]StartupAndShutdownConfig.ps1"

# Do something with Invoke-Parallel function
$config = Get-StartupAndShutdownConfig

# Remove-Item -Path ".\tmpScript.ps1";
