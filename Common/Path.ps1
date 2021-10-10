
# @see [[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/resolve-path?view=powershell-7.1]]

Resolve-Path -Path "windows"
<#
Path
----
C:\Windows
#>

# get all paths in the Windows folder
'C:\windows\*' | Resolve-Path

Set-Location Z:/

Resolve-Path -Path 'DpcCoef.data'
# returns Z:\DpcCoef.data

Resolve-Path -Path 'Z:/DpcCoef.data' -Relative
# returns .\DpcCoef.data

Set-Location C:/
Resolve-Path -Path "c:\prog*" -Relative
<#
.\Program Files
.\Program Files (x86)
.\ProgramData
#>

# This example uses the LiteralPath parameter to resolve the path of the Test[xml] subfolder. 
# Using LiteralPath causes the brackets to be treated as normal characters rather than a regular expression.
Resolve-Path -LiteralPath 'test[xml]'
