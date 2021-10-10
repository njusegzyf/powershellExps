 
# Export-Clixml
# Creates an XML-based representation of an object or objects and stores it in a file.
# @see [[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-clixml?view=powershell-7.1]]

Export-Clixml -InputObject $x -Path 'Z:\Data'
$y = Import-Clixml -LiteralPath 'Z:\Data'
