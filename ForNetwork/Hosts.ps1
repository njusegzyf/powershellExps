$hostsFilePath = 'c:\windows\system32\drivers\etc\hosts'

Get-Content $hostsFilePath

npp $hostsFilePath
