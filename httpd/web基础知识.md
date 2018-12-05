##Web基础知识

####Web Service
<pre>
传输层：提供进程地址
    Port number：
        tcp：传输控制协议，面向连接的协议，通信前需要建立虚拟进程(三次握手)，结束后拆除链路(四次断开)
            0-65535
        
        upd：用户数据报协议，无连接的协议
            0-65535

    IANA(A娜)：
        0-1023：总所周知，永久的分配给固定应用的使用，特权端口，只有管理员才能使用22/tcp(ssh)，80/tcp(http)，443/tcp(https)
        1024-41951：为注册端口，但是要求并不严格，分配给某应用使用，3306/tcp(msyql)
        41952+：客户端程序随机使用的端口，动态端口，或私有端口；其范围的定义：/proc/sys/ip_local_range
Socket：IPC(共享内存，信号，Socket)的一种实现，允许位于不同主机(甚至同一个主机)上不同进程之间进行通信，数据交换SocketAPI
    任何运行在linux主机上用户空间的进程，需要跨主机或者网络，可以基于套接字编程的方式，通过调用套接字，向内核中的TCP和UPD协议站注册端口来实现不同主机上或者同一个主机上进程间通讯的，此原理务必需要掌握

    SOCK_STREAM：tcp套接字
    SOCK_DGRAM：udp套接字
    SOCK_RAW：裸套接字


TCP协议的特性：
    建立连接：三次握手
    将数据打包成段：校验和(CRC-32)
    确认、重传以及超时，
    排序，逻辑序号
    流量控制：滑动窗口
    拥塞控制：慢启动和拥塞避免算法(试探性的发送数据包)，防止压垮网络

Socket Domain根据其使用地址的不同
    AF_INET：address family IPV4
    AF_INET6：address family IPV6
    AF_UNIX：同一个主机上不同进程通信使用
    
    没类套接字至少提供了两种socket：流，数据报
        流：可靠的传递，面向连接，无边界
        数据报：不可靠第传播，有边界

套接字相关的系统调用
    socket()：创建套接字
    bind()：绑定
    listen()：监听
    accept()：接受请求
    connect()：请求连接建立
    write()：发送
    read()：接受
        send()，recv()，sendto()，recvfrom()

</pre>

####http
<pre>
http：hyper text transfer protocol
html：编程语言，超文本标记语言
引入MIME，才有了视频和动态的资源
工作机制：
    http请求：.jpg .gif .html .txt  .js  .css  .mp3  .avi
    http响应：
web资源：web resoure
    
媒体类型：
    媒体类型(MIME)：major/minor
        text/html   
        text/plain
        text/jpeg 
        text/gif

URI：Uniform Resoure Identifier
    URL：Uniform Resorce Locator，统一资源定位符，用于描述某服务器某特定资源的位置
    URN：Uniform Resorce Naming统一资源命名符

http协议的版本：
    HTTP/0.9:原型版本，功能简陋
    HTTP/1.0：第一个广泛使用的版本，支持NIME
    HTTP/1.0：增强了缓存功能

      
一次完整的http请求过程
    1. 建立或处理连接：接受请求或拒绝请求
    2. 接受请求：
       接受来自网络的请求报文对某资源的一次请求的过程：
       并发访问响应模型（web I/O）
            单线程的I/O结构：启动一个进程处理用户请求，而且每一次只处理一个；多个请求被串行响应
            多线程的I/O结构：并行启动多个进程，每个线程响应一个请求
            复用I/O结构：一个进程响应N个请求
                多线程模型：一个进程生成N个线程，每个线程
                事件驱动：event-drive
            复用的多进程I/O结构，启动多个(m)进程，每个进程响应n个请求

            C10K
    3. 处理请求：对请求报文进行解析，并获取请求资源及请求方法等相关信息
       
       元数据：请求报文首部
            <method> <URL> <version>
            HOST：www.magedu.com请求的主机名称
            Connection：
               

    4. 访问资源：获取请求报文中的请求资源
       web服务器，即存放了web资源的服务器，负责向请求者提供对方请求的静态资源或者运行后生成的资源，这些资源放置于本地文件系统某路径下，此路径的通常为DocRoot
       /var/www/html
            image/1.jpg
       http://www.magedu.com/images/1.jpg
        
       web服务器资源路径映射方式：
        1. docroot
        2. alias
        3. 虚拟机主机docroot
        4. 家用户目录docroot

    5. 构建响应报文
       MIME类型：
            显示分类
            魔法分类
            协商分类
        URL重定向：
            web服务器构建的响应并非客户端请求的资源，而且资源另外一个访问路径

    6. 发送响应报文
       


    7. 记录日志


</pre>


####http服务器程序
<pre>
httpd(apache)
nginx
lighttpd

应用程序服务器：
    IIS
    tomcat，tetty，jboss，resin，
    webshpere，weblogic，oc4j
    
</pre>


