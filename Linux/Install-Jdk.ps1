function Install-Jdk($downloadRoot, $profilePath) {

  if (-not (Test-Path $downloadRoot)) {
    return $false;
  }

  # check installed JVM/JDK
  # dpkg -l | grep .*Java.*

  # install and config JDK
  $jdkDebPath = Get-ChildItem -Path $downloadRoot -Filter 'jdk-*_linux-x64_bin.deb'

  if (Test-Path $jdkDebPath) {
    sudo dpkg -i $jdkDebPath

    $jdkVersionRegex = [Regex]'jdk-(.+?)_linux-x64_bin.deb';
    $jdkVersionMatchResult = $jdkVersionRegex.Matches($jdkDebPath.Name)
    $jdkVersion = $jdkVersionRegex[0].Groups[1].Value;

    # $jdkDebPath.Name -match 'jdk-(.+?)_linux-x64_bin.deb';
    # $jdkVersion = $Matches[1];

    # Note: For JDK 12 and above versions, there is no JRE 
    $profileAddContent =
@"
export JAVA_HOME=/usr/lib/jvm/jdk-$($jdkVersion)
export CLASSPATH=.:`${JAVA_HOME}/lib
export PATH=`${JAVA_HOME}/bin:`$PATH
"@

    $profileAddContent | Out-File -FilePath $profilePath -Append

    return $true;

  } else {
    return $false;
  }

  # ./IDEA/bin/idea.sh

}
