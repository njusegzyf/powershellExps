# See Windows PowerShell Language Specification Version 3.0 - 8.10.1 Filter functions

# Whereas an ordinary function runs once in a pipeline and accesses the input collection via $input, 
# a filter is a special kind of function that executes once for each object in the input collection. 
# The object currently being processed is available via the variable $_.
# A filter with no named blocks is equivalent to a function with a process block, but without any begin block or end block.

filter Get-Square2		# make the function a filter	
{
    $_ * $_			    # access current object from the collection
}

-3..3 | Get-Square2		# collection has 7 elements
6,10,-3 | Get-Square2	# collection has 3 elements

# Windows PowerShell: Each filter is an instance of the class System.Management.Automation.FilterInfo (§4.5.11).



# See Windows PowerShell Language Specification Version 3.0 - 8.10.6 Pipelines and functions
# When a script, function, or filter is used in a pipeline, a collection of values is delivered to that script or function. 
# The script, function, or filter gets access to that collection via the enumerator $input,
# which is defined on entry to that script, function, or filter. 

function Get-Square1
{
    foreach ($i in $input)		# iterate over the collection 
    {
        $i * $i
    }
}

-3..3 | Get-Square1			# collection has 7 elements
6,10,-3 | Get-Square1		# collection has 3 elements

