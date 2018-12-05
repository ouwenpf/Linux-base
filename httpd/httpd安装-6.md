##http安装配置Centos 6
<pre>
httpd特性：
    高度模块化：core+modules
    MPM：Multipath Processing Modules
        prefork：多进程模型，每个进程响应一个请求
            一个主进程：负责生产N个子进程，子进程也称工作进程，每个子进程处理一个用户请求，即便没有用户请求，也会预先生成多个空闲进程，随时等待请求到达，最大不会超过1024个
        worker：多线程模型，多个进程生成，一个进程生成多个线程，每个线程响应一个请求
        event：事件驱动模型，一个线程响应多个请求
</pre>

##CentOS 6
<pre>
程序环境
    配置文件：
        /etc/httpd/conf/httpd.conf
        /etc/httpd/conf.d/*.conf
    服务脚本：
        /etc/rc.d/init.d/httpd
        配置文件：/etc/sysconfig/httpd
    主程序文件：
        /usr/sbin/httpd
        /usr/sbin/httpd.worker
        /usr/sbin/httpd.event
    日志文件目录：
        /var/log/httpd
            access_log：访问日志
            error_log：错误日志
    站点文档目录：
        /var/www/html
    配置文件的组成：
        Section 1: Global Environment全局配置
        Section 2: 'Main' server configuration主服务器配置
        Section 3: Virtual Hosts虚拟主机配置
        
        配置格式：directive value
            directive：不区分字符大小写
            value：为路径时，取决于文件系统

常用配置：
    1. 修改监听的IP和Port
        Listen [IP:]PORT
            省略ip表示监听本机所有IP，listen可以重复出现多次
            
    2. 持久连接
        Persitent Connection：连接建立，每个资源获取完成后不会断开连接，而是继续等待的其它请求完成
            如何断开：
                数量限制：100
                时间限制：可配置
            副作用：对并发访问量较大的服务器，持久连接功能会使用有些请求得不到响应
            折中方式：使用较短的持久连接
                     httpd-2.4支持毫秒级持久时间
        
       KeepAlive On|Off
       MaxKeepAliveRequests 100
       KeepAliveTimeout 15
       
       测试：
        telnet HOST PORT
        GET /   HTTP/1.1
        Host:HOST or IP
      例如：
            GET / HTTP/1.1
            Host:192.168.80.131
    3. MPM：
        Multipath Process Module，多路处理模块或者多路并发响应的模型
        prefork，work，event
        httpd-2.2不支持同时编译多个模块，所以只能编译时选定一个，rpm安装的包提供三个二级制文件，分别用于实现对不同MPM机制的支持，群热方法
        # ps aux|grephttpd
        默认为/usr/sbin/httpd，其使用prefork
            查看模块列表：
                查看静态编译的模块
                httpd -l
                Compiled in modules:
                  core.c
                  prefork.c
                  http_core.c
                  mod_so.c
            查看静态编译及动态装载的模块     
                 httpd -M
        
        更换使用的httpd程序    
            /etc/sysconfig/httpd
            HTTPD=/usr/sbin/httpd.worker
            重启服务生效

        


        <IfModule prefork.c>
            StartServers       8  服务启动时候服务器进程数
            MinSpareServers    5  最小空闲进程数 
            MaxSpareServers   20  最大空闲进程数
            ServerLimit      256  在服务器的整个生命周期中的最大值
            MaxClients       256  最大并发进程数
            MaxRequestsPerChild  4000 
        </IfModule>


        <IfModule worker.c>
            StartServers         4  服务启动时候服务器进程数
            MaxClients         300  最大并发进程数
            MinSpareThreads     25  最小空闲线程数
            MaxSpareThreads     75  最大空闲线程数
            ThreadsPerChild     25  每个进程数生成的线程数
            MaxRequestsPerChild  0  线程响应请求数量不做限制
        </IfModule>
        Web资源：多个资源
            入口，资源引用
        PV：站点上有多个页面入口，网站上有多少个可以作为入口单独请求的页面，自己事先是知道的
        PV，UV
            PV：Page View
            UV：User View
            300*86400/50=40w+
            每个请求假如是20K*40w+
            或者每个UV是1.5M*PV量

    4. DSO
        配置指令实时模块加载
        例如：LoadModule auth_basic_module modules/mod_auth_basic.so 
        模块路径可以使用相对地址
            相对于serverRoot(/etc/httpd)指向的路径而言
    

    5. 定义'Main' server的文档页面路径
       DocumentRoot
        
       文档路径隐射：
        DocumentRoot指向的路径为URL路径的起始位置；
            DocumentRoot "/var/www/html"
                test/index.html --> http://HOST:PORT/test/index.html
        
    6. 站点访问控制
        可基于两种类型的路径指明对那些资源进行访问控制
            文件系统路径
                <Directory "">  </Directory>    
                <File "">  </File>
                <FileMatch "">  </FileMatch>
            URL路径：
                <Location "">  </Location> 
            访问控制机制
                基于来源地址
                基于账户
    7. Directory中"基于来源地址"实现访问控制
       (1) Option
           Indexes：索引，（此项即又用，又非常不安全，需要特别注意，前面加上"-"表示注释）
           FollowSymLinks：允许跟踪符号链接文件
           SymLinksifOwnerMatch：源文件属主和符号链接文件是同一个属主就允许
           ExecCGI：是否允许执行CGI脚本
           MultiViews：是否允许多视图(根据浏览器的环境有针对性给客户显示特定的信息，如浏览器中文信息，也叫做内容协商机制)缺点：性能差，有风险，一般不用				
           options 	None|All
    8. 基于来源地址的访问控制机制
       Order：检查次序
            Order allow,deny：后面deny表示默认为deny，前面allow表示允许的才能允许被访问（白名单）
            Order deny,allow：后面allow表示默认为allow，前面deny表示拒绝的不被访问（黑名单）
        工作中只需要记住一条即可
            Order allow，deny
            Deny from IP  or HOST
            Allow from all
        来源地址：
        	IP
        	172.16
        	172.16.0.0
        	172.16.0.0/16
        	172.16.0.0./255.255.0.0
            来源主机名或域名
        	Deny from CentOS7
        	Deny from *.magedu.com
    9. 定义默认主页面
        DirectoryIndex index.html index.html.var
    10. 日志设定
        错误日志：
	       ErrorLog logs/error_log
	       LogLevel warn默认日志级别为warn
	           debug, info, notice, warn, error, crit,alert, emerg
        访问日志：
            CustomLog logs/access_log combined 		
    			CustomLog logs/access_log combined
    			LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    			
    				%h	客户端IP的地址
    				%l	远程日志名 -表示为空
    				%u	远程用户（用户登陆两种控制方法，一个基于IP一个基于用户账号）基于认证时输入的用户名就是%u
    					大多数情况下网站都不用认证，因此一般为空“-"
    				%t	收到请求的时间（标准英文格式）
    				%r	请求报文的首行信息（method url version）如“GET / HTTP/1.1 ”
    				%>s	响应状态码
    				%b	响应大小（以字节为单位），不包含响应报文首部
    				%{Referer}i	请求报文中“referer”首部的值；当前资源的访问入口，即从哪个页面中的超链接跳转而来
    				%{User-Agent}i	请求报文中“User-Agent”首部的值；即发出请求用到的应用程序，通常是浏览器
                    http://httpd.apache.org/docs/2.2/mod/mod_log_config.html#formats
    			    其它详细信息请参考：http://httpd.apache.org/docs/2.2/mod/mod_log_config.html#formats
    11. 路径别名
        DocumentRoot  "/www/htdocs"
	       http://www.magedu.com/download/bash-4.4.2-3.e16.x86_64.rpm
		     -->/www/htdocs/download/bash-4.4.2-3.e16.x86_64.rpm
        
        Alias /URL/ "/PATH/TO/SOMEDIR"
            Alias /bbs/ "/forum/htdocs/"  注意需要对位 /bbs/  需要对应 /forum/htdocs/  "/"需要对应
                http://www.magedu.com/bbs/index.html
                --> /form/htdocs/bbs/  
                别名相对于和根目录并无什么关系，只是资源映射到其它目录
                注意路径别名不支持“Indexes”（映射到其它目录非根目录所有不支持）

    12. 设定默认字符集
        AddDefaultCharset UTF-8


    13. 基于用户的访问控制      
        认证咨询：
	    www-Authenticate：响应码为401，拒绝客户端请求，并说明要求客户提供账户和密码
        此认证为http协议认证，不是表单认证(登陆输入用户名和密码，通过程序实现)
        认证：
		Authorization：客户端用户填入账户和密码再次发送请求报文：认证通过，则服务器发送响应的资源
		
		认证类型：
				basic：明文
				digest：消息摘要
        安全域：需要用户认证后方能访问的路径：
		应该通过名称对其进程标识，并用于告知用户认证的原因
		
		用户的账户和米存储于何处 
			虚拟账户：仅用于访问某服务时用到的认证标识
			
			存储：
				文件文件
				SQL数据库
				ldap
				nis
        实例如下：
        Alias /bbs/ "/tmp/"
        <Directory "/tmp">
            Options None
            AllowOverride None
            AuthType Basic
            AuthName "Administrator private"
            AuthUserFile "/etc/httpd/conf.d/.htpasswd"
            Require valid-user
        </Directory>
    
           允许账号文件中的所有用户登陆访问：
    	   Require valid-user所有用户
    	   Require user tan允许指定用户

        提供账户和密码的储存(文本文件)
	    使用htpasswd命令进行管理
		htpasswd  [options] passwdfile username
				-c：自动创建passwordfile，因此，仅应该在添加第一个用户时使用
				-m：md5加密用户密码
				-s：sha1加密用户密码
				-D：删除指定用户
				htpasswd -c -m /etc/httpd/conf.d/.htpasswd tan
				htpasswd  -m /etc/httpd/conf.d/.htpasswd  liao
                
        要提供：用户账户文件和组文件
	   组文件：每一行定义一个组
	   GRP_NAME:user1 user2
	
        实例：
        <Directory "/www/htdocs">
        	Options None
        	AllowOverride None
        	AuthType Basic
        	AuthName "Administrator private"
        	AuthUserFile "/etc/httpd/conf.d/.htpasswd"
        	AuthGroupFile "/etc/httpd/conf.d/.htgroup"
        	Require group webadmin
        </Directory>

 


13. 虚拟主机
    有三种实现方案：
        基于ip：
            为每个虚拟主机准备至少一个IP地址
        基于port
            为每个虚拟主机准备至少一个专用port，内网常用
        基于hostname：
            为每个虚拟主机准备至少一个专用hostname，常用     
        可混合使用上述三种方式中的任意方式
        注意：一般虚拟主机莫与中心主机混用，所以，要使用虚拟主机，先禁用中心主机


        基于虚拟主机的(v2.2版本需要开启NameVirtualHost *:80参数；v2.4版本中无需要)
        vim httpd-vhosts.conf
        <VirtualHost *:80>
            DocumentRoot "/var/vhost/web1"
            ServerName www.tanyueyun.com
            ServerAlias tanyueyun.com
            ErrorLog "logs/web-error_log"
            CustomLog "logs/web-access_log" combined
        </VirtualHost> 


14. 内置的status页面
        <Location /server-status>
            SetHandler server-status
            Order deny,allow
            #Allow from 192.168.80
            #Deny from all
            AuthType Basic
            AuthName "Administrator private"
            AuthUserFile "/etc/httpd/conf.d/.htpasswd"
            AuthGroupFile "/etc/httpd/conf.d/.htgroup"
            Require group webadmin
        </Location>

</pre>

15. 使用mod_deflate模块压缩页面优化传输速度
<pre>
使用场景：
	(1) 节约带宽，额外消耗CPU；同时，可能有些较老浏览器不支持
	(2) 压缩适于压缩的资源，例如文本文件
	
	#####################deflate###########################
	SetOutputFilter DEFLATE 
	
	# mod_deflate configuration
	
	#Restrict compression to these MIME types
	AddOutputFilterByType DEFLATE test/plain
	AddOutputFilterByType DEFLATE test/html
	AddOutputFilterByType DEFLATE application/xhtml+xml
	AddOutputFilterByType DEFLATE text/xml
	AddOutputFilterByType DEFLATE application/xml
	AddOutputFilterByType DEFLATE application/x-javascript
	AddOutputFilterByType DEFLATE application/javascript
	AddOutputFilterByType DEFLATE test/css
	
	# Level of compression (Highest 9 - Lowest 1)
	DeflateCompressionLevel 9
	
	# Netscape 4.x has some problems.
	BrowserMatch ^Mozilla/4 gzip-only-text/html
	
	# Netscape 4.06-4.08 have some more problems
	BrowserMatch ^Mozilla/4\.0[678] no-gzip
	
	# MSIE masquerades as Netscape, but it is fine
	BrowserMatch \bMSI[E] !no-gzip !gzip-only-text/html
	#####################deflate###########################

</pre>

####curl命令
<pre>	
curl命令
	curl命令是基于URL语法在命令行方式下工作的文件传输工具，它支持FTP，FTPS，HTTP，HTTPS，GOPHRE，DICT
    FILE及LDAP等协议，curl支持HTTPS认证，并支持HTTP的POST、PUT等方法，FTP上传
	kerberos认证，HTTP上传，代理服务器，cookies，用户名/密码认证，下载文件断电续传，上传文件断电续传
	http代理服务器管道(proxy tunneling)，甚至它还支持IPv6
	socks5代理服务器，通过http代理服务器上传文件到FTP服务器等等，功能十分强大
	
	curl [options] [URL...]
	
	curl常用选项：
		-A/--user-agent <string> 设置用户代理发送给服务器  
             curl -A "IE10"  http://192.168.80.131 
		-e/--referer <URL>来源网址
             curl -e  "https://www.google.com.hk/"  http://192.168.80.131
		-H/--header <line>自定义头信息传递给服务器
		-I/--head 只显示相应报文的头部信息--cacert  <file> CA证书（SSl）
		--compressed 要求返回是压缩的格式-basic 使用http基本认证
		--tcp-nodelay 使用tcp_NODELAY选项
		--limitrate <rate> 设置传输速度
		-u/--user <user[:password]>设置服务器的用户和密码
		-0/--http1.0使用HTTP 1.0(默认使用1.1)
		
		另外一个工具：elinks
				elinks [options] [URL...]
						--dump：不进入交互式模式，而直接将URL的内容输出至标准输出
</pre>


####HTTPS
<pre>
https				
	http over ssl = https 443/tcp
		ssl：v3
		tls：v1
		https://
			
	SSl回话的简化过程
		(1) 客户端发送可供选择的加密方式，并向服务器请求证书
		(2) 服务器端发送证书以及选定的加密方式给客户端
		(3) 客户端获得证书并进行证书验证
			 如果信任给其发证书的CA：
					(a) 验证证书来源的内容合法性，用CA的公钥解密证书上数字签名
					(b) 验证证书的内容的合法性，完整性验证
					(c) 检查证书的有效期限
					(d) 检查证书是否吊销
					(e) 证书中拥有者的名字，与访问的目标主机要一致
		(4) 客户端生成临时会话秘钥（对称加密），并使用服务器端的公钥加密此数据发送给服务器，完成秘钥交换
		(5) 服务端用此秘钥加密用户请求的资源，响应给客户端
		注意：SSL会话是基于IP地址创建；所以单个IP的主机上，仅可以使用一个https虚拟主机

配置httpd支持https：
(1) 为服务器申请数字证书
	 测试：通过私建CA发证书
			(a) 创建私有CA
			(b) 在服务器创建证书签署请求
			(c) CA签证
    CA服务器：
    cd /etc/pki/CA
    touch index.txt
    echo 01 > serial
    (umask 077;openssl genrsa -out /etc/pki/CA/private/cakey.pem 2048)
    openssl req  -new -x509 -key  private/cakey.pem  -out cacert.pem -days 7300

    CA客户端：
    (umask 077;openssl genrsa -out /etc/httpd/ssl/httpd.key 2048)
    openssl req  -new -key  /etc/httpd/ssl/httpd.key  -out /etc/httpd/ssl/httpd.csr
    签署证书 
    openssl  ca -in /tmp/httpd.csr  -out /etc/pki/CA/certs/www.yueyun.com.crt -days 365
    
(2) 配置httpd支持使用ssl，及使用证书
	yum -y install mod_ssl
	
	配置文件：/etc/httpd/conf.d/ssl.conf
			DocumentRoot
			ServerName
			SSLCertificateFile /etc/httpd/ssl/www.yueyun.com.crt
			SSLCertificateKeyFile /etc/httpd/ssl/httpd.key

    把cacert.crt(cacert.pem改名)导入受信任的根证书颁发机构
(3) 测试基于https访问相应的主机：
	openssl s_client [-connetc host:prot] [-cert filename] [-CApath directory] [-Cafile filename]
    openssl s_client -connect 192.168.80.131:443  -CAfile  /etc/pki/CA/cacert.pem 

</pre>

####httpd自带的工具程序
<pre>
htpasswd：basic认证基于文件实现时，用到的账号密码文件生成工具
apachectl：httpd自带的服务器控制脚本，支持start，stop
apxs：有httpd-devel包提供，扩展httpd使用第三方模块的工具
routatelogs：日志滚动工具
		access.log -->
		access.log，access.1.log
		access.log，access.1.log，access.2.log	
suexec：
		访问某些有特殊权限配置的资源时，临时切换至指定用户运行

</pre>

####http压力测试工具
<pre>		
ab：Apache benchmark
tcpcopy


ab [options] URL
	-n：总的请求数
	-c：模拟的并发数
	-k：以持久连接模式测试
	
ulimit -n：调整档期用户所同时打开的文件数				

ab -c 100  -n 10000 172.16.0.7/index.php
    Server Software:        Apache/2.2.15 服务器版本号
    Server Hostname:        172.16.0.7	主机名称
    Server Port:            80		端口
    
    Document Path:          /index.php	URL路径
    Document Length:        56310 bytes  页面资源大小
    
    Concurrency Level:      100	 并发级别
    Time taken for tests:   1.879 seconds   测试时间
    Complete requests:      10000 完成请求数
    Failed requests:        0	请求错误
    Write errors:           0		写错误数
    Total transferred:      56505000 bytes  总共传输的字节
    HTML transferred:       56310000 bytes	HTML传输字节
    Requests per second:    532.17 [#/sec] (mean) 每秒完成的请求的数量
    Time per request:       187.911 [ms] (mean) 每100并发个请求完成所需要的平均时间
    Time per request:       1.879 [ms] (mean, across all concurrent requests) 每个请求完成所需要的平均时间
    Transfer rate:          29365.29 [Kbytes/sec] received 输出速率
    
    Connection Times (ms)
    			min  mean[+/-sd] median   max
    Connect:        0    1   1.7      0       8    			建立连接
    Processing:    12  178  31.3    183     360		处理请求
    Waiting:        2  173  30.0    180     262		发送响应时间
    Total:         16  179  29.8    184     360			一次完整的http连接
    
    Percentage of the requests served within a certain time (ms)
    50%    184
    66%    187
    75%    189
    80%    190
    90%    195
    95%    200
    98%    206
    99%    209
    100%    360 (longest request)


</pre>

####CentOS 6下编译安装httpd2.4，不建议使用
<pre>
httpd依赖apr，apr-util，[apr-icon]httpd运行时环境，相当于httpd虚拟机
CentOS 6中arp为1.3，安装httpd2.4需要apr1.4+才支持

yum install openssl-devel  pcre-devel  zlib-devel expat-devel -y
./configure  --prefix=/usr/local/apr/
make && make install 

./configure --prefix=/usr/local/apr-util  --with-apr=/usr/local/apr
make && make install 

./configure \
--prefix=/usr/local/apache24 \
--enable-so \
--enable-ssl \
--enable-cgi \
--enable-rewrite \
--enable-pcre \
--enable-deflate \
--enable-expires \
--enable-headers \
--enable-modules=most \
--enable-mpms-shared=all \
--with-apr=/usr/local/apr \
--with-apr-util=/usr/local/apr-util \
--with-mpm=worker
make && make install 

启动服务：
    apachectl
</pre>