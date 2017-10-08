$Variable:ConfirmPreference = "None"

Try{
    if (Get-Item 'C:\Users\ZhangYF\Documents\WindowsPowerShell\Modules\NICConfig'){
        Remove-Item  'C:\Users\ZhangYF\Documents\WindowsPowerShell\Modules\NICConfig' -Recurse
    }

    Remove-Module 'NICConfig'
}Catch{
    #$CurrentError | Write-Host
}

Copy-Item -Path 'C:\Users\ZhangYF\Documents\PS\NICConfig' -Destination 'C:\Users\ZhangYF\Documents\WindowsPowerShell\Modules\' -Recurse

Import-Module 'NICConfig'