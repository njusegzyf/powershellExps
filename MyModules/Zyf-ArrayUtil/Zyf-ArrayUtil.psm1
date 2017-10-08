function Test-InsertIndex {
  param(
    [Parameter(Mandatory=$true)]
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

function Insert-ContentAtBegin {
  param(
    [Parameter(Mandatory=$true)]
    [Object[]]$sourceContent,

    [Parameter(Mandatory=$true)]
    [Object[]]$insertContent
  )

  return Insert-Content $sourceContent $insertContent 0
}

function Insert-ContentAtEnd {
  param(
    [Parameter(Mandatory=$true)]
    [Object[]]$sourceContent,

    [Parameter(Mandatory=$true)]
    [Object[]]$insertContent
  )

  return Insert-Content $sourceContent $insertContent -1
}

Export-ModuleMember -Function Test-InsertIndex, Insert-Content, Insert-ContentAtBegin, Insert-ContentAtEnd