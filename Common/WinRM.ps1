# @see https://blog.csdn.net/leejeff/article/details/82907773
# @see https://blog.csdn.net/gang0221li0920/article/details/79383897

# 在服务器端添加信任的客户端地址（客户端的IP地址
# 通过winrm命令配置：(# 这里host1,2,3)
$trustedHosts = "210.28.132.75, 210.28.132.76"
winrm set winrm/config/client @{TrustedHosts="host1, host2, host3"}
