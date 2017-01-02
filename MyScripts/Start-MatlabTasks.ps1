# arguments
[String]$sourceDirPath = 'Z:\testDir\source' # '/root/Exp/Source';
[String]$destDirPath = 'Z:\testDir\dest1' # '/root/Exp/Run';

# the text (as String array) to be insert at top of every file
[String[]]$insertTextTop = @(
  "addpath(genpath('/root/Exp/lib')); ",
  "% start timer and record cputime",
  "startTime = clock;",
  "startTimeCpu = cputime;"
);

# the text (as String array) to be insert at bottom of every file
[String[]]$insertTextBottom = @(
  "% end timer",
  "fprintf('Total elapsed time : %d seconds \n', etime(clock,startTime));",
  "fprintf('Total cputime : %d seconds \n', cputime - startTimeCpu);"
);

# functions and classes

function Test-InsertIndex {
  param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [int]$sourceLength,

    [Parameter(Mandatory=$true)]
    [int]$insertIndex
  )

  if ($sourceLength -lt 0) {
    throw "Illegal parameter sourceLength : $sourceLength, it can not be negative. ";
  }

  if ($insertIndex -ge 0) {
    # if insert index is >= 0
    return $insertIndex -le $sourceLength;
  } else {
    # if insert index is < 0, -1 means inset after the last element, and -(sourceLength + 1) means before the first element
    return $insertIndex -ge (- $sourceLength - 1);
  }
}

function Insert-Content {
  param(
    [Parameter(Mandatory=$true)]
    [Object[]]$sourceContent,

    [Parameter(Mandatory=$true)]
    [Object[]]$insertContent,

    [Parameter(Mandatory=$true)]
    [int]$insertIndex
  )

  [int]$sourceContentLen = $sourceContent.Length;
  if (-not (Test-InsertIndex $sourceContentLen $insertIndex) ) {
    throw "Illegal parameter insertIndex : $insertIndex with sourceContentLen : $sourceContentLen.";
  }

  if (-not $insertContent) { # insertContent is null or empty
    return $sourceContent;
  }

  # make negative index to be positive
  if ($insertIndex -lt 0) {
    $insertIndex += ($sourceContentLen + 1);
  }

  if ($insertIndex -eq 0) {
    return $insertContent + $sourceContent;
  } elseif ($insertIndex -eq $sourceContentLen) {
    return $sourceContent + $insertContent;
  } else {
    # 0 < $insertIndex < $sourceContentLen
    return $sourceContent[0 .. ($insertIndex - 1)] + $insertContent + $sourceContent[$insertIndex  .. ($sourceContentLen - 1)];
  }
}

Class MatlabTaskAttr {
  [String]$path = '';
  [String]$workItemName = '';
    
  MatlabTaskAttr([String]$path, [String]$workItemName) {
    $this.path = $path;
    $this.workItemName = $workItemName;
  }
}

function ConvertTo-MatlabTask($item) {
  $itemName = $item.Name;
  $itemNameWithExt = $itemName.Substring(0, $itemName.LastIndexOf('.'));

  # create related dir the dest dir
  $itemDirPath = "$destDirPath/$itemNameWithExt";
  (New-Item -ItemType Directory $itemDirPath) -as [void];

  # get content of the item, insert text, and then write to the dir
  [String[]]$itemContent = Get-Content $item.FullName;
  $itemContent = Insert-Content $itemContent $insertTextTop 0;
  $itemContent = Insert-Content $itemContent $insertTextBottom -1;
  ($itemContent | Set-Content -Path "$itemDirPath/$itemName") -as [void];

  return [MatlabTaskAttr]::new($itemDirPath, $itemNameWithExt);
}

# work code

$sourceDir = Get-Item $sourceDirPath;
$sourceItems = Get-ChildItem $sourceDir;

if (Test-Path $destDirPath) {
  # clean the output dir
  Remove-Item $destDirPath -Force -Recurse;
}
# create the output dir
New-Item -ItemType Directory $destDirPath;
$destDir = Get-Item $destDirPath;

[MatlabTaskAttr[]]$matlabTask = $sourceItems | % { ConvertTo-MatlabTask($_) }

foreach ($taskAttr in $matlabTask) {
  Start-Job -ArgumentList $taskAttr.path, $taskAttr.workItemName -ScriptBlock { 
    param($workPath, $workItemName); 
    cd $workPath;
    matlab -nodesktop -nosplash -logfile output.log -r $workItemName;
  };
}

