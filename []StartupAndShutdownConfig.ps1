Class StartupAndShutdownConfig {
    
  [String]$projectFolderName
  [String[]]$workingFolders

    # 构造函数
  StartupAndShutdownConfig([String]$projectFolderNamePar, [String[]]$workingFoldersPar) {
    $this.projectFolderName = $projectFolderNamePar
    $this.workingFolders = $workingFoldersPar
  }
}

function Get-StartupAndShutdownConfig () {

  [String]$projectFolderName = "ZYFProj"
  [String[]]$workingFolders = @('MatlabProjs')
    
  return [StartupAndShutdownConfig]::new($projectFolderName, $workingFolders)
}
