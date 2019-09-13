# settings

# base folder path
$baseFolderPath = 'Z:/GraduationThesisPPT'

$isRunRarInBackground = $true
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'

$isMoveToRecycleBin = $true

$isShowArchiveTestResult = $true

$isSkipUnknownItems = $true
$isShowUnknownItems = $false

function Remove-ItemToRecycleBin([String]$itemPath, $sehll = (New-Object -ComObject "Shell.Application")) {
  $item = $shell.Namespace(0).ParseName((Resolve-Path $itemPath).Path)
  $item.InvokeVerb("delete")
}

$allowArchiveExtensions = @('.rar', '.zip', '.7z', '.tar')
function Is-Archive([String]$itemExtension) {
  $allowArchiveExtensions -contains $itemExtension
}

function Remove-BrokenArchiveRec($folder) {
  if ($isMoveToRecycleBin) {
    $shell = New-Object -ComObject "Shell.Application"
  }

  foreach ($subItem in ($folder | Get-ChildItem)) {
    if (($subItem -is [System.IO.FileInfo]) -and (Is-Archive $subItem.Extension)) {
      # generate argument list
      $args = @('T', "`"$( $subItem.FullName )`"", '-Y')
      if ($isRunRarInBackground) {
        $args = $args + @('-ibck')
      }

      # Write-Host $args

      $process = Start-Process -FilePath $winRarExePath -ArgumentList $args -NoNewWindow -PassThru -Wait
      if ($process.ExitCode -ne 0) {
        if ($isShowArchiveTestResult) {
          Write-Host "Test `"$( $subItem.FullName )`" failed."
        }
        Write-Host "Delete item: `"$( $subItem.FullName )`"."
        if ($isMoveToRecycleBin) {
          Remove-ItemToRecycleBin $subItem.FullName $shell
        } else {
          $subItem | Remove-Item -Force
        }
      } else {
        if ($isShowArchiveTestResult) {
          Write-Host "Test `"$( $subItem.FullName )`" succeeded."
        }
      }

    } elseif ($subItem -is [System.IO.DirectoryInfo]) {
      Remove-BrokenArchiveRec $subItem
    } else {
      if ($isSkipUnknownItems) {
        if ($isShowUnknownItems) { Write-Host "Unknown Item: $( $subItem.FullName )." }
      } else {
        Write-Error "Unknown Item: $( $subItem.FullName )." -ErrorAction Stop
      }
    }
  }
}

# print current time
Write-Host "At $( Get-Date ), Start work."

if (Test-Path $baseFolderPath) {
  Remove-BrokenArchiveRec (Get-Item $baseFolderPath)
} else {
  Write-Error "Wrong path: $( $baseFolderPath )."
}

# print current time
Write-Host "At $( Get-Date ), End work."
