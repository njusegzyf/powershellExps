# settings

function Get-BackupConfig {

# ram disk path
$ramdiskPath = 'Z:'
# hard disks path
$sourceHardDiskPath = 'C:\Backup'

[String]$projectName = 'ZYFProj'
[String]$projectArchiveName = "$projectName.rar"

[String[]]$itemNames = @('GraduationThesisLatexProj') # 'GraduationThesis', 
#@('LFF'， 'ModularDriver', 'Dataflow-CN', 'TableTest', 'MatlabProjs', 'SafetyBilinear')

$isRunRarInBackground = $false
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'
[String]$ideaExePath = 'C:/Program Files/IDEAC2018/bin/idea64.exe'

return $itemNames;

}

return Get-BackupConfig
