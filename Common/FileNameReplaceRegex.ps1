$pattern = '#\d\d\d'
'#123' -match $pattern #true

$f = Get-Item 'Y:\test #123.txt'

$targetPattern = '\b#\d\d\d'
$repaceString = ''
$regex = New-Object Regex $targetPattern

$pattern.Replace($f.FullName, $repaceString) 