# @see [[https://www.cnblogs.com/xidou/p/8472203.html]]

# 获取设备厂商名称
function Get-AndroidDeviceBrand {
  adb -d shell getprop ro.product.brand
}
