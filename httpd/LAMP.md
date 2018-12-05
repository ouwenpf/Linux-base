##LAMP
####1. 简介
a：Apache<br>
m：mariadb，mysql<br>
p:php，perl，python<br>
**LAMMP：memcached**
静态资源：静态内容，客户端从服务器获取的资源的表现形式与原件相同<br>
动态资源：通常是程序文件，需要在服务器执行之后，将执行的结果返回给客户端<br>
CGI：通用网关接口<br>
fastcgi：
 httpd+php
    modules
    cgi
    fastcgi(fpm)
请求流程：Client --> (http) --> httpd--> (cgi) -->	application server	(program file) --> (mysql) --> mariadb

####2. 安装php
<pre>
CentOS 7:
    程序包：httpd，php，php-mysql，mariadb-server
    	注意：php要求httpd使用prefork MPM
    启动服务：
    	systemctl start httpd.service
    	systemctl start mariadb.service
	
CentOS 6：
    程序包：httpd，php，php-mysql，mysql-server
    启动服务：
    	service httpd start
    	service mysql start
    
    测试：
    	php程序执行环境：
    		test.php
    			<?
    				phpinfo();
    			?>
    	测试php程序与mysql通信
    			test2.php
    			<?php
    				$conn = mysql_connect('127.0.0.1','','');
    				if ($conn)
    					echo "Ok";
    				else
    					echo "Failure";
    			
    				mysql_close();
    				phpinfo();
    			?>

phpMyAdmin
		mariadb的webGUI
		yum  -y install php-mbstring
php解释器如何与mariaDB交互：
		解释器无需与Mariadb交互，那些用到数据储存系统的程序才需要与数据存储交互
	
		存储系统：
			文件系统：文件
			SQL：Mariadb，oracle，MSSQL，...
			NoSQL：redis，hbase，mondodb，...
			NewSQl


</pre>
####3.PHP
<pre>
一、PHP简介

php是通用服务器端脚本编程语言，其中要用于web开发以实现动态web页面，它也是最早实现将脚本嵌入HTML
源码文档中的服务器端脚本语言之一，同时，php还是提供了一个命令接口，因此，其也可以在大多数系统上作为
一个独立的shell来使用

Rasmus Lerdorf1994年开发php，它最初是一组被Rasmus Lerdor称为“Personal Home Page  Tool”的perl脚本
这些脚本可以用于现实作者的建立并记录用户对其网站的访问，后来，Rasmus Lerdor使用C语言将这些Perl脚本重写
为CGI程序 ，还为其增加了运行web forms的能力及数据库交互的特性，并将其重名了为："Personal Home Page/Forms
Interpreter"或“PHP/FI”,此时，PHP/FI已经可以用于开发简单的动态web程序了，这即时php 1.0,1995年6月Rasmus
Lerdor把它的PHP发布于comp.infosystems.www.authoring.cgi Usenet讨论组，从此PHP开始走向人们的视野，
1997年其2.0版本发布

1997年，两名以色列程序员zeev Suraski和Andi Gutmans重写了PHP的分析器(parser)成为PHP发展到3.0的基础
而且从此将PHP命名为PHP:Hypertext Preprocessor。此后，这两名程序员开始重写整个PHP核心，并于1999年
发布了Zend Engine 1.0，这也意味着PHP 4.0的诞生，PHP5包含了许多重要特性，如增强的面向对象编程的支持
支持PDO(PHP Date Objects)扩展机制以及一系列对PHP性能的改进

二、PHP Zend Engine
Zend Engine是开源的、PHP脚本语言的解释器，它最早是由以色列理工学院的学生Andi Gutmans和Zeev Suraski
所研发，Zend也正是此二人名字的合称，后来两个联合创立了Zeed  Technologies公司

Zend Engine 1.0于1999年随PHP 4 发布，有C语言开发且经过高度优化，并且能够作为PHP的后端模块使用，Zend Engine 
为PHP提供了内存核资源管理的功能以及其它的一些标准服务，其高性能、可靠性和扩展性在促进PHP成为一种流行
的语言发挥了重要的作用

Zend Engine的出现将PHP代码的处理过程分成了两个阶段：首先是分析PHP代码并将其转换为称作Zend opcode的
二进制格式(类似Java的字节码)，并将其存储于内存中；第二阶段是使用Zend Engine去执行这些转换后的Opcode

三、PHP的Opcode

Opcode是一种PHP脚本编译后的中间语言，就像Java的ByteCode，或者.Net的MSL，PHP执行PHP脚本代码一般
会经过如下四个步骤（确切的来说，应该是PHP的语言的引擎）
1、Scanning—将PHP代码转换为语言片段（Tokens）；词法分析
2、Parsing—将Tokens转换成简单而有意义的表达式；语意分析
3、Compilation—将表达式编译成Opcodes；编译
4、Execution—顺次执行Opcodes，每次一条，从而实现PHP脚本的功能；执行

		扫描 --> 分析 --> 编译 --> 执行

四、php加速器：

基于PHP的特殊扩展机制如opcode缓存扩展也可以将opcode缓存于PHP共享内存中，从而可以让同一段代码后续重复执行
时跳过编译阶段以提高性能，由此也可以看出，这些加速器并非真正提高了opcode的运行速度，而仅是通过分析opcode后
并将他们重新(多进程访问的时候可以达到共享的目的)
yum install  php-xcache -y
常见的加速器有APC，eAccelerator
商业的加速器：zend guard loader,NuSphere PhpExpress
用的比较多的是Xcache
快速而稳定的PHP opcode缓存，经过严格测试且被大量用于生产环境，项目地址为http://xcache.lighttpd.net

http://php.net/releases/		下载相应的版本
</pre>


####LAMP
LAMP(2)
<pre>	
php:
		php解释器
		配置文件：/etc/php.ini，/etc/php.d/*.ini
	
	配置文件(php.ini)在PHP启动时被读取，对于服务器模块版本的PHP，仅在web服务器启动时读取一次。
	对应CGI和CLI版本，每次调用都会读取
	
	ini:
		[Foo]: Secion Header
		directive = value
		; : 注释符：
		
	php.ini核心配置选项：http://www.php.net/manual/zh/ini.core.php
	php.ini配置选项列表：http://www.php.net/manual/zh/ini.list.php



</pre>