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
        [String]$values,

        [ScriptBlock]$mapFunc
    )

    Begin {
        $res = New-Object System.Collections.ArrayList

        # Write-Verbose "Begin"

        # 此时函数还没有接收到来自管道的输入数据，因此$input变量是空的
        # $input代表来自管道的所有对象
        # Write-Verbose "[Begin]`$input : $input"
    }

    Process {
        # Write-Verbose "Process"

        # Write-Verbose "[Process]`$input : $input" # 此时 $input -eq $_
        
        # Powershell 会将函数中所有的输出作为返回值，但是也可以通过return语句指定具体的我返回值。
        # Return 语句会将指定的值返回，同时也会中断函数的执行，return后面的语句会被忽略。
        # 所有返回值会拼接成一个数组，作为函数的返回值

        # 表达式结果也会作为返回值，因此必须 cast 到 void 来忽略返回值
        # [void]$res.Add($mapFunc.Invoke($_)) or $res.Add($mapFunc.Invoke($_)) -as [void]
        # [Type] 和 -as 与 C# 中的强制类型转换（不可转换抛出异常）和 as 操作符（不可转换返回 null ，因此只可用于引用类型）

        # 也可以用 Write-Output 显式写入返回值
        # Write-Output $_

        return $mapFunc.Invoke($_)

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
        # Write-Verbose "End"

        # 如果在我们的函数中存在Process代表的代码块的话，$input在Process处理完之后将被清空
        # 否则$input中将有值
        # Write-Verbose "[End]`$input : $input"

        # End 的 Return 值会添加到返回值数组的末尾（如果是Array或者ArrayList之类的集合，会被展开后放入）
        # return $res
    }
}

<# 
$z = "a", 'b', "c" | Map-Object -mapFunc { $_.GetHashCode() } 

返回值 $z 是 Array，形如
372029373
372029376
372029375 (Process的结果)
372029373
372029376
372029375 （End的结果）

#>
