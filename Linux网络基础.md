##Linux网络管理
ICANN（The Internet Corporation for Assigned Names and Numbers）互联网名称与数字地址分配机构是一个非营利性的国际组织，成立于1998年10月，是一个集合了全球网络界商业、技术及学术各领域专家的非营利性国际组织，负责在全球范围内对互联网唯一标识符系统及其安全稳定的运营进行协调，包括互联网协议（IP）地址的空间分配、协议标识符的指派、通用顶级域名（gTLD）以及国家和地区顶级域名（ccTLD）系统的管理、以及根服务器系统的管理。这些服务最初是在美国政府合同下由互联网号码分配当局（Internet Assigned Numbers Authority，IANA）以及其它一些组织提供。现在，ICANN行使IANA的职能。 

    局域网：以太网，令牌环网
    Ethernet：CSMA/CD
        冲突域：交换机
        广播域：路由器
        MAC：Media Access Control介质访问控制
            48bits：
                24bits：
                24bits：    
    OSI，TCP/IP        
https://blog.csdn.net/qzcsu/article/details/72861891<br>
https://www.bilibili.com/video/av10921041/?p=121
![](https://i.imgur.com/IAD7QPs.png)
![](https://i.imgur.com/Ve5sQgx.png)

####tcp/ip分层
    application layer
    transport   layer
    internet    layer
    datalink    layer
    pysical     layer

####IPV4地址分类
<pre>
A类：
    0 000 0000 - 0 111 1111: 1-127
    网络数：126
    每个网络中的主机数：2^24-2
    默认子网掩码：255.0.0.0
    私网地址：10.0.0.0/8 1个私网地址

B类：
    10 00 0000 - 10 11 1111： 128-191
    网络数：2^14
    每个网络中的主机数：2^16-2
    默认子网掩码：255.255.0.0
    私网地址：172.16.0.0/16-172.31.0.0/16 32个私网地址

C类地址：
    110 0 0000 - 110 1 1111 -192-223
    网络数：2^21
    每个网络中的主机数：2^8-2
    默认子网掩码：255.255.255.0
    私网地址：192.168.0.0-192.168.255.0/24 256个私网地址
</pre>   

####Linux主机接入网络中
<pre>
    IP/mask
    路由：默认网关
    NDS服务器：
        主DNS服务器
        此DNS服务器
        第三DNS服务器
    配置方式：
        静态指定：
            ficfg：ficonfig，route
            ip：link，addr，route
            配置文件：system-config-network-tui(setup)
            CentOS 7:
                nmcli,mntui
        动态分配：
            DHCP：Dynamic Host Configuration Protocol

</pre>   

####配置网络命令
<pre>
ifconfig
    ipconfig eth0 [up|down]
    ifconfig eth0 ip/mask [up]
    注意：立即生效
    启用混杂模式：[-]promisc

route命令
    显示或者操作IP路由表
        主机路由：实现主机和外部主机之间的通讯的
        路由器路由表：实现网络间报文转发的
    添加：     
        route add -host IP gw 192.168.0.2
        route add -net IP/24 gw 192.168.0.2
        route add default gw 192.168.0.2
        route add -net|-host  dev eth0
    删除：
        route del -net|-host 189.145.23.69
        route add default gw 192.168.0.2
        
    
DNS服务器指定：
    /etc/sesolv.conf
        nameserver DNS_SERVER_IP1
        nameserver DNS_SERVER_IP2
        nameserver DNS_SERVER_IP3
    正解：FQDN --- IP  FQDN完全限定或完全合格域名
         dig -t A FQDN
         host -t A FQDN
    反解：IP ---  FQDN
         dig -x IP
         host -t PTR IP


netstat命令：打印网络连接，路由表，网络接口统计数据，伪装连接，组播成员
    显示网络连接：
        -t：tcp协议相关
        -u：udp协议相关
        -r：raw 
        -l：处于监听状态
        -a：所有状态
        -n：以数字显示IP和端口
        -e：扩展格式
        -p：显示进程的PID号和进程名称
        常用组合：-tanp，-lntup，-uanp
    显示路由表：
        netstat -rn
    接口统计数据：
        netstat -i 所有接口统计数据  
        netstat -Ieth0 显示指定接口的统计数据


ip：命令
    ip [potion] OBJECT
    OBJECT:= { link | addr | route | help}
    { link | addr | route | }
        
        ip link - network device configureion
            set
                ip link set dev eth0 up|down 
                
            show 
                ip link show eth0：指定接口
                ip link show up：仅仅显示处于激活状态的接口

        ip  addr -protocol address management
                ip addr [add|del] IP/mask dev eth0 
                [label LABEL]:添加地址时网卡别名
                    ip addr [add|del] dev eth0  label eth0:0 
                [scope  {global|link|host}]：指明作用域
                    global：全局有用
                    link：仅链接可用
                    host：本机可用
                    注意：设置时候注意私网和公网地址的区别
        ip addr show 
                    [ dev device]
                    [pattern]
        ip addr flsh      
                    使用格式同show
                    ip addr flush dev eth0 [pattern] 批量删除一类地址
                        ip addr flush dev eth0  label eth0:*
                        ip addr flush dev eth0  label eth0:[12]
                    
    
        ip route  add|del|flush
            添加路由方式：
                ip route add IP via 192.168.0.2           route add -host IP gw 192.168.0.2
                ip route add IP/24 via 192.168.0.2        route add -net IP/24 gw 192.168.0.2
                ip route  add 172.16.1.0/24   dev eth0    route add -net|-host  dev eth0
                ip route add|del default via 192.168.80.130   route add|del default gw 192.168.80.130
            删除路由：
                ip route del
                    TARGET：
                            主机路由：IP
                            网络路由：network/mast
                

ss命令：
   -t：tcp协议相关
   -u：udp协议相关
   -w：裸套接字
   -x：unix sock相关
   -l：listen状态的连接
   -a：所有
   -n：数字格式
   -p：相关的进程及pid
   -e：扩展的信息
   -w：内存使用量

    ss -tan state established
    state: established, syn-sent,  syn-recv,  fin-wait-1,  fin-wait-2,  time-wait,closed, close-wait, last-ack, listen and closing
TCP的常见状态：
    tcp finite state machine
    LISTEN：监听
    ESTABLISHED：已经建立的连接



Linux网络属性配置
    IP，MASK，GW，DNS相关配置文件：
        /etc/sysconfig/network-scripts/ifcfg-iface
    路由相关的配置：
        /etc/sysconig/networ-scripts/route-iface    
    
    
    /etc/sysconfig/network-scripts/ifcfg-iface
        DEVICE：此配置文件应用到的设备
        HWADDR：对应此设备的mac地址
        BOOTPROTO：激活此设备时使用的地址配置协议，常用的dhcp，static，none，bootp
        NM_CONTROLLED：NM是NetworkManger的简写，此网卡是否接受NM管理控制：CentOS建议改为“no”
        ONBOOT：在系统引导时是否激活此设备
        TYPE：接口类型，常见的有Ethernet，Bridge
        UUID：设备的唯一标识
        
        IPADDR：指明IP地址
        NETMASK：子网掩码
        GATEWAY：默认网关
        DNS1：第一个DNS服务器指向
        DNS2：第二个DNS服务器指向
        USERCTL：普通用户是否可控制此设备
        PEERDNS：如果BOOTPROTO的值为"dhcp"，是否允许dhcp Server分配的dns
    
    /etc/sysconfig/network-scripts/route-iface
        两种风格：
                1.TARGET via gw

                    172.16.0.0/24 via 192.168.0.2
                    
                2.每三行定义一条路径
                    ADDRESS0=172.16.1.0
                    NETMASK0=255.255.255.0
                    GATEWAY0=192.168.0.2
 
给网卡配置多地址：
        ficonfig
            ifconfig eth0:1 192.168.0.130 up
        ip
            ip addr add 192.168.0.130 dev eth0 label eth0:1
        配置文件：
            ifcfg-eth:1
            DEVICE=eth:1
            UUID，网关，mac都去掉
            注意：网卡别名不能使用dhcp协议引导

网络接口识别并命名相关的udev配置文件centos 6 ：
    /etc/udev/rules.d/70-persisten-net.rules
    卸载网卡驱动：
        modprobe -r e1000
    装载网卡驱动：
        modprobe e1000

</pre>   


####CentOS 7网络属性配置
<pre>
传统命令方式：以太网etho[0,1,2,...]，wlan[0,1,2,...]

CentOS7网卡命令机制：
    (1)systemd对网络设备的命令方式：
        1. 如果Firmware或者BIOS为主板上集成的设备提供的索引信息可用，且可预测则根据此索引进行命名，例如eno1；
        2. 如果Firmware或者BIOS为PCI-E扩展槽所提供的索引信息可用，且可预测，则根据此索引进行命名，例如ens1；
        3. 如果硬件接口的物理位置信息可用，则根据此信息进行命名，例如enp2s0(PCI总线上第二总线的第一个插槽设备)
        4. 如果用户显示启用，也可根据mac地址进行命名，enx2387a1dc56；
        5. 上述均不可用时的时候，则使用传统的命名机制
        
        上述命名机制中，有的需要biosdevname程序的参与
    (2)名称组成格式
        en：ethernet
        wl：wlan无线局域网设备
        ww：wwan无线广域网设备.

        名称类型：
            o<index>：集成设备设备索引号
            s<slot>：扩展槽的索引号
            x<mac>：基于mac地址进行命名
            p<bus>s<slot>：enp2s1
            
    (3)网卡设备的命名过程：
       第一步：
            udev:内核中的一种机制，能够将内核中识别的每个设备及相关信息通过sys这个伪文件系统，向用户空间进行输出
            udev，辅助工具/lib/udev/rename_device会根据/usr/lib/udev/rules.d/60-net.rules中的
       第二步：
            如果biosdevname=1程序没有被禁用，第一步又没有重命名成功
            biosdevname程序会根据/usr/lib/udev/rules.d/71-biosdevname.rules中的
            基于bios命名的都是根据此法则
       第三步：
            通过检查网络接口设备
            根据/usr/lib/udev/rules.d/75-net-description
            


    回归传统方式命名：
        1. 编辑：vim  /etc/default/grub 
            GRUB_CMDLINE_LINUX="crashkernel=auto net.ifnames=0 rhgb quiet"  如果是安装系统的时候可以增加biosdevname=0禁用biosdevname程序  net.ifnames=0重命名禁用
        2. 为grub生成其配置文件
           grub2-mkconfig  -o /boot/grub2/grub.cfg
        3. 修改ifcfg文件
           mv /etc/sysconfig/network-scripts/ifcfg-ens33   /etc/sysconfig/network-scripts/ifcfg-eth0
           NAME=eth0
           DEVICE=eth0
        4. 重启系统即可reboot


hostnamectl  --static set-hostname Test

</pre>