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

