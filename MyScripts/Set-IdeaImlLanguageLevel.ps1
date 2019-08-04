
function Set-LanguageLevelInFolder($folder) {
  foreach ($file in Get-ChildItem $folder -Recurse -File -Include '*.iml') {
    # Write-Host "$file : $( $file -like '*.iml' )"
    # for each IDEA iml file
    Set-LanguageLevel $file
  }

  #  foreach ($folder in Get-ChildItem $folder -Directory -Filter {($_ -notlike 'bin') -and ($_ -notlike 'out') }) {
  #    # for each folder
  #    Set-LanguageLevelInFolder $folder
  #  }
}

$targetString =  'LANGUAGE_LEVEL="JDK_12">'
$replaceString = 'LANGUAGE_LEVEL="JDK_12_PREVIEW">'

function Set-LanguageLevel($path) {
  $content = Get-Content $path
  if ($content -clike "*$targetString*") {
    $fixedContent = $content -creplace $targetString, $replaceString
    Write-Host "Fix language level in file: $path."
    Set-Content $fixedContent -Path $path
  }
}

 Set-LanguageLevelInFolder 'Z:/Test'
