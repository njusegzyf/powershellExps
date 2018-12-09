<#
netstat [-a][-e][-n][-o][-p Protocol][-r][-s][Interval][1] 
选项
命令中各选项的含义如下：
    -a 显示所有socket，包括正在监听的。
　　-c 每隔1秒就重新显示一遍，直到用户中断它。
　　-i 显示所有网络接口的信息，格式“netstat -i”。
　　-n 以网络IP地址代替名称，显示出网络连接情形。
　　-r 显示核心路由表，格式同“route -e”。
　　-t 显示TCP协议的连接情况
　　-u 显示UDP协议的连接情况。
　　-v 显示正在进行的工作。
　　-p 显示建立相关连接的程序名和PID。
　　-b 显示在创建每个连接或侦听端口时涉及的可执行程序。
　　-e 显示以太网统计。此选项可以与 -s 选项结合使用。
　　-f 显示外部地址的完全限定域名(FQDN)。
　　-o 显示太网统计信息(timers)。
　　-s 显示每个协议的统计。
　　-x 显示 NetworkDirect 连接、侦听器和共享端点。
　　-y 显示所有连接的 TCP 连接模板。无法与其他选项结合使用。
　　interval 重新显示选定的统计，各个显示间暂停的 间隔秒数。按 CTRL+C 停止重新显示统计。如果省略，则 netstat 将打印当前的配置信息一次。
#>

netstat -a # all sockets

netstat -t # all TCP links

netstat -u # all UDP links

