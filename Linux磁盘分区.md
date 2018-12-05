##Linux磁盘管理
####设备号码：
* 主设备号：major number 标识设备类型
* 次设备号：minor number 标识同一类型下的不同设备
####磁盘接口类型：
* 并行：
    * IDE：133MB/s
    * SCSI：640MB/s
* 串行：
    * SATA：6Gbps
    * SAS：6Gbps
    * USB 3.0：480MB/s
    * rpm：rotations per minute每分钟转速

####/dev/DEV_FILE
* 磁盘设备的设备文件命令：
    * IDE：/dev/hd
    * SCSI，SATA，SAS，USB：/dev/sd
        * 不同设备：a-z
            * /dev/sda，/dev/sdb，...
        * 同一设备上的不同分区：1,2，...
            * /dev/sda1，/dev/sda5
          
####机械式硬盘：
* trcak：磁道
* cylinder：柱面
* secotr：扇区
    * 512bytes
* 如何分区：
    * 按柱面
* MBR：主引导记录
    * 主引导记录区(MBR)就在这个位置上。MBR位于硬盘的0磁头0柱面1扇区，其中存放着硬盘主引导程序和硬盘分区表。在总共512字节的硬盘主引导记录扇区中，446字节属于硬盘主引导程序，64字节属于硬盘分区表(DPT)，两个字节(55 AA)属于分区结束标志
* GPT：
    * 全局唯一标识分区表(GUID Partition Table)，与MBR最大4个分区表项的限制相比，GPT对分区数量没有限制

####分区管理工具fdisk,parted
<pre>
fdisk：对弈一块磁盘来讲，最多只能管理15个分区
fdisk device
    子命令；管理功能
        p：print，显示已有分区
        n：new，创建新分区
        d：delete，删除分区
        w：write，写人磁盘并退出
        m：获取帮助
        l：列表分区id
        t：调整分区id
查看内核是否已经识别新的分区：
    cat /proc/partations
通知内核
    partx -a /dev/DEVICE
           -a -n M：N
    kpartx -a /dev/DEVICE
centos5:
    partporbe [/dev/device]
CentOS5：使用partprobe
 Device    Boot      Start        End      Blocks   Id  System 
/dev/sda1   *        2048    10487807     5242880   83  Linux 

Device：设备
Boot："*"号所在的这一项表示可引导设备
start：起始柱面
End：结束柱面
Blocks：磁盘块数
Id：分区标识
System：应用在那个系统上的分区标识

fdisk分区：
centos6：echo -e "n\np\n1\n\n+10G\nn\np\n2\n\n+10G\nw" |fdisk -cu /dev/sdb
centos7：echo -e "n\n\n\n\n+10G\nn\n\n\n\n\nw\n" |fdisk  /dev/sdb

parted分区：
parted -s /dev/sdb {p|h} 打印或帮助信息
parted -s /dev/sdb rm number 删除
parted -s /dev/sdb mktable {msdos|gpt} 分区表格式转换
parted -s /dev/sdb mkpart primary {ext4|xfs|btrfs} 2048s  {100G|100%}
</pre>


####Linux文件系统管理
* Linux文件系统：ext2，ext3，ext4，btrfs比较流行的文件系统
    * cat /proc/filesystems
    * swap：交换分区
    * 光盘：iso9660 
* Windows：fat32，ntfs
* Unix：FFS，UFS，JFS2
* 网络文件系统：NFS，CIFS
* 集群文件系统：GFS2，OCFS2
* 分布式文件系统：ceph，moosefs，mogilefs，GlusterFS，Lustre
* 根据其是否支持“journal”功能
    * 日志文件系统：
    * 非日志文件系统：ext2，vfat
* 文件系统组成部分
    * 内核中的模块：ext4，xfs
    * 用户空间管理工具：mkfs.ext4，mkfs.xfs，mkfs.vfat
* Linux的虚拟文件系统：VFS

####磁盘管理命令
<pre>
创建文件系统
>mkfs命令：
    mkfs.FS_TYPE /dev/device
        ext4
        xfs
        btrfs
        vfat     
    -L "LABEL":设定卷标
    -b：{1024|2048|4096}单位为KB
    -I:{128|256}单位为字节

CentOS 6：
    mkfs.ext4 /dev/device
    tune2fs   -c -1 /dev/device

    注意：
        block大小一般有1K，2K，4K几种，其中引导分区为1K，其他普通分区为4K
        引导分区为默认inode大小为128字节
        非启动分区默认inode大小为256字节

CentOS 7：
     mkfs.xfs /dev/device
     block：4K
     inode：512字节
        

>blkid块设备属性命令
    -u UUID:根据指定的UUID来查询对应的设备
    -L LABEL：根据指定的LABEL来查找对应的设备

>e2label:管理ext系列文件系统的LABEL   
    e2lable device [LABEL]
>tune2fs：重新设定ext系统文件系统可用调整参数的值
    -l：查看指定文件系统超级快属性信息
    -L：修改卷标
    -m：修改预留给管理员的空间百分比
    -O：文即系属性启用或禁用(^)
        tune2fs -O has_journal /dev/sdb1
        tune2fs -O ^has_journal /dev/sdb1
    -o：调整文件系统的默认挂载选项
        tune2fs -o acl /dev/sdb1
        tune2fs -o ^acl /dev/sdb1
    -U：修改UUID号
CentOS 7下使用：xfs_admin xfs_info 
>dumpe2fs:查询超级快详细信息
    -h：查看超级快属性信息 

>mkswap:创建交换分区
    mkswap /dev/device
    -L： "LABEL"
    前提：调整其分区的ID为82

