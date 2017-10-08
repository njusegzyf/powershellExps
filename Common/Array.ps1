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
