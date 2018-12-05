##http安装配置Centos 7
####新特性
<pre>
httpd-2.4：
	新特性：
		(1) MPM支持运行DSO机制；以模块形式按需加载
		(2) 支持event MPM
		(3) 支持异步读写
		(4) 每请求配置：<If>
		(5) 支持每个模块及每个目录分别使用各自的日志级别
		(6) 增强版的表达式分析器
		(7) 支持毫秒级的keepalive timeout
		(8) 基于FQDN的虚拟主机不需要NameVirtualHost指令
		(9) 支持基于用户自定义变量
		
	新模块：
		(1) mod_proxy_fcgi
		(2) mod_ratelimit（速率限制）
		(3) mod_remoteip（远程ip控制）
	修改了一些配置机制：
		不再支持使用Order，Deny，Allow来做基于IP的访问控制
</pre>



####程序环境
<pre>
    配置文件：
        主配置文件：/etc/httpd/conf/httpd.conf
        模块配置文件：/etc/httpd/conf.modules.d/*.conf
        辅助配置文件：/etc/httpd/conf.d/*.conf
    mpm：以DSO机制提供。配置文件00-mpm.conf

配置：
    (1)切换使用MPM
       LoadModule mpm_event_module modules/mod_mpm_NAME.so
        NAME：prefork worker event
    (2)修改'Main' server的DocumentRoot

    (3)基于IP访问控制法则
        允许所有主机访问：Require all granted
        拒绝所有主机访问：Require all deny
        允许所有主机访问:Require all  granted
        如果需要特定的主机访问或者禁止访问需要使用一下办法
        <RequireAll> 允许的标签
        	Require all granted
        	Require not ip 172.16.0.1
        </RequireAll>
        
        拒绝所有主机访问:Require all denied
        <RequireAny> 拒绝的标签
        	Require all denied
        	Require ip 172.16
        </RequireAny>
        特定ip：
            Require ip IPADDR
            Require not ip IPADDR
        特定主机
            Require host HOSTNAME
            Require not host HOSTNAME
    (4)虚拟主机
       基于ip、prot和FQDS都支持
       基于FQDN的不需要NameVirtualHost指令
    (5)ssl
       启动模块
        LoadModules ssl_module modules/mod_ssl.so
</pre>