$sysLibDirPath = '/usr/lib'
$libraries = @(
    @('/root/eclipseWorkspace/ATGWrapperCpp/src/coral', 'CallCPP.cpp', 'Coral'),
    @('/root/eclipseWorkspace/ATGWrapperCpp/src/stat', 'CallCPP_Stat.cpp', 'Stat'),
    @('/root/eclipseWorkspace/ATGWrapperCpp/src/dartAndEtc', 'CallCPP.cpp', 'DartAndEtc')
)
$libPrefix = 'CallCPP'
$jdkPath = '/usr/java/jdk1.8.0_121'

foreach ($library in $libraries){
  Set-Location -Path $library[0]

  $librarySuffix = $library[2]
  $libraryName = "lib$libPrefix$librarySuffix.so"
  g++ "-I$jdkPath/include" "-I$jdkPath/include/linux" -fPIC -shared -o $libraryName $library[1]
  Copy-Item $libraryName -Destination $sysLibDirPath
}