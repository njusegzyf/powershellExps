function Install-Powershell() {

  # 安装 Powershell
  # https://docs.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1

  # Update the list of packages
  sudo apt-get update
  # Install pre-requisite packages.
  sudo apt-get install -y wget apt-transport-https software-properties-common
  # Download the Microsoft repository GPG keys
  wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
  # Register the Microsoft repository GPG keys
  sudo dpkg -i packages-microsoft-prod.deb
  # Update the list of products
  sudo apt-get update
  # Enable the "universe" repositories
  sudo add-apt-repository universe
  # Install PowerShell
  sudo apt-get install -y powershell
  # Start PowerShell
  # pwsh

  # install powershell via deb
  # sudo dpkg -i powershell_7.1.0-1.ubuntu.16.04_amd64.deb
  # sudo apt-get install -f
  
  # install powershell via snap
  # snap install powershell --classic
}
