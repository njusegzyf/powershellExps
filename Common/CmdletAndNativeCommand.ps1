# 可以直接操作 .Net 对象
$outputPath = 'Z:/output.txt'
$writeContent = 'Content'
$writer = New-Object System.IO.StreamWriter($outputPath)
$writer.WriteLine('Begin')
$writer.WriteLine($writeContent)
$writer.WriteLine('End')
$writer.Close()
Get-Content -Path $outputPath

# 可以调用 .Net 静态方法和属性
[DateTime] | Get-Member -Static
[DateTime]::IsLeapYear('2000')
[DateTime]::Now

# 可以直接调用外部命令
ipconfig | Get-Member # TypeName:System.String, String[]
ipconfig | Get-Member | Format-List
ipconfig | Get-Member | Out-GridView
ipconfig | Select-Object -First 10 # select first 10 elements
(ipconfig).Length
ipconfig | clip # copy to clip
ipconfig | Where-Object -FilterScript {$_ -like '*IPV4*' -or $_ -like '*IPV6*' -or $_ -like '*本地连接*' -or $_ -like '*以太网*'}
           
Get-Command -Module '*Management' | Get-Member
Get-Command -Module '*Management' | Select-Object Name, Verb, Noun, ModuleName | Out-GridView

# get helps for topics
Get-Help 'about*'
Get-Help about_workflows -ShowWindow
