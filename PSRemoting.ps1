# see: http://bob-zhangyong.blog.163.com/blog/static/17610982013319113920630/

# In the remote machine
Enable-PSRemoting

# In the localhost
[String]$remoteMachineIp = '210.28.132.75'
[String]$remoteMachineUser = 'administrator'
[String]$remoteMachinePassword = 'jsx@123456'

# 添加主机到 TrustedHosts 表
Set-Item wsman:\localhost\Client\TrustedHosts -Value $remoteMachineIp
# 将 IP 为192.168.3.* 的主机都加入 TrustedHosts 表
# Set-Item wsman:\localhost\Client\TrustedHosts -Value 192.168.3.*

Enter-PSSession $remoteMachineIp -Credential $remoteMachineUser
