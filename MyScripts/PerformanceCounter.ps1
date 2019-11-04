# @see [[https://www.oschina.net/news/76899/powershell-gather-servers-performance-counter 使用 PowerShell 收集多台服务器的性能计数器]]
# @see [[https://www.cnblogs.com/geaozhang/p/9850742.html 利用PowerShell监控Win-Server性能]]

$computerName = $env:ComputerName

# @see [[https://docs.microsoft.com/zh-cn/powershell/module/Microsoft.PowerShell.Diagnostics/Get-Counter?view=powershell-5.1]]

$counterSampleSet = Get-Counter # Microsoft.PowerShell.Commands.GetCounter.PerformanceCounterSampleSet
$counterSampleSet.Timestamp
$counterSampleSet.CounterSamples

# gets the local computer's list of counter sets
Get-Counter -ListSet *
# Get-Counter -ComputerName $computerName -ListSet *
# Get-Counter uses the ListSet parameter with an asterisk (*) to get the list of counter sets.
# The dot (.) in the MachineName column represents the local computer.

# gets the counter data for all processors on the local computer.
# Data is collected at two-second intervals(the default interval is one second) until there are three samples.
Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 2 -MaxSamples 3

# gets continuous samples for a counter every three second. To stop the command, press CTRL+C.
Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 3 -Continuous

# runs a background job to get counter data
# Start-Job runs a Get-Counter command as a background job on the local computer. To view the performance counter output from the job, use the Receive-Job cmdlet.
# Start-Job -Name CounterJob1 -ScriptBlock {Get-Counter -Counter "\LogicalDisk(_Total)\% Free Space" -MaxSamples 1000}

# Uses the Path property of a counter set to find the formatted path names for the performance counters.
# The pipeline is used with the Where-Object cmdlet to find a subset of the path names.
# To find a counter sets complete list of counter paths, remove the pipeline (|) and Where-Object command.
# Note: We can not only pass '*' or a full name of a counter list.
(Get-Counter -ListSet Memory).Paths | Where-Object { $_ -like "*Cache*" }

# gets the formatted path names that include the instances for the PhysicalDisk performance counters
# Note: PathsWithInstances property returns each path instance as a string.
(Get-Counter -ListSet PhysicalDisk).PathsWithInstances

# gets a single value for each counter in a counter set
$memoryCounters = (Get-Counter -ListSet Memory).Paths # returns String[]
Get-Counter -Counter $memoryCounters



$netAdapterName = 'wireless-ac 3165'
$netAdapterCouterPaths = (Get-Counter -ListSet 'Network Interface').PathsWithInstances | Where-Object { $_ -like "*$netAdapterName*\Bytes Received/sec" }
$counterSampleSets = Get-Counter -Counter $netAdapterCouterPaths -SampleInterval 2 -MaxSamples 10
$counterSampleSets # Length 10 Array Microsoft.PowerShell.Commands.GetCounter.PerformanceCounterSampleSet
$sampleIndex = 2
$sampleValue = $counterSampleSets[$sampleIndex].CounterSamples[0].CookedValue
$propertyScript = {$_.CounterSamples[0].CookedValue}
$propertyScript.ToString()
$avgSampleValue = $counterSampleSets | Select-Object -Property @{ n = 'value'; e = {$_.CounterSamples[0].CookedValue} }  `
                                     | Select-Object -ExpandProperty value `
                                     | Measure-Object -Average
$avgSampleValue | Get-Member # # TypeName:Microsoft.PowerShell.Commands.GenericMeasureInfo
$avgSampleValue.Average
 


<# Network interface counter paths
\Network Interface(*)\Bytes Total/sec
\Network Interface(*)\Packets/sec
\Network Interface(*)\Packets Received/sec
\Network Interface(*)\Packets Sent/sec
\Network Interface(*)\Current Bandwidth
\Network Interface(*)\Bytes Received/sec
\Network Interface(*)\Packets Received Unicast/sec
\Network Interface(*)\Packets Received Non-Unicast/sec
\Network Interface(*)\Packets Received Discarded
\Network Interface(*)\Packets Received Errors
\Network Interface(*)\Packets Received Unknown
\Network Interface(*)\Bytes Sent/sec
\Network Interface(*)\Packets Sent Unicast/sec
\Network Interface(*)\Packets Sent Non-Unicast/sec
\Network Interface(*)\Packets Outbound Discarded
\Network Interface(*)\Packets Outbound Errors
\Network Interface(*)\Output Queue Length
\Network Interface(*)\Offloaded Connections
\Network Interface(*)\TCP Active RSC Connections
\Network Interface(*)\TCP RSC Coalesced Packets/sec
\Network Interface(*)\TCP RSC Exceptions/sec
\Network Interface(*)\TCP RSC Average Packet Size
#>
