##Nginx：
<pre>
    Nginx：engine X
        Tengine
        Registry
    libevebt：高性能的网络库
        epoll()
    
    Nginx特性：
        模块化设计，较好的扩展性
        可靠性
            master --> worker
        低内存消耗
            10000个keep-alive模式下的connection，仅需要2.5MB的内存
        支持热部署
            不停机而更新配置文件，日志文件滚动，升级程序版本
        支持事件驱动，AIO，mmap
        
    基本功能：
        静态资源的web服务器，能缓存打开的文件描述符
        http、smtp、pop3协议的反向代理服务器
        缓存加速、负载均衡
        支持FastCGI(fpm,LNMP)，uWSGI(python)等
        模块化(非DSO机制)、过滤器zip、SSI及图像的大小调整
        支持SSL

    扩展功能：
        基于名称和IP的虚拟主机
        支持keepalive
        支持平滑升级
        定制访问日志，支持使用日志缓冲区提供日志存储性能
        支持url rewrite
        支持路径别名
        支持基于IP及用户的访问控制
        支持速率限制，支持并发数限制
        
        
        



</pre>

##Nginx基本架构
一个主进程master，生成一个或多个worker进程<br>
事件驱动：epoll(边缘触发)、kqueue(BSD)，/dev/poll<br>
复用器：select，poll，rt，signal<br>
支持sendfile，sendfile64<br>
支持AIO<br>
支持mmap<br>
nginx的工作模式，非阻塞，事件驱动，由一个master进程生成多个worker线程，每个worker响应N个请求worker*n
![](https://i.imgur.com/iUUgvzG.png)
<pre>
模块类型：
    核心模块
        Standard HTTP modules
        Optional HTTP modules
        Mail modules
        Mail modules
        3rd party modules


安装方法：
    源码：编译安装
    制作好的程序包：rpm包
    
    编译安装：
        # useradd -r -M -s /sbin/nologin nginx
        # yum install  pcre pcre-devel -y
        # ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module --with-debug
        # make && make install 

    配置文件：
        main配置段：全局配置段
        event：定义event模型工作特性
        http{}：定义http协议相关的配置
        
        配置指令：要求分号结尾，语法格式
            directive valuel [value2 ...]
        支持使用便利：
            内置变量
                模块会提供内建变量定义
            自定义变量
                set var_naem value
        主配置段的指令：
            用于调试，定位问题
            正常运行必备的配置
            优化性能的配置
            事件相关的配置

</pre>


##运行时必备配置
<pre>
主配置段的指令：
    正常运行的必备配置：
        1、user USERNAME [GROUPNAME]
            指定运行worker进程的用户和组；组如果不写默认和用户一致
            user nginx nginx;
        2、pid /path/to/pid_file
            指定nginx守护进程的pid文件
            编译时候如果不指定默认在/usr/local/nginx/logs目录中
        3、worker_flimit_nofile number；
            指定一个worker进程所能够打开的最大文件的句柄数
   优化性能相关配置；
        1、worker_processes number；
            worker进程的个数，通常应该略少于CPU的物理核心数
        2、worker_cpu_affinity cpumask
            优点：提升缓存的命中率
            context switch：会产生cpu的不必要的消耗
            cpumask：
                worker_cpu_affinity 00000001 00000010 00000100；
        3、timer_resolution
            计时器解析度，降低此值，可减少gettimeofday()系统调用的次数
        4、worker_priority number
            指明worker进程nice值
                -20,19
                100,139
   事件相关配置：
        1、accept_mutex {off|on};
            master调度用户请求至各worker进程时使用的负载均衡；on表示能要多个worker轮流地，序列化去响应新请求
        2、lock_file file
            accept_mutex用到的锁文件路径
        3、use [epoll|rtsing|select|poll];
            指明使用事件模型；建议让nginx自动选择
        4、worker_connetcions number；
            设定单个worker进程所能够处理的最大并发连接数
            worker_connections * work_processes


    用于调试定位问题：需要在编译时使用了--with-debug 选项
        1、daemon {on|off}
            是否以守护进程方式nginx，调试时应该设置为off；
        2、master_process {on|off}
        3、error_log file|stderr | syslog:server=address[,parameter=value]| memory:size 
            error_log 位置 级别；
            若要使用debug级别，需要在编译nginx时使用--with-debug 选项
    
    总结：常需要进行调整的参数
        worker_processes worker_connetcions worker_cpu_affinity worker_priority
    新改动配置生效的方式：
        nginx -s reload


        
</pre>


##Nginx作为web服务器时使用的配置
<pre>
http {}：由ngx_http_core_module模块引入；

配置框架：
    http {
        upstream {
            ...
        }   
        
        server {
            location URL {
                root "/path/to/somedir"
            } #类似于httpd中的<Location>，用于定义URL于本地文件系统的映射关系；
            
            location URL {
                if ... {
                    ...
                }
            }   
            
        } #每个server类似于httpd中的一个<VirtualHost>;

        server {
            ...
        }

    }

    注意：与http相关的指令只能放置于http，server，location，upstream，if上下文中，但有些指令仅应用于这5种上下文某些种

    配置指令：
        1、server {}
           定义一个虚拟主机；
        server {
            listen 8080;
            server_name www.tanyueyun.com;
            root "/var/vhost/web1";
        }
    
        
        2、listen
           指定监听地址和端口
            listen address[:port];
            listen port;
            不指定端口默认为80，只有端口表示监听本机所有地址
        
        3、server_name NAME [...];
            后可跟多个主机(http中可以有多个server，每个server有server_name，所有才有多个的概念，不是sever_name后面跟多个主机名)，名称还可以使用正则表达式(需要使用~开头)或通配符
            (1)先做精确匹配检查；
            (2)左侧通配符匹配检查：*.yueyun.com
            (3)右侧通配符匹配检查：mail.*
            (4)正则表达式通配符匹配检查：~^.*\.yueyun\.com$
            (5)default_server:默认服务器
            (6)以后如果都匹配不到默认找第一个虚拟主机
    
        4、root path；
            设置资源路径隐射；用于指明请求的URL所对应的资源所在的文件路径
        5、	location [ = | ~ | ~* | ^~ ] uri { ... }
            location @name { ... }
            功能：允许根据用户请求的URL来匹配定义的各location；匹配到时，此请求将被相应的location配置块中配置所处理，访问控制等功能
            =：精确匹配
                location = /images/2.jpg {
                     root "/var/vhost";
                 }
                输入：http:192.168.80.131/images/2.jpg 才能匹配，否则无法匹配
                
            ~：正则表达式模式匹配检查，区分字符大小写
            ~*：正则表达式模块匹配检查，不区分字符大小写
            ^~：URI的前半部分匹配，不支持正则表达式
            匹配的优先级：精确匹配(=)、^~、~、~*、/
        6、alias path；
            用于location配置段，定义路径别名
            

                    location /images/ {
                        root "/var/vhost/web1";
                    }
                    http://www.tanyueyun.com/a.jpg  ==> /var/vhost/web1/images/a.jgp
                    
                    location /images/ {
                        alias "/var/www/";
                    }
                    http://www.tanyueyun.com/a.jpg  ==> /var/www/a.jgp
                    注意：root表示指明路径对应的location "/" URL；
                    alias表示路径隐射，即location指令后定义的URL是相对于alias所指明的路径而言
        7、index flie
            默认主页面：
                index index.php  index.html
        
        8、error_page code [...] [=code] URI | @name
            根据http响应状态码来指明特用的错误页面
            404 /404x.html  
            [=code]：以指定响应码进行响应，而不是默认的原来的响应，默认表示以新资源的响应码为其响应码
            error_page 404 =200 /404x.html;
            或者
            
            error_page 404 =200 /404x.html;
            location =  404.html {
                alias /tmp/404.html   别名到别的位置        
            }
        9、基于IP的访问控制
            allow IP/Networke
            deny IP/Network
            注意nginx默认是允许所有访问
        10、基于用户访问控制
            basic，digest
            
            auth_basic "Only for VIP";
            auth_basic_user_file /usr/local/nginx/user/.passwd; 
                账户密码文件建议使用htpasswd来创建
        11、https服务
            生成私钥，生成证书签署请求，并获得证书；
                server {
                    listen       443 ssl;
                    server_name  localhost;
                
                    ssl_certificate      /usr/local/nginx/ssl/nginx.crt;
                    ssl_certificate_key  /usr/local/nginx/ssl/nginx.key;
                
                    ssl_session_cache    shared:SSL:1m;
                    ssl_session_timeout  5m;
                
                    ssl_ciphers  HIGH:!aNULL:!MD5;
                    ssl_prefer_server_ciphers  on;
                
                    location / {
                        root   html;
                        index  index.html index.htm;
                    }
                }
        12、stub_status {on|off}
            仅能在location中定义
            location /status {
                stub_status on;
            }
            结果实例：
            Active connections: 1 #当前所有打开状态的连接数
            server accepts handled requests
             163 163 249 
             (1)已经接收过的连接数
             (2)已经处理过的连接数
             (3)已经处理过的请求数，在"保持连接"模式下，请求数量可能会多于连接数量
            
            Reading: 0 Writing: 1 Waiting: 0 
             Reading：正处于接收请求状态的连接数；
             Writing：请求已经接收完成，正处于处理请求或发送响应的过程中的连接数
             Waiting：保持连接模式，且处理活动状态的连接数
        13、rewrite regex repacement flag
            例如：
                server_name www.tanyueyun.com;
                location / {
                root "/var/vhost/web1";
                rewrite ^/(.*)$ http://www.baidu.com break;
                rewrite ^/images/(.*\.jpg)$ /imgs/$1 break;
                }
            

                上述指令中，rewrite为固定关键字，表示开启一条rewrite匹配规则
                和sed的正则表达式差不多，^表示开始，$表示结束语法的固定格式
                /前面的内容为server_name定义的域名（网站的URI），/将后面接着的字符标记为一个特殊字符或一个原义字符或一个后向引用，（.*）为正则表达式配置的任意字符（括号中为正则表达式的内容），可以用$1,$2…引用出来
                
            flag：
                last：一旦此rewrite规则重写完成后，就不再被后面其它的rewrite规则进行处理；
                     而是由UserAgent重新对重写后 的URL再一次 发送请求，并从开头开始执行类似的过程

                break：一旦此rewrite规则重写完成后，由UserAgent重新发起请求，且不会被当前location内的任何rewrite规则所检查
                redirect：以302响应码(临时重定向)返回新地址
                permanent：以301响应码(永久重定向)返回新地址
    


        14、if
            语法：if (condition) {...}
            应用环境：server，location
            
            conditon：
                1、变量名，0或空都为假
                   变量名：变量值为空串，或者以"0"开始，则为false，其它均为true
                2、以变量为操作数构成的比较表达式
                   可以使用=，！=类似的比较操作进程测试
                3、正则表达式的模式匹配操作
                   ~：区分大小写的模式匹配检查
                   ~*：不区分大小写的模式匹配检查
                   !~和~!*对上面两种情况取反
                4、测试路径为文件可能性：-f，!-f
                5、测试为指定路径为目录的可能性：-d，!-d
                6、测试文件的存在性：-e，!-e；
                7、检查文件是否有执行权限：-x。!-x；
                例如：
                    if ($http_user_agent ~* MSIE) {
                        rewrite ^(.*)$ /msie/$1 break;
                    }
        15、防盗链
            location ~* \.(jpg|gif|jpeg|png)$ {
                valid_referer none blocked www.tanyueyun.com;
                if ($valid_referer) {
                    rewrite ^/(.*)$  http://www.tanyuyun.com/403x.html;
                }
            }
        16、定制访问日志格式
                log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                                  '$status $body_bytes_sent "$http_referer" '
                                  '"$http_user_agent" "$http_x_forwarded_for"';

                access_log  logs/access.log  main;
            

        网络连接相关的配置：
            1、keepalive_timeout #;
                长连接的超时时长，默认为65s
            2、keepalive_requests #;
                在一个长连接上所能够  允许请求的最大资源数    
            3、keepalive_disable [msie6|safari|none];   
                为指定类型的User Agent禁用长连接
            4、tcp_nodelay on|off;
                是否对长连接使用TCP_NODELAY   
            5、client_header_timeout #;
                读取http请求报文的首部超时时长；
            6、client_body_timeout #；
                读取http请求报文body部分的超时时长
            7、send_timeout #;
                发送响应报超时文的超时时长；


</pre>