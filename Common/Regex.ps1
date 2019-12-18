# @see [[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions?view=powershell-6 About Regular Expressions]]
# @see [[https://www.pstips.net/regex-describing-patterns.html PowerShell正则表达式系列文章]]

# PowerShell has several operators and cmdlets that use regular expressions.
#    Select-String
#    -match and -replace operators
#    -split
#    switch statement with -regex option

# PowerShell regular expressions are case-insensitive by default. Each method shown above has a different way to force case sensitivity.
#    Method 	              Case Sensitivity
#    Select-String 	          use -CaseSensitive switch
#    switch statement 	      use the -casesensitive option
#    operators                prefix with 'c' (-cmatch, -csplit, or -creplace)



# This statement returns true because book contains the string "oo"
"book" -match "oo"



# Grouping constructs separate an input string into substrings that can be captured or ignored. 
# Grouped substrings are called subexpressions. 
# By default subexpressions are captured in numbered groups, though you can assign names to them as well.
"The last logged on user was CONTOSO\jsmith" -match "(.+was )(.+)" # True

# Use the $Matches Hashtable automatic variable to retrieve captured text. 
# The text representing the entire match is stored at key 0.
$Matches.0 # The last logged on user was CONTOSO\jsmith
$Matches.1 # The last logged on user was
$Matches
# Name                           Value
# ----                           -----
# 2                              CONTOSO\jsmith
# 1                              The last logged on user was
# 0                              The last logged on user was CONTOSO\jsmith

# The 0 key is an Integer. You can use any Hashtable method to access the value stored.
$Matches[0]
$Matches.Item(0)
$Matches.0



# Named Captures
# Inside a capturing group, use ?<keyname> to store captured data under a named key.
$string = "The last logged on user was CONTOSO\jsmith"
$string -match "was (?<domain>.+)\\(?<user>.+)"

$Matches
#Name                           Value
#----                           -----
#domain                         CONTOSO
#user                           jsmith
#0                              was CONTOSO\jsmith
$Matches[1]



# Substitutions in Regular Expressions
# <input> -replace <original>, <substitute>

# Two ways to reference capturing groups are by Number and by Name.

# By Number - Capturing Groups are numbered from left to right.
'John D. Smith' -replace '(\w+) (\w+)\. (\w+)', '$1.$2.$3@contoso.com' # John.D.Smith@contoso.com

# By Name - Capturing Groups can also be referenced by name.
'CONTOSO\Administrator' -replace '\w+\\(?<user>\w+)', 'FABRIKAM\${user}' # FABRIKAM\Administrator

# The $& expression represents all the text matched.
'Gobble' -replace 'Gobble', '$& $&' # Gobble Gobble

# Since the $ character is used in string expansion, you'll need to use literal strings with substitution, or escape the $ character.
'Hello World' -replace '(\w+) \w+', "`$1 Universe" # Hello Universe

# Additionally, since the $ character is used in substitution, you will need to escape any instances in your string.
 '5.72' -replace '(.+)', '$$$1' # $5.72
 '5.72' -replace '(.+)', "`$`$`$1" # $5.72, '`$' represents literal $
