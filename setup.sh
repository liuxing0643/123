#!/bin/bash

# 配置静态 IP
echo "auto eth0" > /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "address 8.222.166.143" >> /etc/network/interfaces  # 替换为您想要使用的静态 IP 地址
echo "netmask 255.255.255.0" >> /etc/network/interfaces  # 替换为您的子网掩码
echo "gateway 8.222.166.143" >> /etc/network/interfaces    # 替换为您的网关 IP 地址

# 重启网络接口
ifdown eth0 && ifup eth0

# 安装 iptables-persistent 以保存 iptables 规则
apt-get update
apt-get install -y iptables-persistent

# 将所有 TCP 和 UDP 流量都映射到指定端口 (比如将所有流量映射到 8080 端口)
iptables -t nat -A PREROUTING -p tcp -j REDIRECT --to-port 1002
iptables -t nat -A PREROUTING -p udp -j REDIRECT --to-port 1002
# 保存 iptables 规则
iptables-save > /etc/iptables/rules.v4
systemctl restart netfilter-persistent.service

# 提示完成
echo "配置已完成！"