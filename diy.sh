#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

#添加自定义组件
git clone https://github.com/sypopo/luci-theme-atmaterial.git package/lean/luci-theme-atmaterial
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/sypopo/luci-theme-argon-mc.git package/luci-theme-argon-mc
git clone https://github.com/rufengsuixing/luci-app-onliner.git package/luci-app-onliner
git clone https://github.com/lisaac/luci-app-diskman package/luci-app-diskman
mkdir -p package/parted && cp -i package/luci-app-diskman/Parted.Makefile package/parted/Makefile

#修复核心及添加温度显示
sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

#修复docker桥接问题
sed -i '$a\net.bridge.bridge-nf-call-ip6tables = 1' package/base-files/files/etc/sysctl.conf
sed -i '$a\net.bridge.bridge-nf-call-iptables = 1' package/base-files/files/etc/sysctl.conf
sed -i '$a\net.bridge.bridge-nf-call-arptables = 1' package/base-files/files/etc/sysctl.conf
rm -rf package/network/config/firewall/files/firewall.config
cp -f ../firewall.config package/network/config/firewall/files/

#添加wifi
mkdir -p files/etc/config
cp -f ../wireless files/etc/config/

#修改机器名称
sed -i 's/OpenWrt/RaspberryPi4/g' package/base-files/files/bin/config_generate

#替换banner
rm -rf package/base-files/files/etc/banner
cp -f ../banner package/base-files/files/etc/

#添加nfs
cp -rf ../luci-app-nfs package/lean/
