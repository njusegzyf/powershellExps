# import `Test-Directory` function
. "$PSScriptRoot/Test-Directory.ps1"

function Copy-Module {
  param([Parameter(Mandatory=$true,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String]$moduleName,

        [String]$moduleBaseDir)
  
  begin {
    # check module base directory exists and is a directory or a driver
    if (-not (Test-Directory $moduleBaseDir)) {
      throw "$moduleBaseDir is not a directory!"
    }

    # $Variable:ConfirmPreference = "None"

    # get user PS module path 
    # `$env:PSModulePath` looks like "C:\Users\dell\Documents\WindowsPowerShell\Modules;C:\Program Files (x86)\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\"
    $psModulePath = ($env:PSModulePath -split ';')[0]
  }

  # copy each module
  process {
    # check whether module exists 
    if (-not (Test-Directory "$moduleBaseDir/$moduleName")) {
      throw "Module $moduleName does not exists in $moduleBaseDir!"
    }

    # remove the module if it exists
    try {
      if (Test-Path "$psModulePath/$moduleName"){
        Remove-Item "$psModulePath/$moduleName" -Recurse
        Remove-Module $moduleName -ErrorAction Ignore
      }
    } catch{
      $CurrentError | Write-Host
    }

    # copy module
    Copy-Item -Path "$moduleBaseDir/$moduleName" -Destination "$psModulePath/" -Recurse
  }

  end {}
}

# Import-Module $moduleName
