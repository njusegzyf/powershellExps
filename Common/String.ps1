# use ', there are no escape characters and no string interpolation, and can use " inside
[String]$str1 = 'as `n "" '; # as `n "" 
# use " , there are escape characters and string interpolation, and can use ' inside
[String]$str2 = "as `t ''"; # as 	 ''


# String Interpolation
'$value1' # $value1
"$value1" # 10
"${value1}" # 10
# 如果要在 String Interpolation 中插入表达式，必须使用 $( exp ) 的形式（这里必须使用圆括号而不是花括号）
"$($value1.ToString())" # 10
"`$value1 = $value1" # $value1 = 10
# the following strings are both error, result in an empty string(not a null)
"${value1.ToString()}"
"${$value1.ToString()}"


# 转义字符 ` 和 换行符 `n
$a = "Hello"
'$a = $a'
"`$a = $a"
"`$a = `n$a"


# multi-line string
# note : `@"` and `"@` needs to be on a line all by itself
# see : https://technet.microsoft.com/en-us/library/ee692792.aspx
[String]$multilineString1 = 
@"
Line1 `n `"
Line2
"@

[String]$multilineString2 = 
@'
Line1 `n `"
Line2
'@