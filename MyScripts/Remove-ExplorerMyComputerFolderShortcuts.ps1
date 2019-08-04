﻿# @see https://jingyan.baidu.com/article/3f16e0031cdd5c2591c103e6.html
# @see https://devblogs.microsoft.com/scripting/using-and-understanding-tuples-in-powershell/
$myComputerNameSpace = Get-Item HKLM:HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\
$nameSpacesToRemove = 
@('{088e3905-0323-4b02-9826-5d99428e115f}',
  '{24ad3ad4-a569-4530-98e1-ab02f9417aa8}',
  '{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}',
  '{d3162b92-9365-467a-956b-92703aca08af}',
  '{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}',
  '{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}',
  '{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}')

foreach ($nameSpace in $nameSpacesToRemove) {
  # $myComputerNameSpace.DeleteSubKey($nameSpace) # Error
  Get-Item  "$($myComputerNameSpace.PSPath)\$nameSpace" | Remove-Item -Recurse
}

<#
“下载”文件夹：
［-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}］
“图片”文件夹：
［-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}］
“音乐”文件夹：
［-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}］
“文档”文件夹：
［-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}］
“视频”文件夹：
［-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}］
“桌面”文件夹：
-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}］
“3D对象”文件夹：
-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"］ #>
