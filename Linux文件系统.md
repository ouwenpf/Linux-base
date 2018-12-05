##Linux文件系统
####根文件系统(rootfs)
    root filesystem
####FHS 
<pre>
FileSystem Heirache Standard:文件系统层次标准
---------------------------------------------------------------------------
/boot:引导文件存放目录，内核文件(vmlinuz)、引导加载器(bootloader)都存放于此目录
/bin:供所有用户使用的基本命令；不能关联至独立分区，OS启动即会用到的程序
/sbin:管理类的基本命令；不能关联至独立分区，OS启动即会用到的程序
/lib:基本的共享库文件，以及内核模块文件(/lib/modules)
/lib64:专用于x86_64系统上的辅助共享库文件存放位置
/etc:配置文件目录(纯文件文件)
/home/username:普通用户家目录
/root:管理员家目录
/media:便携式移动设备挂载点
    cdrom
    usb
/mnt:临时文件系统挂载点
/dev:设备文件及特殊文件存储位置
    b:block device可随机访问设备
    c:character device线性访问设备(有先右后，时序性)
/opt:第三方应用程序的安装位置(可理解为windows附件)
/srv:系统上运行的服务用到的数据
/tmp:临时文件


/usr:universal shared,read-only data全局共享只读数据文件
    bin:保证系统拥有完整功能而提供的应用程序
    sbin:
    lib:
    lib64:/usr/bin和/usr/sbin用到基本共享库如果在/lib和lib64下没有，提供额外的基本共享库；配置文件仍然在/etc目录下
    include:C程序的头文件(header files)，为库文件提供不同的调用方式(库文件理解为工具，头文件则是此工具的使用说明)
    share:结构化独立的数据，例如doc，man等
    src:源码存放位置，如：编译内核的时候
/usr/local/:第三方应用程序的安装位置(取代早期的/opt)
    bin,sbin,lib,lib64,etc,share

/var:variable date files可变目录，存放经常发生变化的数据文件
    cache:应用程序缓存数据目录
    lib:应用程序状态信息数据
    local:专用于为/usr/local下的应用程序存储可变数据
    lock:锁文件
    log:日志目录及文件
    opt:专用于为/opt下的应用程序存储可变的数据
    run:运行中的进程相关的数据；通过用于存储进行的pid文件
    spool:应用程序的池数据
    tmp:保存系统两次重启之间产生的临时数据
    
    
/proc:用于输出内核于进程信息相关的虚拟文件系统
/sys:用于输出当前系统上硬件设备相关信息的虚拟文件系统
/selinux:security enhanced linux,selinux相关的安全策略等信息的存储位置

/misc:杂项，通常备用为空
lost+found:ext系列文件系统格式化后默认的目录，跟当前系统无关
</pre>

####Linux上的应用程序的组成部分
<pre>
二进制程序:/bin,/sbin,/usr/bin,/usr/sbin,/usr/local/bin,/usr/local/sbin
库文件:/lib,/lib64,/usr/lib,/usr/lib,/usr/lib64,/usr/local/lib,/usr/local/lib64
        多个程序直接的共享库；自己会被其它应用程序调用和被做二次开发，向外提供API
        某个应用程序会有多个执行文件，多个执行文件某个功能是公共的，所有就有库文件；
        共享库:多个应用程序用到的相同的功能
配置文件:/etc,/usr/etc,/usr/local/etc
帮助文件:/usr/share/man,/usr/share/doc,/usr/local/share/man,/usr/local/share/doc
</pre>

####Linux下的文件类型
1. - (f):普通文件
2. d:目录文件
3. b:块设备
4. c:字符设备
5. l:符号链接文件
6. p:管道文件
7. s:套接字文件socket


##文件查找：

####locate：
* 依赖于事先构建的索引；索引的构建是在系统较为空闲时自动进行(周期性任务)；手动更新数据库(updatedb)
* 索引的构建过程需要遍历整个根文件系统，极消耗系统资源
* 工作特点：
    * 查找速度快
    * 模糊查询
    * 非实时查找
    * 基于locate KEYWORD


####find：
* 实时的查找工具，通过遍历指定路径下的文件系统完成文件查找
* 工作特点：
    * 查找速度想的对于locate略慢
    * 精确查找
    * 实时查找
