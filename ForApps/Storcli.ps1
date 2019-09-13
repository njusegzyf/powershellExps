# @see https://blog.51cto.com/1130739/1771506
# TODO

$storCliBinDir = 'C:\Tools\`[`]DiskTools\storcli'

Set-Location $storCliBinDir
Set-Alias -Name storcli -Value '.\storcli64'

# show version
storcli -v

storcli -help

# show adapter counter
storcli -adpCount

storcli show

