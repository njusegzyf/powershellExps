$jdkPath = 'C:\Program Files\jdk8u112';

if (-not $env:JAVA_HOME) {
  Write-Host "Set JAVA_HOME to $jdkPath and set PATH ans CLASSPATH (for the machine) accordingly."

  [Environment]::SetEnvironmentVariable('JAVA_HOME', $jdkPath, [EnvironmentVariableTarget]::Machine);
  [Environment]::SetEnvironmentVariable('PATH', "$env:PATH;%JAVA_HOME%\bin;", [EnvironmentVariableTarget]::Machine);
  if ($env:CLASSPATH) {
    [Environment]::SetEnvironmentVariable('CLASSPATH', "$env:CLASSPATH;.;%JAVA_HOME%\lib;", [EnvironmentVariableTarget]::Machine);
  } else {
    [Environment]::SetEnvironmentVariable('CLASSPATH', ".;%JAVA_HOME%\lib", [EnvironmentVariableTarget]::Machine);
  }

  # The following only works in the current session
  # $env:JAVA_HOME = $jdkPath;
  # $env:PATH = "$env:PATH;%JAVA_HOME%\bin;";
  # $env:CLASSPATH = "$env:CLASSPATH;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tool.jar;"

  Read-Host
}

