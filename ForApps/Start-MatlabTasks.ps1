# arguments
[String]$sourceDirPath = 'Z:\ProcessDir\Source' #'/root/Exp/Source';
[String]$destDirPath = 'Z:\ProcessDir\RunDir1' #'/root/Exp/RunDir1';
# the lib path which will be added to matlab path
[String]$libPath = "'/root/Exp/lib'";

# the text (as String array) to be inserted at top of every file
[String[]]$insertTextTop = @(
  "addpath(genpath($libPath)); ",
  "% start timer and record cputime",
  "startTime = clock;",
  "startTimeCpu = cputime;"
);

# the text (as String array) to be inserted at bottom of every file
[String[]]$insertTextBottom = @(
  "% end timer",
  "fprintf('Total elapsed time : %d seconds \n', etime(clock,startTime));",
  "fprintf('Total cputime : %d seconds \n', cputime - startTimeCpu);"
);


if (-not (Test-Path $sourceDirPath)) {
  New-Item -ItemType Directory -Force -Path $sourceDirPath
}
if (-not (Test-Path $destDirPath)) {
  New-Item -ItemType Directory -Force -Path $destDirPath
}


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

function New-RunMatlabScriptContent([String]$mFIleNameWithoutExt, [String]$logFileName) {
  # return the content of a script to run matlab
  "#bin/bash"
  "nohup matlab -nodesktop -nosplash -logfile $logFileName -r '$mFIleNameWithoutExt'"
}

function New-RunMatlabScript([String]$path, [String]$mFIleNameWithoutExt, [String]$logFileName) {
  # note : The default encoding of `Out-File` is UTF8 and it will writes BOM at the head of the file.
  # So set the encoding to be ascii.
  New-RunMatlabScriptContent $mFIleNameWithoutExt $logFileName | Out-File $path -Encoding ascii
}

Class MatlabTaskAttr {
  [String]$path = '';
  [String]$workItemName = '';
    
  MatlabTaskAttr([String]$path, [String]$workItemName) {
    $this.path = $path;
    $this.workItemName = $workItemName;
  }
}

function New-MatlabTask($item) {
  $itemName = $item.Name;
  $itemNameNoExt = $itemName.Substring(0, $itemName.LastIndexOf('.'));

  # create related dir the dest dir
  $itemDirPath = "$destDirPath/$itemNameNoExt";
  (New-Item -ItemType Directory $itemDirPath) -as [void];

  # get content of the item, insert text, and then write to the dir
  [String[]]$itemContent = Get-Content $item.FullName;
  if ($insertTextTop) {
    # if `$insertTextTop` is an empty array, we will get an error : Insert-Content : 无法将参数绑定到参数“insertContent”，因为该参数为空数组
    $itemContent = Insert-Content $itemContent $insertTextTop 0;
  }
  if ($insertTextBottom) {
    $itemContent = Insert-Content $itemContent $insertTextBottom -1;
  }
  ($itemContent | Out-File -Path "$itemDirPath/$itemName" -Encoding ascii) -as [Void];
  # ($itemContent | Set-Content -Path "$itemDirPath/$itemName" -Encoding Ascii) -as [Void];

  # write a script to run the item to avoid the problem of running matlab in the linux background
  # use `./myshellscript >> output.txt &` to run matlab
  # see also : http://newsgroups.derkeiler.com/Archive/Comp/comp.soft-sys.matlab/2011-12/msg01401.html
  (New-RunMatlabScript -Path "$itemDirPath/run-$itemNameNoExt" -mFIleNameWithoutExt $itemNameNoExt -logFileName 'output.log') -as [Void]

  return [MatlabTaskAttr]::new($itemDirPath, $itemNameNoExt);
}

# work code

$sourceDir = Get-Item $sourceDirPath;
$sourceItems = Get-ChildItem $sourceDir;

if (Test-Path $destDirPath) {
  # clean the output dir
  Remove-Item $destDirPath -Force -Recurse;
}
# create the output dir
# (New-Item -ItemType Directory $destDirPath) -as [Void]
# $destDir = Get-Item $destDirPath;
$destDir = New-Item -ItemType Directory $destDirPath;

[MatlabTaskAttr[]]$matlabTask = $sourceItems | % { New-MatlabTask($_) }

foreach ($taskAttr in $matlabTask) {
  Start-Job -ArgumentList $taskAttr.path, $taskAttr.workItemName -ScriptBlock { 
    param($workPath, $workItemName); 
    cd $workPath;
    matlab -nodesktop -nosplash -logfile output.log -r $workItemName;
  };
}

