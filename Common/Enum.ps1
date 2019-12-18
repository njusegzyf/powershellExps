
# @see [[https://social.technet.microsoft.com/wiki/contents/articles/26436.how-to-create-and-use-enums-in-powershell.aspx How to Create and Use Enums in Powershell]]
# @see [[https://blog.csdn.net/itanders/article/details/51308774 在PowerShell中使用枚举类型]]

# requires powershell version 5 
enum MyFruit { 
  Apple
  Orange
  Watermelon
}
 
 
function Select-Fruit {
  param(
    [MyFruit]
    [Parameter(Mandatory=$true)]
    $Fruit
  )

  $Type = ($Fruit).GetType() | Select-Object -ExpandProperty BaseType
  "The type is $Type"  
  "You like $Fruit"
}

# 调用时，可以直接传递字符串值，其将被自动转换成对应的枚举值
Select-Fruit -Fruit 'Apple'

# 调用时，也可以传递对应的枚举实例值
Select-Fruit -Fruit ([MyFruit]::Apple)
# 注意，此处必需使用括号，以保证 Powershell 不会将 `[MyFruit]::Apple` 识别成一个字符串传递给函数
Select-Fruit -Fruit [MyFruit]::Apple # Error



function Test-Switch() {
  [MyFruit]$enumValue = [MyFruit]::Apple

  # When using an enum in a switch construct, a copy of the enumerator name is converted to a string.
  $retunvalue = 
    switch ($enumValue){
        'Apple'  { "You get one $enumValue" }
        'Orange' { "You get two $enumValue" }
    }
}