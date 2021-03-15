function Install-BuildTools($downloadRoot) {

  if (-not (Test-Path $downloadRoot)) {
    return $false;
  }

  apt-get install build-essential
  apt-get install make cmake
  # apt-get install make cmake-qt-gui  ubuntu-make 

  # install and config cmake using snap
  # snap install cmake --classic

}
