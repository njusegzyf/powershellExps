# @see [[https://github.com/qpdf/qpdf]]
# @see [[https://superuser.com/questions/580887/check-if-pdf-files-are-corrupted-using-command-line-on-linux Check if PDF files are corrupted using command line on Linux]]


[String]$qPdfBinDirPath = 'C:/Tools/_DocTool/qpdf/bin'
[String]$qPdfExePath = "$qPdfBinDirPath/qpdf.exe"

Set-Alias -Name qpdf -Value '.$qPdfExePath'

$checkCommand = '--check'
$okExitCode = 0
$errorExitCode = 2
$warningExitCode = 3
# $errorExitCodes = @(2)
# $allowedExitCodes = @(0, 3)

<#
--check-linearization
Checks file integrity and linearization status. 

--check
Checks file structure and well as encryption, linearization, and encoding of stream data.
A file for which --check reports no errors may still have errors in stream data content but should otherwise be structurally sound. 
If --check any errors, qpdf will exit with a status of 2.
There are some recoverable conditions that --check detects. These are issued as warnings instead of errors. 
If qpdf finds no errors but finds warnings, it will exit with a status of 3 (as of version 2.0.4). 
When --check is combined with other options, checks are always performed before any other options are processed. 
For erroneous files, --check will cause qpdf to attempt to recover, after which other options are effectively operating on the recovered file. 
Combining --check with other options in this way can be useful for manually recovering severely damaged files. 
#>


function Test-PdfFile([System.IO.FileInfo]$pdfFile, [Switch]$notAllowWarning) {
  $pdfFilePath = $pdfFile.FullName
  if ((-not ($pdfFile.Name -like '*pdf')) -or (-not ($pdfFile | Test-Path -PathType Leaf))) {
    Write-Error "$pdfFilePath is not a file." -ErrorAction Stop
  }

  if (-not $notAllowWarning) {
    $errorExitCodes = @(2)
  } else {
    $errorExitCodes = @(2, 3)
  }

  $qpdfProcessInfo = Start-Process $qPdfExePath -ArgumentList @($checkCommand, "`"$pdfFilePath`"") -Wait -PassThru -NoNewWindow
  $qpdfProcessExitCode = $qpdfProcessInfo.ExitCode

  # return ($qpdfProcessExitCode -eq 0) -or ($qpdfProcessExitCode -eq 3)
  # return $qpdfProcessExitCode -in $allowedExitCodes
  return $qpdfProcessExitCode -notin $errorExitCodes

<#
For a broken pdf file, qpdf outputs as follow and exit with 2:
WARNING: Z:\broken.pdf: can't find PDF header
WARNING: Z:\broken.pdf: file is damaged
WARNING: Z:\broken.pdf (offset 116): xref not found
WARNING: Z:\broken.pdf: Attempting to reconstruct cross-reference table
Z:\broken.pdf (offset 6024366): unable to find /Root dictionary

For a valid pdf file, qpdf outputs as follow and exit with 0: (Ace the Programming Interview[Wiley].pdf)
PDF Version: 1.6
File is not encrypted
File is not linearized
No syntax or stream encoding errors found; the file may still contain errors that qpdf cannot detect

For a pdf that can be opened but with warnings, qpdf outputs as follow and exit with 3:
checking D:\ZhangYF\Docs\Programming\Python\Python for Data Analysis, Data Wrangling with Pandas, NumPy, and IPython, 2nd Edition[O'Reilly].pdf
PDF Version: 1.5
File is not encrypted
WARNING: D:\ZhangYF\Docs\Programming\Python\Python for Data Analysis, Data Wrangling with Pandas, NumPy, and IPython, 2nd Edition[O'Reilly].pdf (object 2 0, offset 70): stream keyword followed by carriage return only
File is not linearized
WARNING: D:\ZhangYF\Docs\Programming\Python\Python for Data Analysis, Data Wrangling with Pandas, NumPy, and IPython, 2nd Edition[O'Reilly].pdf: file is damaged
...
#>



}


# Example
$checkDir = 'D:/ZhangYF/Docs'

foreach ($pdfFile in (Get-ChildItem $checkDir -Filter '*pdf' -Recurse)) {
  $pdfFilePath = $pdfFile.FullName
  Write-Output "Begin to check PDF file: $pdfFilePath"
  # Write-Verbose "Begin to check PDF file: $pdfFilePath"
  
  if (-not (Test-PdfFile $pdfFile)) { 
    # `Test-PdfFile $pdfFile` is the same as `Test-PdfFile $pdfFile -notAllowWarning:$false`,
    # and `Test-PdfFile $pdfFile -notAllowWarning` can be used to not allow QPDF checking warnings
    Write-Warning "Broken PDF file: $pdfFilePath"
  }
}
