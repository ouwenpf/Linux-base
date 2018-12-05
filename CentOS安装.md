##CentOS系统安装
<pre>
bootload -- kernel(initramfs) -- rootfs -- /sbin/init

anaconda(爱了看达)：安装程序
    tui：基于curses的文本窗口
     

CentOS的安装程序启动过程
    MBR：boot.cat 类似于stage1，存放于前446个字节中
    stage2：isolinux/isolinux.bin
        配置文件：isolinux/isolinux.cfg
        加载内核：isolinux/vmlinuz
        向内核传递参数：append initrd=initrd.img
    装载根文件系统：并启动anaconda
    
    默认启动GUI接口，内存小于1024M的时候，默认使用文本安装
    若是显示指定使用TUI接口：
        向内核传递"text"参数即可，敲ESC
            boot：linux text
        或tab键
            输入：text
    注意：上述内容一般应位于引导设备，而后续的anaconda及其安装用到的程序包等有几种方式可用
        本地光盘
        本地硬盘
        ftp server：yum repository
        http server：yum repository
        nfs server
        如果想手动指定安装源：
            boot：linux method 

anconda应用的工作过程：
    安装前配置阶段
        安全前使用的语言
        键盘类型
        安装目标存储设备
            Basic Storage：本地磁盘
            特种设备：iscsi
        设定主机名称
        配置网络接口
        时区
        管理员密码
        设定分区方式及MBR的安装位置

        
        关键一个普通用户
        
        选定要安装的程序包
    安装解决
        在目标磁盘创建分区，执行格式化操作等
        选定的程序包安装至目标位置
        安装bootloader
    首次启动
        iptables
        selinux
        core dump



anaconda的配置方法：
1. 交互式配置方式
2. 通过读取事先给定的配置文件自动完成配置
   按特定语法给出的配置选项
        kickstart文件


安装引导选项：
    boot：
        text：文本安装方式
        method：手动指定使用的安装方式
        于网络相关引导选项
            ip=IPADDR
            netmask=MASK
            gateway=GW
            dns=DNS_SERVER_IP
            ifname=NAME：MAC_ADDR
        与远程访问功能相关的引导选项
            vnc
            vncpassrword='password'
        指明kickstart文件的位置
            ks=
                DVD drive：ks=cdrom：/path/to/kickstart_file
                Hard drive:ks=hd:/path/device/drectory/kickstart_file
                Http server:ks=http://host:port/path/to/kickstart_file
                FTP server:ks=ftp://host:port/path/to/kickstart_file
                HTTPS server:ks=https://host:port/path/to/kickstart_file
                



</pre>