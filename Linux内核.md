##Linux Kernel
<pre>
单内核体系设计，单充分借鉴了微内核设计体系，为内核引入模块化机制
    内核组成部分：
        kernel：内核核心，一般为bzImage，通常在/boot/目录下，名称为vmlinuz-version-release
        kernel object：内核对象，一般放止于/lib/modules/version-release/
            [ ]：N
            [M]：M
            [*]：Y

        辅助文件：ramdisk
                initrd
                initramfs

运行中的内核
    uname命令：
        -n：显示主机名称
        -r：显示内核版本号
        -a：显示所有信息
        -s：显示系统信息如：linux
        -p：显示平台如x86_64


    lsmod:命令
        显示由核心已经装载的内核模块
        显示的内容来自于：/proc/modules文件

    modinfo命令：
        显示模块的详细描述信息
        -n:只显示模块文件路径
        -p：author
        -a：description
        -l：license

    modprobe命令:
        装载或卸载内核模块
            modprobe modulename  
                配置文件：/etc/modprobe.conf，/etc/modprobe.d/*.conf
            
           
    depmod命令：
        内核模块依赖关系文件及系统信息隐射文件的生成工具
        默认生成的位置/lib/modules/version
        
</pre>


####/proc目录
<pre>
内核把自己内部状态信息及统计信息，以及可以配置参数通过

参数：
    只读：输出信息
    可写：可接受用户指定"新值"来实现对内核某功能或特性的配置
         /proc/sys
         1. sysctl命令用于查看或设定次目录中诸多参数
               sysctl -w  kernel.hostname=test
         2. echo命令通过重定向的方式也可以修改大多数参数的值
              echo 'test' > /proc/sys/kernel/hostname

sysctl命令：
    默认配置文件：/etc/sysctl.conf  /usr/lib/sysctl.d/*.conf  /etc/sysctl.d/*.conf
        1. 设置某参数
            sysctl -w  kernel.hostname=test
        2. 通过读取配置文件设置参数
            sysctl -p  立即生效


    常用中的几个参数：
        net.ipv4.ip_forward
        vm.drop_caches
        kernel.hostname

</pre>


####/sys目录
<pre>
sysfs：输出内核识别的各个硬件的相关属性信息，也有内核对硬件特性的设定信息，有些参数是可以修改的，用于调整硬件工作特性
    udev通过此路径下输出的信息动态为各个设备创建所需要的设备文件：udev是运行用户空间的程序，专用工具：udevadmin，hotplug
    udev为设备创建设备文件时候，会读取事先定义好的规则文件，一般在/etc/udev/rules.d及/usr/lib/udev/rules.d目录下
</pre>

####ramdisk文件的制作：
<pre>
1.  mkinitrd命令
    为当前正在使用的内核重新制作ramdisk文件
    mkinitrd  /boot/initramfs-`uname -r`.img  `uname -r`     
2.  dracut命令
    为当前正在使用的内核重新制作ramdisk文件
    dracut /boot/initramfs-`uname -r`.img  `uname -r`    

</pre>