##Linx系统调优基础
</pre>
进度调度：
    OS：硬件抽象，虚拟计算机
        system call
    CPU：time slice
        优先级
        调度器：CFS
        
        0-139
        0-99
        100-139：
            nice

    Memory：
        虚拟地址
        PAE:
            32bits,4bits
            64G
            线程地址空间依然为4G
            
            MySQL：单进程多线程


    taskset -pc -c 0,1,2,3-7 pid

    0-139：
        实时优先级：1-99
        动态优先级：100-139
    调度类别：
        SCHED_FIFO,
            chrt -f [1-99] /path/to/program arguments
        SCHED_RR:real-time
            chrt -r [1-99] /path/to/program arguments
        SCHED_NORMAL,SCHED_OTHER:100-139



    /proc/sys/vm/overcommit_memory 内存过量使用
    0：可以使用swap
    1：不能使用swap
    2：swap+ram*overcommit_ratio

	/proc/sys/vm/drop_caches： ps aux | awk '{mem += $6} END {print mem/1024/1024}'
    1：释放页page缓存
    2：释放slab缓存
    3：释放以上两种

	/proc/sys/vm/vfs_cache_pressure:系统在进行内存回收时，会先回收page cache, inode cache, dentry cache和swap cache。vfs_cache_pressure越大，每次回收时，inode cache和dentry cache所占比例越大
	vfs_cache_pressure默认是100，值越大inode cache和dentry cache的回收速度会越快，越小则回收越慢，为0的时候完全不回收

	/proc/sys/vm/swappiness:该配置用于控制系统将内存swap out到交换空间的积极性，取值范围是[0, 100]。swappiness越大，系统的交换积极性越高，默认是60，如果为0则不会进行交换。

    /proc/sys/vm/nr_hugepages调整大页内存

    /proc/sys/kernel/msgmax  消息信息的最大值
    /proc/sys/kernel/msgmnb  消息队列的最大值
    /proc/sys/kernel/msgmni  消息队列的最大数
    
    /proc/sys/kernel/shmmni  共享内存片段数
    /proc/sys/kernel/shmall  一次性可以使用的共享内存总量
    /proc/sys/kernel/shmmax  可以可以使用的共享内存最大总量(shmmni*shmall)

    保护进程不收oom_killer使用 echo -17 /proc/pid/oom_adj
                for i in `pgrep sshd`;do echo -17 > /proc/$i/oom_adj;done 

    cat /proc/sys/vm/dirty_ratio 脏数据占单个内存的比分比
    cat /proc/sys/vm/dirty_background_ratio 脏数据占整个物理内存的百分比


    /proc/sys/vm/drop_caches： 
        1：释放页page缓存
        2：释放slab缓存
        3：释放以上两种

    I/O：
        CFQ：完全公平调度
        Deadline：
        Anticipatory：
        Noop：无调度，先到先得
        修改磁盘调度器echo "" > /sys/block/sda/queue/scheduler
        每磁盘一个调度器

	
    cat /proc/sys/net/ipv4/tcp_tw_reuse重用，此参数开启那么tcp_timestamps一定要开启
	cat /proc/sys/net/ipv4/tcp_timestamps时间戳，
	cat /proc/sys/net/ipv4/tcp_tw_recycle快速关闭，在直接对外服务器是一定不能打开的(经过net上网的不能保证每个客户端机器的时间是一致的)，内网可以打开
</pre>