# . 指代的是当前用户所处目录，而 $PSScriptRoot 才是当前脚本所在目录
."$PSScriptRoot\Back-RamDisk.ps1"

$backRes = 'z:' | Back-RamDisk # -isBackFolderAsArchive

if ($backRes) {
    $ConfirmText = 
@"
Confirm
Are you sure you want to shutdown the computer?
[Y] Yes [N] No (default is "N")
"@

    Write-Host $ConfirmText

    $answer = Read-Host # -Prompt "[Y] Yes [N] No (default is `"N`")`n"

    $isShutDown = $false
    switch ($Answer)
    {
        "Y" { $isShutDown = $true}
        "N" { $isShutDown = $false}
        default { $isShutDown = $false}
    }
        
    if ($isShutDown) {
        Write-Host "Start to shutdown the computer in 10 seconds.`n"
        Start-Sleep -Seconds 5
        shutdown -s -t 10
        exit
    }
} else{
    Write-Host "Failed to back up.`n"
}
