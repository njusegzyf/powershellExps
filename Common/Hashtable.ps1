# Create a hashtable
$hash = @{}

# Get all keys and values. If empty, return $null
$hash.Keys # -eq $null
$hash.Values

$has.Count

# Create a hashtable with 
$hash = @{ 
"Computer Name" = "AD Server";
"Administrator" = "Ma Tao", "Spider Man";
"OS" = "Windows 2008";
"Installed Date" = Get-Date;
"Disk Size" = 5000GB
}

# Get value by key
$hash.OS
$members = $hash["OS", "Computer Name", "Installed Date"] # of type Object[]
$members[2].DayOfYear

# Add hash members
$hash = $hash + @{ "test" = "test add";} 

# Delete hashtable(pass the variable name as a string)
Remove-Item "hash"
Remove-Item -Path "hash"