* 语法： 
    * **find [OPTION]...[查找路径][查找条件][处理动作]**
        * 查找路径：指定具体没有吧路径；默认为当前目录
        * 查找条件：指定的查找标准，可以文件名，大小，类型，权限等标准进行，默认为找出指定路径下的所有文件
        * 处理动作：对符合条件的文件做什么操作；默认输出至屏幕
        *  
        *   
        * 查找条件：
            * 根据文件类型查找：
                * -type：
                    * f：普通文件
                    * d：目录文件
                    * l：符号链接文件
                    * s：套接字文件
                    * b：块设备文件
                    * c：字符设备文件
                    * p：管道文件
                    > find /tmp \\( -type d  -o  -type f \\) -ls 括号需要转义且两边需要空格<br>
                    > find / ! \\( -user root -o -group root \\) -ls
            * 组合条件：
                * 与：-a
                * 或：-o
                * 非：！
            * 根据文件名查找：
                * -name "文件名称"：支持使用glob
                    * *，？，[]，[^]
                * -iname "文件名称"：支持使用glob，不区分字母大小写
                    * *，？，[]，[^]
                * -max-depth # ：按文件目录深度查询
            * 根据属主，属组查找：
                * -user：查找属主为指定用户的文件
                * -group：查找属组为指定组的文件
                * -uid：查找属主为指定的UID号的文件
                * -gid：查找属组为指定的GID号的文件
                * -nouser：查找没有属主的文件
                * -nogroup：查找没有属组的文件
            * 根据文件大小来查找
                * -size [+|-]#UNIT
                    * 常用单位:k，M，G
                    * #UNIT：(#-1，#] (3-1,3]
                    * -#UNIT：[0，#-1] [0,3-1]
                    * +#UNIT：(#，无穷大) (3,无穷大)
                    > 例如查询3k文件
            * 根据时间戳查找：
                * 以"天"为单位：
                    * -atime
                        * #：[#，#+1)  []
                        * +#：[#+1,无穷大]
                        * -#：[0，#)
                    * -mtime
                    * -ctime
                    > 例如当前时间点是2018-02-07 21:55:06 <br>
                    > 3：表示2018-02-03 21:55:07 - 2018-02-04 21:55:06 <br>
                    > +3：表示表示最早日期 - 2018-02-03 21:55:06 <br>
                    > -3：2018-02-04 21:55:08 - 2018-02-07 21:55:07 <br>
                * 以"分钟"为单位
                    * -amin
                    * -mmin
                    * -cmin

           * 根据权限查找：
               * -perm [/|-]mode(centos7为/；centos6为+)
                   * mode:精确权限匹配
                       * -perm 600：表示权限为600的文件
                   * /mode：任何一类(u,g,o)对象的权限中只要能一位匹配即可(隐含或(-o)的关系)
                       * -perm /666：表示属主(6：r+w)属组（6：r+w）其它(6：r+w)任意一位有w或r即可
                       * -perm /600：表示属主(6：r+w)属组（0：不做查询依据）其它(0：不做查询依据)属主有w或r即可
                       * ！ -perm /+222：表示没有所有用户没有写权限的文件
                   * -mode：每一类对象都必须同时拥有为其指定的权限标准(隐含且(-a)的关系)
                       * -perm -666：表示属主(6：r+w)属组（6：r+w）其它(6：r+w)所有位同时有w且r即可
                       * -perm /600：表示属主(6：r+w)属组（0：表示任意）其它(0：表示任意)属主有w且r即可，其它位任意
                       * -perm -222：表示所有用户都有执行权限的文件
                       * ！ -perm -222：表示至少有一类用户没有执行权限的文件
           * 处理动作：
               * -ls：类似于对查找到的文件执行"ls -l"
               * -exec command {} \;对查找到的文件执行command指定的命令
                   * find /tmp/ -type f -name 'vim*' -exec mv {} {}.new \;
                   * find /tmp/ -type f -name 'vim*' |xargs  -i mv {} {}.log 
                   * {}:用于引用查找到的文件名称自身，此用法很实用务必掌握之
               > 注意：find传递查找到的内容至后面指定的命令时，查找到所有符合条件的文件一次性传递给后面的名，有些命令不能接受过多的参数，此时命令执行可能会失败，另一种方式可以规避此问题<br>
               > find |xargs -i command



* 练习
    * 查找/var/目录下属主为root，且属组为mail的所有文件或目录
        * find /var/ -user root -group mail -ls
    * 查找/usr目录下不属于root，bin或test的所有文件或目录
        * find /var/ ! \\( -user root -o -user bin -o -user test  \\)  -ls
    * 查找/etc/目录下最近一周内其内容修改过，同时属主不为root，也不是hadoop的文件或目录
        * find /etc/ ! \\( -user root -o -user test  \\) -a  -atime -7 
    * 查找当前系统上没有属主或属组，且最近一周内曾被访问过的文件或目录
        * find /etc/  -nouser  -a -nogroup  -a -atime -7 
    * 查找/etc/目录下大于1M其类型为普通文件的所文件或目录
        * find /etc/  -size +1M  -exec ls -hl {} \;
    * 查找/etc/目录下所有用户都没有写权限的文件
        * find /etc/  !   -perm  /+222 -ls
    * 查找/etc/目录下至少有一类用户没有执行权限的文件
        * find /etc/  !   -perm  -111 -ls
    * 查找/etc/目录下至多有一类用户有写权限的文件
        * find /tmp/ ! \\( -perm /+022 -a -perm /+220  -a -perm /+202  \\) -ls |awk '$3 ~ /w/{print $0}'
    * 查找/etc/init.d目录下所有用户都有执行权限，且其它用户有写权限的文件
        * find /etc/  -perm -113 -ls

