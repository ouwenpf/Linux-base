##Linux进行及作业管理
####1. 进程管理
<pre>
内核的功用：进程管理、文件系统、网络功能、内存管理、驱动程序、安全管理
Porcess：运行中的程序的一个副本，存在生命周期
程序：静态的文件

Linux内核存储进程信息的固定格式：task stuct任务结构体
    多个任务的task struct组件的链表：task list任务列表

进程创建：
    init
    upstart
    systemd
        父子关系
        进程：都是有父进程创建
             fork()，clone

        
    进程优先级：
        0-139：
              1-99：实时优先级
              100-139：静态优先级
                    数字越小，优化级越高
            
              Nice值：
                  -20,19对应100-139

    进程内存：
            Page Frame：页框，用存储页面数据
            虚拟内存是内存管理内存的重要模型
                物理地址 -- 进程线性地址 -- 进程
                内核完成线性地址和物理地址的转换
            MMU：memory Management unit

    IPC：Inter process Communication
        同一个主机上：
                    signal
                    shm：shared memory
                    semerphor
        不同主机上：
                    rpc：remote procecure call
                    socket：
Linux内核：抢占式多任务

进程类型：
        守护进程：daemon，在系统引导过程中启动的进程
        前提进程：跟终端相关，通过终端启动的进程
                 注意：也可把前提启动的进程送往后台，以守护模式运行
进程状态：
        运行态：running
        睡眠态：sleeping
                可中断：interuptable
                不可中断：uninteruptable 
        停止态：暂停于内存中，但不会被调度，除非手动启动：stopped
        僵死态：zombie
进程分类：
        CPU-Bound：多分CPU资源
        IO-Bound：调高优先级

《穿越计算机的迷雾》 《linux内核设计与实现》 -- 《深入理解Linux内核》



linux进程查看及管理工具：pstree，ps，pidof，top，htop，glance，vmstat，dstat，kill，pkill，job，bg，fg，nohup

</pre>


####2. 作业
<pre>
前天作业：通过终端启动，且启动后一直占据命终端
后台作业：可以通过终端启动，但启动后即转入后台运行（释放终端）

如果让作业运行于后台
    1. 运行中的作业
        ctrl+z
    2. 尚未启动的作业
        COMMAND &
       此类作业虽然被送往后台运行，但其依然与终端相关；如果希望送往后台后，剥离与终端的关系
        nohup COMMAND &
    3. 查看所有作业：
        jobs
    4. 作业控制：
        1. fg [% job_num]：把指定的后台作业调回前台
        2. bg [% job_num]：把送往后台作业在后台继续运行
        3. kill -9 [% job_num]：终止指定的作业
</pre>


####进程优先级调整：
<pre>
    静态优先级：100-139
    进程默认启动时nice值为0，优先级为120；
        nice，renice

>nice命令其值的范围是-20~19
    nice -n # command
>renice命令
    renice -n # pid
    查看：
        ps -eo pid，comm，ni

</pre>


####周期性任务计划
<pre>
未来的某时间点执行一次任务：at，batch
周期性运行某任务：cron

电子邮件服务：
        smtp：simple mail transmission protocol，用于传送邮件
        pop3：post office protocol
        imap4：internet mail access protoc
        
        发送：mailx -s "标题" username
                邮件正文的生成：
                1. 直接给出，crtl+d
                2. 输入重定向
                3. 通过管道echo "test"|mailx root
        接受：mailx 
            
            
>at命令
    at [option] TIME
        TIME:
            HH:MM [YYYY-mm-dd]
            noon,midnight,teatime
            tomorrow
            now+ #{minutes,hours,days,OR weeks}
        at依赖atd.services，需要启动该服务
    常用选项：
        -l：列出指定队列中等待运行的作业，相当于atq
        -d：删除指定的作业，相当于atrm
        -c：查看具体作业任务
        -f：/path/from/somefile：从指定的文件中读取任务
        注意：作业执行结果以邮件通知给相关用户

>batch命令
    让系统自行选择空闲时间去执行此处指定的任务，工作中很少使用

>cron
    相关有关程序包：
        cronie：住程序包，提供了crond守护进程及相关辅助工具
        cronie-anacron：cronie的补充程序，用于监控cronie任务执行状态，如cronie中的任务在过去该运行的时间点未能正常运行，则anaron会随后启动一次此任务
        crontabls：包含centos提供系统维护任务
        
        确保crond守护处于运行状态
            centos 7：
                    systemctl status crond
            centos 6：
                    /etc/init.d/crond status

    计划要周期性执行的任务提交给crond，由其来实现到点运行
        系统cron任务，系统维护作业
            /etc/crontab
            # Example of job definition:
            # .---------------- minute (0 - 59)
            # |  .------------- hour (0 - 23)
            # |  |  .---------- day of month (1 - 31)
            # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
            # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
            # |  |  |  |  |
            # *  *  *  *  * user-name  command to be executed  15 21 * * * root /bin/echo "Howday"
            
            时间表示法：
                1. 特定值
                   给定时间有效取值范围
                2. *
                   给定时间点上有效范围内的所有值
                   表示"每..."
                3. 离散取值：,
                   1,3,5
                4. 连续取值
                   0-23
                5. 在指定时间范围上，定义步长：
                   */3：3即为步长
        

        用户cron任务：
            crontab命令定义，每个用户都有专用的cron任务文件：/var/spool/cron/username
            crontab命令
                -l：列出所有命令
                -e：编辑任务
                -r：移除所有任务，建议谨慎使用
                
                -u user：仅root可以为指定用户管理crontab任务 crontab -u test -e
            注意：运行结果以邮件通知给相关用户相关用户
                  COMMAND  &> /dev/null 
                 对应cron任务来说，%有特殊用途，如果在命令中还要使用%，则需要转义；如果把%放置于单引号中，也可以不用转义
              
            思考：
                 1. 如何在秒级别运行任务？
                 2. 如何实现每7分钟一次任务？
                 
            sleep命令
                 sleep NUMBER[suffix]
                    suffix:
                            s：秒 默认
                            m：分
                            h：小时
                            d：天

</pre>