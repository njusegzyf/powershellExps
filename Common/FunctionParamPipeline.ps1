function FooBegin {
    param
    (	[Parameter(Mandatory=$true,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Int]$Value
    )

   begin {
     # in begin block, $value is set to the default value (0 or null) if value is passed from pipeline
     # otherwise, it will be passed value
     return $Value; 
   }
}

FooBegin 1 # return 1
# FooBegin @(1, 2, 3) # error, can not convert objet array(@(1, 2, 3)) to int 
@(1, 2, 3) | FooBegin # return 0



function FooProcess {
    param
    (	[Parameter(Mandatory=$true,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Int]$Value
    )

   process {
     # in process block, $value is set to the current process value if value is passed from pipeline
     # otherwise, it will be passed value
     return $Value + 1; 
   }
}

FooProcess 1 # return 1
# process blocke executes three times with `value` equals to 1, 2 and 3, 
# and the return values 2, 3, 4 are concatenated to form the return array @(2, 3, 4)
@(1, 2, 3) | FooProcess # return @(2, 3, 4)



function FooEnd {
    param
    (	[Parameter(Mandatory=$true,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Int]$Value
    )

   process {}
   end {
     # in end block, $value is set to the last value if value is passed from pipeline
     # otherwise, it will be passed value
     return $value; 
   }
}

FooEnd 1 # return 1
@(1, 2, 3) | FooEnd # return 3



function Foo {
    param
    (	[Parameter(Mandatory=$true,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Int]$Value
    )

    # same as FooEnd
    return $value; 
}

Foo 1 # return 1
@(1, 2, 3) | Foo # return 3



function FooArray {
    param
    (	[Parameter(Mandatory=$true,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Int[]]$Value
    )

    return $value; 
}

# the pipeline is unrolling your array into a stream of objects,
# and presenting them to your function one at a time, instead of as an array.
# an int is first convert to an array with the single element, and then bind to `value`
@(1, 2, 3) | FooArray # return 3
@(@(1,2,3)) | FooArray # return 3
# this trick works
,@(1, 2, 3) | FooArray # return @(1, 2, 3)

FooArray 1, 2, 3 # return @(1, 2, 3)
FooArray @(1, 2, 3) # return @(1, 2, 3)
