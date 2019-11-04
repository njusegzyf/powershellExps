# see http://hebe852.blog.163.com/blog/static/12072624820108744039615/
<#
function [<scope:>]<name> [([type]$parameter1[,[type]$parameter2])]  
{
    param([type]$parameter1 [,[type]$parameter2])
    dynamicparam {<statement list>}
    begin {<statement list>}
    process {<statement list>}
    end {<statement list>}
}
#>

<#
.Synopsis
   Applys a function(ScriptBlock) to all elements.
.EXAMPLE
   0..10 | Map-Object -mapFunc {$_ + 1}
#>
Function Map-Object {
    Param
    (	[Parameter(Mandatory=$true,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [String]$value,

        [ScriptBlock]$mapFunc
    )

    Begin {
        $res = New-Object System.Collections.ArrayList

        Write-Verbose "Begin"

        # 此时函数还没有接收到来自管道的输入数据，因此 $input 变量是空的 ($input 为自动变量代表来自管道的所有对象)
        # $args 同样为空数组
        Write-Verbose "[Begin]`$input : $input"

        # $value 如果通过管道传入，则此时为空；否则此时为传入的值
        Write-Verbose "[Begin]`$value : $value"
    }

    Process {
        Write-Verbose "Process"

        Write-Verbose "[Process]`$input : $input" # 此时 $input -eq $_
        Write-Verbose "[Process]`$value : $value"
        
        # Powershell 会将函数中所有的输出作为返回值。
        # return 语句会将指定的值返回，同时也会中断函数的执行，return 后面的语句会被忽略。
        # 所有返回值会拼接成一个数组，作为函数的返回值。
        # 注意 return 语句不影响函数之前的返回值行为，即使 return 语句返回了一个值，之前所有的表达式结果也会作为返回值。
        # 因此，对于不想返回的值，必须 cast 到 void 来忽略返回值。

        # Note: 如果参数不是通过 Pipeline 传入的，则此时 $_ ($input) 为 default value `$null`, 而 $value 则为形参值，
        # 因此此处因使用 `$value`
        [void]$res.Add($mapFunc.Invoke($value))
        # or $res.Add($mapFunc.Invoke($value)) -as [void]
        # [Type] 和 -as 与 C# 中的强制类型转换（不可转换抛出异常）和 as 操作符（不可转换返回 null ，因此只可用于引用类型）

        # 也可以用 Write-Output 显式写入返回值
        return $mapFunc.Invoke($value)

        <#
          $newPowerShell = [PowerShell]::Create().AddScript($code)
          $handle = $newPowerShell.BeginInvoke()
  
          while ($handle.IsCompleted -eq $false) {
            Write-Host '.' -NoNewline
            Start-Sleep -Milliseconds 500
          }
  
          Write-Host ''
  
          $newPowerShell.EndInvoke($handle)
  
          $newPowerShell.Runspace.Close()
          $newPowerShell.Dispose()
        #>
    }

    End {
        Write-Verbose "End"

        # 如果在我们的函数中存在Process代表的代码块的话，$input在Process处理完之后将被清空
        # 否则$input中将有值
        Write-Verbose "[End]`$input : $input"

        # End 的 Return 值会添加到返回值数组的末尾（如果是Array或者ArrayList之类的集合，会被展开后放入）
        return $res
    }
}



$z = 'a', 'b', 'c' | Map-Object -mapFunc { $_.GetHashCode() } -Verbose
<#
输出形如：
详细信息: Begin
详细信息: [Begin]$input : 
详细信息: [Begin]$value : 
详细信息: Process
详细信息: [Process]$input : a
详细信息: [Process]$value : a
详细信息: Process
详细信息: [Process]$input : b
详细信息: [Process]$value : b
详细信息: Process
详细信息: [Process]$input : c
详细信息: [Process]$value : c
详细信息: End
详细信息: [End]$input : 

返回值 $z 是 Array，形如：
372029373
372029376
372029375 (Process的结果)
#>
Write-Host

# Note: `$_` can not be used without pipeline.
# $_` is an auto variable set to the last parameter in the pipeline,
# so its value is `$null` when invoked in the process block,
# so we will get an exception as we call `GetHashCode` methed on variable `$_` which is null.
# $z = Map-Object -value 'c' -mapFunc { $_.GetHashCode() } -Verbose

# So it should be written as a script block with input parameter
$z = Map-Object -value 'c' -mapFunc { param($input) $input.GetHashCode() } -Verbose
<#
输出形如：
详细信息: Begin
详细信息: [Begin]$input : 
详细信息: [Begin]$value : c
详细信息: Process
详细信息: [Process]$input : 
详细信息: [Process]$value : c
详细信息: End
详细信息: [End]$input :

返回值 $z 是 int 372029375
#>