文件系统检测工具：
>fsck：file system check
    fsck.FS_PYTE
    -a：自动修复错误
    -r：交互修复错误
    CentOS 7：xfs_repair /dev/device
    注意：FS_TYPE一定要与分区上已有的文件系统类型相同
如果是移动硬盘在windows和linux通用请使用mkfs.vfat 进行格式化
</pre>      

####VFS虚拟文件系统
* vfs：xfs，ext{2|3|4}，btrfs
* 文件系统管理：
    * 将额外文件系统与根文件系统某现存的目录建立起关联关系，进而使得此目录作为其它文件访问入口的行为称之为挂载
    * 解除此关联关系的过程称为卸载
    * 把设备关联挂载点：Mount Ponit
    * 卸载时：可使用设备，也可以使用关注点
    * 挂载点下来原有文件在挂载完成后会被临时隐藏
<pre>
挂载方法：mount DEVICE MOUNT_POINT
    mount：通过查看/etc/mtab文件显示当前系统已经挂载的所有设备
           查看内核追踪到已经挂载的所有设备：cat /proc/mounts
    mount [-fnrsvw] [-t vfstype] [-o options] device dir
        device：指明要挂载的设备 
            (1)：设备文件：例如/dev/sda3
            (2)：卷标：-L 'LABEL'，例如-L 'MYDATA'
            (3)：UUID，-U 'UUID'，例如-U 'aa5c290d-c5ff-4af8-b243-df888d4a6800'
            (4)：伪文件系统名称：proc，sysfs，devtmpfs，configfs
        dir：挂载点
            事先存在：建议使用空目录
        常用命令选项：
            -t：vfstype：指定要挂载的设备上的文件系统类型
            -r：readonly，只读挂载
            -w：read and write，读写挂载
            -n：不更新/etc/mtab         
            -a：自动挂载所有支持挂载的设备（定义在了/etc/fstab文件中，且挂载选择中有"自动挂载(auto)"功能）
            -L：'LABEL'：以卷标指定挂载设备
            -U：'UUID'：以UUID指定要挂载的设备
            -B，--bind：绑定目录到另外一个目录上
        -o options：(挂载文件系统选项)
            async：异步模式(建议使用)
            sync：同步模式，数据安全性高，性能很差
            atime/noatime：每次访问更新|不更新时间戳，包含目录和文件
            diratime/nodiratime：目录的访问时间戳
            auto/noauto：是否支持自动挂载
            exec/noexec：是否支持将文件系统上应用程序运行为进程
            dev/nodev：是否支持在此文件系统上激活使用设备文件
            suid/nosuid：
            remount：重新挂载
                    mount -o remount,ro /dev/sdb2
            user/nouser：是否允许普用户挂载此设备
            acl：启用此文件上的acl(访问控制列表)功能
            
            注意：上述选项可多个同时使用，彼此使用逗号分隔
                  默认挂载选项：defaults
                               Use default options: rw, suid, dev, exec, auto, nouser, and async
    mount注意：手工使用mount命令挂载，在开机或者重启后会失效，需要在配置文件中进行设置：/etc/fstab
卸载命令：
       umount 
       查询正在访问指定文件系统的进程
       fuser -v MOUNT_POINT
       fuser -kv  MOUNT_POINT 强制卸载
       umount -lf 强制卸载，推荐使用

挂载交换分区：
    启用：swapon [option]... [device]
            -a：激活所有交换分区
            -p：指定优先级
    禁用：swapoff [option]... [device]
内存空间使用状态
    free
        -m：以MB为单位   
        -g：以GB为单位

文件系统空间占用信息的查看工具
     df
        -h：human readble
        -i：inodes instead ofblocks
        -P：以posix兼容的格式输出
        
</pre>

####文件挂载的配置文件:/etc/fstab
<pre>
每行定义一个要挂载的文件系统：

    要挂载的设备或伪文件系统    挂载点     文件系统类型      挂载选项    转储频率    自检次序

        要挂载的设备或伪文件系统：
                设备文件、LABEL(LABEL=LABELID)、UUID(UUID=UUIDID)、伪文件系统名称(proc，sysfs)
        挂载选项：
            defaults
        转储频率：
            0：不做备份
            1：每天转储
            2：每隔一天转储
        自检次序：
            0：不自检
            1：首先自检，一般只有rootfs才用1
            2：表示第一个自检完后，第二个开始
            ...一直到9
</pre>

####:文件系统上的其它概念
<pre>
    Inode：Index Node，索引节点
    地址指针：
        间接指针：
        直接指针：
        三级指针：
    inode bitmap：对应标识每个inode空闲与否的状态信息

链接文件：
    硬链接：
        不能够对目录进行：
        不能垮分区进行：
        指向同一个inode的多个不同路径；创建文件的硬链接即为inode创建新的引用路径，因此会增加其引用计数
    符号链接：
        可以对目录进行：
        可以跨分区：
        指向的是另一个文件的路径；其大小指向的路径字符串的长度，不会增加或减少目标文件inode的引用计数
ln [-sv]  RSC DEST 
    -s：sysbolic link
    -v：verbose
目录：本质就是路径隐射，目录自己是一张表，这个表存放了自己直接管辖的文件名和inode编号的对应关系

文件管理操作对文件的影响：
    文件删除：inode编号的引用计数变为0
    文件复制：复制源文件副本，创建新的文件名，把数据填充到指定文件中
    文件移动：跨分区移动
                复制源文件副本，创建新的文件名，把数据填充到指定文件中，删除源文件
             同分区移动
                增加新的inode标号引用路径，再删除原来对应引用路径即可，


</pre>