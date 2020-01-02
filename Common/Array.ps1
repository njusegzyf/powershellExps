# 逗号分隔的是数组
[Int32[]]$valueArray = @() # 空数组
$valueArray = 0,1,2,3,4,5,6,7,8,9
$valueArray = 0..9 # [0, 1, .. , 9]

# 合并数组
$newArray = $valueArray + $valueArray
# 数组长度
$newArray.Count

$valueArray[1..3]                      # 从索引位置 1 到 3 的3个元素，注意左右都是闭区间
$valueArray[2..($valueArray.length-1)] # 从索引位置 2 到数组末尾的元素
$valueArray[-3..-1]                    # 读取数组最后3个元素
$valueArray[0..-2]                     # 注意 ：不引用数组中除最后一个以外的所有元素，而是引用数组中第一个、最后一个和倒数第二个元素
$valueArray[0,2 + 4..6]                  # 使用加号运算符，表示在索引位置 0、2 和 4 到 6 的元素

$valueArray | Measure-Object -Sum -Average -Maximum -Minimum



# ForEach-Object 对管道结果逐个处理，其既可以像函数式编程中的 foreach 函数遍历集合元素进行操作，也可以像 map 操作对数据做映射
# Note: Foreach 为遍历集合的循环关键字
$dataArray = Get-Process # TypeName:System.Diagnostics.Process
$dataArray | ForEach-Object { Write-Host $_.Name }
$names = $dataArray | ForEach-Object { $_.Name }



# Select-Object 并非函数式编程中的 Map 操作，而是类似与 SQL 的 Select 操作，用于选择数据项
# @see [[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object?view=powershell-6]]
$dataArray | Select-Object -Property ProcessName,WS 
$dataArray | Select-Object -Property ProcessName,WS | Get-Member # TypeName:Selected.System.Diagnostics.Process

# -ExpandProperty 用于将特定属性展开，类似于将数组 Map 为对应的属性值
$dataArray | Select-Object -ExpandProperty ProcessName
$dataArray | Select-Object -ExpandProperty ProcessName | Get-Member # TypeName:System.String

# Note: `-ExpandProperty` 也可以将属性类型为数组的值展开：
$object = [pscustomobject]@{ name = "CustomObject"; value = @(1,2,3,4,5)}
[Int32]$objectValues = $object | Select-Object -ExpandProperty value # an Int32 array of length 5
$objects = @($object, $object)
[Int32]$objectsValues = $objects | Select-Object -ExpandProperty value # an Int32 array of length 10

# 此外，还可以通过参数 -First, -Last, -Skip, -SkipLast
$dataArray | Select-Object -First 10 -Last 10
$dataArray | Select-Object -Skip 10

# Note: 下面的操作返回类型为 TypeName:Selected.System.Diagnostics.Process，
# 其中 NoteProperty ` $_.PM + $_.VM ` (Script的值) 保存了将 Script 作用于 InputObject后的值
$dataArray | Select-Object -Property { $_.PM + $_.VM }
# 类似于前面的操作，但是指定新属性的名字为 `value`
$dataArray | Select-Object -Property @{ n = 'value'; e = { $_.PM + $_.VM } }
# 通过 `-ExpandProperty` 将 对象数组 转换为 Int数组
# Note: `-ExpandProperty` 只接受类型为 String 的属性名，并且不可以是通过 `-Property` 新计算出的属性
$dataArray | Select-Object -Property @{ n = 'value'; e = { $_.PM + $_.VM } } | Select-Object -ExpandProperty 'value'
# Error : $dataArray | Select-Object -Property @{ n = 'value'; e = { $_.PM + $_.VM } } -ExpandProperty 'value'

# 上述操作效果等同与使用 ForEach-Object
$dataArray | ForEach-Object { $_.PM + $_.VM } 

# 可以传入 Script Block
@('Application', 'Function', 'Alias') | Select-Object { (Get-Command * -CommandType $_).Count }



# http://blog.sina.com.cn/s/blog_7926c5a90100rofb.html

#  【探索PowerShell 】【八】数组、哈希表(附:复制粘贴技巧)
# http://marui.blog.51cto.com/1034148/293506

# strUsers1 and strUsers2 are both array of strings
# notice $strUsers1.Equals($strUsers2) == false since Object.Equals for reference type is ReferenceEquals (like == in Java)
# see http://blog.csdn.net/wuchen_net/article/details/5409327 C#中 Reference Equals, == , Equals的区别 
$strUsers1= "user1","user2","user3"
$strUsers2= @("user1","user2","user3")

Compress-Archive -Path 'Z:\temp\' -DestinationPath 'Z:\ar.zip' -CompressionLevel Fastest
$parArray = 'Z:\temp\', 'Z:\ar.zip'
# @ 可以用于在执行命令时展开数组，例如：
Compress-Archive @parArray
# 等价于
Compress-Archive $parArray[0] $parArray[1]
# 在方法调用时，不可使用 @ 来展开数组，例如下面的表达式是错误的：
# [System.String]::Compare(@parArray)

# 下面的代码创建了一个 System.Collections.Hashtable，其只有一个键值对 ： "name" (类型为 String ) -> Array("user1","user2","user3") 
$strUsersMap= @{name = "user1","user2","user3"}



# symmetric array, 对称数组/多维数组
# 声明
[int[,,]]$array3D = New-Object 'int[,,]' 3,4,5
# 赋值
for($i=0; $i -lt $array3D.GetLength(0); $i++) {
  for($j=0; $j -lt $array3D.GetLength(1); $j++) {
    for($k=0; $k -lt $array3D.GetLength(2); $k++) {
      $array3D[$i,$j,$k]=$i+1
    }
  }
}
# 打印
for($i=0; $i -lt $array3D.GetLength(0); $i++) {
  for($j=0; $j -lt $array3D.GetLength(1); $j++) {
    Write-Host ("`t"*$i) -NoNewline
    for($k=0; $k -lt $array3D.GetLength(2); $k++) {
      Write-Host $array3D[$i,$j,$k] -NoNewline
      Write-Host "`t" -NoNewline
    }
    Write-Host "`n" -NoNewline
  }
}



# jagged array，交错数组，即数组元素也是数组
$array1 = 1,2,@(1,2,3),3
$array1[0]
$array1[2][1]

# Note: Powershell 可能会展开 jagged array，比如函数的返回值 （@see Function.ps1）
[String[][]]$array3 = @( @(1, 2),
                         @(3, 4))
$array3.Length # 2，说明 array3 是一个 jagged array

[String[][]]$array4 = @(@(3, 4))
$array4.Length # 2，说明 array4 不是 jagged array，Powershell 自动将其展开了

[String[][]]$array5 = @(,@(3, 4))
$array5.Length # 1，说明 array5 是 jagged array
