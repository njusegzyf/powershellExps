﻿# @see http://www.cnblogs.com/Rainr/archive/2012/01/21/2328046.html
# @see https://cyber-defense.sans.org/blog/2010/02/11/powershell-byte-array-hex-convert

# this one echanges caps lock and esc, and map scroll lock and right alt to application
# such value can be generated by KeybMap
$valueString = '00,00,00,00,00,00,00,00,05,00,00,00,5D,E0,46,00,3A,00,01,00,01,00,3A,00,5D,E0,38,E0,00,00,00,00'
$value = ($valueString -split ',') | ForEach-Object -Process { [System.Convert]::ToByte($_,16) }

$keyboardLayoutKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout'
Get-Item $keyboardLayoutKeyPath | Get-Member -MemberType *Property # | Format-List
$scancodeMapName =  'Scancode Map'

# print current scancode map property value if exists
# Note: `$scancodeMapProperty` is of type [System.Management.Automation.PSCustomObject] and its member `Scancode Map` has type [byte[]]
$scancodeMapProperty = Get-ItemProperty -Path $keyboardLayoutKeyPath -Name $scancodeMapName
if ($scancodeMapProperty) {
  # Note: `$_.ToString('X')` prints hex value
  ($scancodeMapProperty.'Scancode Map' | ForEach-Object { $_.ToString('X') }) -join ',' | Write-Host
}

# set scancode map property value
if ($scancodeMapProperty) {
  Set-ItemProperty -Path $keyboardLayoutKeyPath -Name $scancodeMapName -Value $value
} else { # create scancode map property if it does not exist
  New-ItemProperty -Path $keyboardLayoutKeyPath -Name $scancodeMapName -Value $value -PropertyType binary
}
