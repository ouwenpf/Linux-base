##PXE和cobbler
####dhcp:dynamic host configuration protocol
C/S：
    Client：68/udp
    Server：67/udp
    bootp --> dhcp (租约)
    
    Client：dhcpdiscover
    Server：hcpoffer
    Client：dhcprequest
    Server：dhcpack

    广播：
    续租：单播
        50%  -- 75% -- 87.5% -- 93.75%
        169.254.X.X
        



####DHCP
<pre>
option domain-name "yueyun.com";#搜索域
option domain-name-servers 192.168.0.1;#默认自动获取dns地址
default-lease-time 600;#设置默认的IP租用期限
max-lease-time 7200;#设置最大的IP租用期限
log-facility local7;
subnet 10.0.20.0 netmask 255.255.255.0 {  
  range 10.0.20.20 10.0.20.50;
  option routers 10.0.20.1;
  next-server 10.0.20.55;#告知客户端TFTP服务器的IP
  filename "/pxelinux.0";#告知客户端TFTP根目录下载pxelinux.0文件
}
#为主机设置固定地址，dhcp分别固定地址
host tftpserver {
  hardware ethernet 00:0c:29:8b:b4:39; #分配主机的MAC地址
  fixed-address 10.0.20.55;#所要分配的地址，注意不要和地址池中在一个范围
}
</pre>

####tftp
<pre>
yum  install syslinux
cp /usr/share/syslinux/pxelinux.0  /var/lib/tftpboot
cp /media/cdrom/images/pxeboot/{vmlinux,initrd.img}  /var/lib/tftpboot
cp /media/cdrom/isolinux/{boot.msg,vesamenu.c32,splash.jpg}  /var/lib/tftpboot
cp /var/lib/tftpboot/pxelinux.cfg
mkdir /var/lib/tftpboot/pxelinux.cfg
cp /media/cdrom/isolinux/isolinux.cfg /var/lib/tftpboot/pxelinux.cfg/default
</pre>

####Cobbler：
<pre>
核心术语：
    distro：发行版，CentOS 6，CentOS 7
    profile：distro+kickstart
        subprofile
    system：

安装使用cobbler：
    yum install cobbler cobbler-web httpd dhcp pykickstart debmirror xinetd
    systemctl start httpd.service
    systemctl start cobbler.service  确保防火墙和selinux关闭
    cobbler check

1 : The 'server' field in /etc/cobbler/settings must be set to something other than localhost, or kickstarting features will not work.  This should be a resolvable hostname or IP for the boot server as reachable by all machines that will use it.

2 : For PXE to be functional, the 'next_server' field in /etc/cobbler/settings must be set to something other than 127.0.0.1, and should match the IP of the boot server on the PXE network.
3 : SELinux is enabled. Please review the following wiki page for details on ensuring cobbler works correctly in your SELinux environment:

4 : change 'disable' to 'no' in /etc/xinetd.d/tftp

5 : Some network boot-loaders are missing from /var/lib/cobbler/loaders, you may run 'cobbler get-loaders' to download them, or, if you only want to handle x86/x86_64 netbooting, you may ensure that you have installed a *recent* version of the syslinux package installed and can ignore this message entirely.  Files in this directory, should you want to support all architectures, should include pxelinux.0, menu.c32, elilo.efi, and yaboot. The 'cobbler get-loaders' command is the easiest way to resolve these requirements.

6 : enable and start rsyncd.service with systemctl

7 : debmirror package is not installed, it will be required to manage debian deployments and repositories
8 : The default password used by the sample templates for newly installed machines (default_password_crypted in /etc/cobbler/settings) is still set to 'cobbler' and should be changed, try: "openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'" to generate new one
9 : fencing tools were not found, and are required to use the (optional) power management features. install cman or fence-agents to use them

如上各问题的解决方法如下：
1. 修改/etc/cobbler/settings文件中的server参数的值为提供cobbler服务的主机相应的IP地址或主机名，如10.0.20.5
2. 修改/etc/cobbler/settings文件中的next_server参数的值为提供PXE服务的主机相应的IP地址或主机名，如10.0.20.5
3. 关闭selinux
4. 
5. 如果当前节点可以访问互联网，就需要安装syslinux程序包，而后复制/usr/share/syslinux/{pxelinux.0,memu.c32}等文件至/var/lib/cobbler/loaders/目录中
6. systemctl start rsyncd.service
7. 注释/etc/debmirror.conf文件中的@dists="sid";一行，注释/etc/debmirror.conf文件中的@arches="i386";一行
8. 执行"openssl passwd -1 -salt $(openssl rand -hex 4)"  "123456"，并替换/etc/cobbler/settings文件中default_password_crypted参数的值
9. 执行yum install fence-agents命令安装相应的程序即可

</pre>

![](https://i.imgur.com/6dIxBE6.png)


####自动重装系统
<pre>
yum install koan -y 
koan --replace-self --server=10.0.20.5 --profile=CentOS-7-x86_64
</pre>


####使用coobler_web
<pre>
1. 配置cobbler_web的认证功能(使用操作系统用户)
   默认安装cobbler后，其用户名和密码均为cobbler，为了安全起见需要进行更改用户名和密码
   cobbler_web支持多种认证方式，如authn_configfile、authn_Idal或authn_pam等，默认为authn_denyall，即拒绝所有用户登陆，下面说明两种认证用户登陆cobbler_web的方式
    
   使用authn_pam模块认证cobbler_web用户
   首先修改modules中[authentication]段的module参数的值为authn_pam
   接着添加系统用户，用户名和密码按需要设定即可，例如下面的命令所示。
   # useradd cblradmin
   # echo 'cblradmin'| passwd --stdin cblradmin
   而后将cblradmin用户添加至cobble_web的admin组中，修改/etc/cobbler/users.conf
   文件，将cblradmin用户添加为admin参数值即可，如下所示
   [admins]
   admin = "cblradmin"
   最后重启cobblerd服务，登陆如：https://10.0.20.5/cobbler_web访问即可

2. 使用authn_configfile模块认证cobbler_web用户(使用虚拟用户)
   首先修改modules中[authenication]段的module参数的值为authn_configfile
   接着创建认证文件/etc/cobbler/users.digest，并添加所需要的用户即可，需要注意的是，添加第一个用户时，需要为htdigest命令使用"-c"选项，后继续添加其他用户时不能再次使用，另外，cobbler_web的realm只能为Cobbler
   htdigest -c /etc/cobbler/user.digest Cobbler cblradmin
   最后重启cobblerd服务，登陆如：https://10.0.20.5/cobbler_web访问即可
</pre>




