function Set-Snap() {

 # 安装SNAP

 # 设置 snap 代理
 sudo snap set system proxy.http="http://114.212.81.26:8080"
 sudo snap set system proxy.https="http://114.212.81.26:8080"

 # 添加到 PATH （不添加普通用户可使用安装的应用，但 root 不能使用）
  sudo gedit /etc/profile 
  # 添加： export PATH=$PATH:/snap/bin
  # 或者 gedit /etc/environment
  # 然后重启：shutdown -r / reboot

}
