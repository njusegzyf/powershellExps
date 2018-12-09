# settings

# base folder path
$baseFolderPath = 'Z:/1'

$isRunRarInBackground = $true
[String]$winRarExePath = 'C:/Program Files/WinRAR/WinRAR.exe'

$isMoveToRecycleBin = $true

function Remove-ItemToRecycleBin([String]$itemPath, $sehll=(New-Object -ComObject "Shell.Application")) {

    $item = $shell.Namespace(0).ParseName((Resolve-Path $itemPath).Path)
    $item.InvokeVerb("delete")
}

function Remove-BrokenArchiveRec($folder) {

    if ($isMoveToRecycleBin) {
        $shell = New-Object -ComObject "Shell.Application"
    }

    foreach ($subItem in ($folder | Get-ChildItem)) {
       if ($subItem -is [System.IO.FileInfo]){

           # generate argument list
           $args = @('T', "`"$($subItem.FullName)`"", '-Y')
           if ($isRunRarInBackground) {
               $args = $args + @('-ibck')
           }

           # Write-Host $args

           $process = Start-Process -FilePath $winRarExePath -ArgumentList $args -NoNewWindow -PassThru -Wait
           if ($process.ExitCode -ne 0) {
               Write-Host "Delete item: $($subItem.FullName)."
               if ($isMoveToRecycleBin) {
                   Remove-ItemToRecycleBin $subItem.FullName $shell
               } else {
                   $subItem | Remove-Item -Force
               }
           }

       } elseif ($subItem -is [System.IO.DirectoryInfo]) {
           Delete-BrokenArchiveRec $subItem
       } else {
           Write-Error "Unknown Item : $($subItem.FullName) ."
       }
    }

}

# print current time
Write-Host "At $(Get-Date), Start work."

if (Test-Path $baseFolderPath) {
    Delete-BrokenArchiveRec (Get-Item $baseFolderPath)
} else {
    Write-Error "Wrong path: $($baseFolderPath)."
}

# print current time
Write-Host "At $(Get-Date), End work."
