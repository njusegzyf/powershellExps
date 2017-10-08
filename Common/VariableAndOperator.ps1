﻿$value1 = 10
$value2 = 12
# 交换两个变量的值
$value1, $value2 = $value2, $value1

# 逗号分隔的是数组
$valueArray = 0,1,2,3,4,5,6,7,8,9
$valueArray = 0..9 # [0, 1, .. , 9]

# 格式化操作符，-f 格式化字符串在左，实际值在右
'{0}, {1, -10}, {2:N}' -f 1, "hello", [System.Math]::PI
Get-Process | %{"{0}`t{1:n2}`t{2:n2}" -f $_.Name, ($_.WS / 1MB), $_.CPU} # %{ ... } 是 script，`t 为tab的转义字符

# 比较操作符 -eq -ne -gt -ge -lt -le 只用于基本类型和String（不用于数组）
('1' + 1 ) -eq '11'
"abc" -gt "a"

# 逻辑操作符 -and -or -xor -not (同 ! )
1 -and 0 # false
1 -xor 0 # true
-not 1 # false
! 1 # false

# 匹配操作符 -like -notlike （使用通配符 *） / -match -notmatch （使用 RegExp）,加前缀 c 则为 case sensitive
'someone' -like '*me*' # true
'someone' -like '*ME*' # true
'someone' -clike '*me*' # true, case sensitive
'someone' -clike '*ME*' # false
'someone' -match 'some[a-z]{3,3}' # true
'someone' -cmatch 'SOME[a-z]{3,3}' # false

# -join -spilt
0..9 -join ','
0..9 -join ',' -split ','

# 输入输出重定向
# >(overwrite) >>(append) 1>(标准输出) 2>(错误输出) 3>(警告输出) 4>(verbose输出)
Get-ChildItem c:\, e:\, d:\ > Z:\output.txt # `d:\` is error path, `>` 只重定向标准输出 （同 `1>` ）,因此错误输出到控制台，文本无输出
Get-ChildItem c:\, e:\ 1> Z:\output.txt 2> Z:\error.txt
Get-ChildItem c:\, e:\ 1>> Z:\output.txt
# Out-File 类似重定向操作符，但是可选项更多
Get-ChildItem c:\, e:\ | Out-File -FilePath Z:\output.txt -Append -Encoding utf8

# 管道操作符 |
Get-Process |
Where-Object -FilterScript {$_.WS -ge 20MB -or $_.ProcessName -eq 'IDLE'} | # 过滤元素
Select-Object -Property ProcessName, Id, CPU, WS |                          # 选取特定属性
Sort-Object -Property ws -Descending |                                      # 排序元素
Select-Object -First 10 |                                                   # 选取开头的10个元素
# Format-Table                                                              # 格式化为表格，输出结果为包含格式化元素的Object[]，Out-GridView不支持该数据类型
Out-GridView -Title 'Top 10 WS Process'                                     # 输出到GridView

(Get-ChildItem | Select-Object -ExpandProperty Name) -join " ,"

# 集合操作符 -contains（集合 -contains 元素） -in（元素 -in 集合）
1,2 -contains 1
1 -in 1,2

# for loop and foreach loop
for ([Int32] $i = 0; $i -lt 10; $i++) {
  "Hello $i"
}
# for loop result in a collection (Object[] )
[Object[]]$results =  for ([Int32] $i = 0; $i -lt 10; $i++) { "Hello $i" }
foreach ($i in 0..9) {
  "Hello $i"
}
0..9 | % { "Hello $_" } # % 以及 foreach 均为 ForEach-Object 的别名，但是上面例子的 foreach 是关键字，不可用 % 替代
0..9 | ? {$_ % 2 -eq 0} | %{ "Hello $_" } # ? 为 Where-Object 的别名

# 显示声明变量类型
[Int]$testVariable = 100
[Int[]]$testVariableArray = 100, 120
$testVariableArray | Get-Member # Int32
($testVariableArray).GetType() # Int32[]

# test and remove variable through PS drive `variable`
# http://www.pstips.net/powershell-define-variable.html
if (Test-Path variable:testVariable){
    $testVariable.GetType()
}
Remove-Item variable:testVariable
del variable:testVariable

# 为了管理变量，powershell提供了五个专门管理变量的命令Clear-Variable，Get-Variable，New-Variable，Remove-Variable，Set-Variable
# http://www.pstips.net/powershell-define-variable.html
Remove-Variable testVariable

# 创建只读变量 和 常量
New-Variable -Name 'readOnlyVar' -Value 100 -Force -Option Readonly
$readOnlyVar = 101 # Error, cannot overwrite
Remove-Variable -Name 'readOnlyVar' -Force # But can delete ( must with -Force)

New-Variable -Name 'constantVar' -Value 100 -Force -Option Constant
$constantVar = 101 # Error, cannot overwrite
Remove-Variable -Name 'constantVar' -Force # Error, cannot delete


# 使用 -is -isnot 检查类别
$testVariableArray -is [Int32[]] # true
1..2 -is [Object[]] # true，为了可以存放任意类型，只能是 Object[]
1..2 -is [Int32[]] # false
1 -is [Int32]

# 类型转换 -as 和 []
('1' -as [Int32]).GetType()
('a' -as [Int32]) -eq $null # -as 转型失败返回null。注意 C# 的 as 操作符只作用于引用类型 （https://msdn.microsoft.com/zh-cn/library/cscsdfbt.aspx）
[Int32]$newInt = [Int32]'1'
[Int32]$newInt = [Int32]'a' # 转型失败抛出异常

'10GB' / 1MB             # System.Int64
('10GB' / 1MB) -as [Int] # System.Int32