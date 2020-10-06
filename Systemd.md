##Systemd
<pre>
Post -- boot sequence -- BootLoader --kernel+initramfs -- rootfs --/sbin/init
    init：
            CentOS 5：sysv init
            CentOS 6：upstart
            CentOS 7：Systemd
</pre>

####Systemd新特性
<pre>
1. 系统引导时实现服务并行启动
2. 按需激活进程
3. 系统状态快照
4. 基于依赖关系定义服务控制逻辑

核心概念：unit
    配置文件进行标识和配置：文件中主要包含了系统服务，监听socket、保存的系统快照以及与init相关信息
    /usr/lib/systemd/system
    /run/systemd/system
    /etc/systemd/system


Unit的类型：
    Server unit：文件扩展名.server，用于定义系统服务
    Target unit：文件扩展名为.target，用于模拟实现"运行级别"
    Device unit：.device用于定义内核识别的设备
    Mount unit：.mount定义文件系统挂载点
    Socket unit：.socket用于定义进程间通信用的socket文件
    Snapshot unit：.snapshot管理系统快照
    Swap unit：.swap用于标识swap设备
    Automount unit：.automount文件系统自动挂载点
    Path unit：.path用于定义文件系统中的一个文件或目录

关键特性：
    基于socket的激活机制，socket于服务程序分离
    基于bus的激活机制
    基于device的激活机制
    基于path的激活机制
    系统快照：保存各unit的当前状态信息于持久存储设备  

不兼容：
    systemctl命令固定不变
    非由systemd启动的服务，systemctl无法与之通信
    
系统管理服务：
    CentOS 7：service unit
        注意：能兼容再去的服务脚本
        
        命令：systemctl COMMAND name.service
    
    
    服务启动：systemctl {start|stop|restart|status} name.service
    条件式重启：systemctl try-restart name.service
    
    查看某服务当前激活与否的状态：systemctl is-active name.server    
    查看所有已经激活的服务：
        systemctl list-units --type service 
    查看所有服务：
        systemctl list-units --type service --all   
    设定开机自自动和关闭：
        systemctl enable|disable name.service
    查看服务是否开机自动：
        systemctl is-enabled name.service
        ll /etc/systemd/system/multi-user.target.wants/查询开机自启动那些服务
    禁止和取消禁止启动(服务不能启用)：
        systemctl mast|unmast name.service
    查看所有服务的开机自启的状态
        systemctl list-unit-files --type service
    其他命令
        查看服务依赖关系：systemctl list-dependencies  name.service 


target units：
    unit配置文件，.target
    运行级别：  
        0==runlevel0.target -> poweroff.target
        1==runlevel1.target -> rescue.target
        2==runlevel2.target -> multi-user.target
        3==runlevel4.target -> multi-user.target
        4==runlevel5.target -> graphical.target
        6==runlevel6.target -> reboot.target


    级别切换：systemctl isolate name.target
    查看级别：systemctl list-units --type target
    获取默认级别：systemctl get-default 
    修改默认级别：systemctl set-default name.target
                此命令执行了如下操作 
                    rm -f  /etc/systemd/system/default.target
                    ln -s /usr/lib/systemd/system/multi-user.target  /etc/systemd/system/default.target 
    切换至紧急求援模式：systemctl rescue
    切换至emergency(英莫急斯)
            systemctl emergency
            CentOS 6下面输入emergency即可进入

    
 其他常用命令：
    关机：systemctl halt、 systemctl poweroff
    重启：systemctl reboot
    挂起：systemctl suspend
    快照：systemctl hibernate  
    快照并挂起：systemctl hybrid-sleep 
  
</pre>
更多操作[参考详细说明][1]
[1]:https://linux.cn/article-5926-1.html 

    