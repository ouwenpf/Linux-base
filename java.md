##Tomcat
<pre>
    编程语言：
        系统级：C，C++，go
        应用级：C#，Java，Python，Perl，Ruby，php
            虚拟机：jvm，pvm
            动态网站：asp .net jsp


动态网站：
    客户端动态：
    服务器动态：
        CGI
    
    webapp sever：
        jsp：tomcat jboss jetty
        php：php-fpm


    Java编程语言：
        1996：JDK(Java Development Kit)，包含一个JVM(Sun Class VM)
            JDK 1.0:JVM ,Applet,AWT
        1997:JDK 1.1
            JAR文档格式，JDBC、JavaBeans
        1998：JDK 1.2
            Sun把Java技术分析为三个方向
                J2SE：Standard Edition
                J2EE：Enterprise Edition
                J2SE：Mobile Edition    
            代表性技术：EJB，Java Plug-in Swing
                JIT编译器：Just In Time即时编译器
        2000：JDK 1.3
            1999：HotSpot虚拟机
        2002：JDK 1.4
        2006，Sun开源了Java技术：遵循GPL规范：并建立OpenJDK组织对代码进行管理
        虚拟机：JRocKit，HostSpot

    编程语言的类别：指令+数据
        面向过程：以指令为中心，围绕指令组织数据
        面向对象：以数据为中心，围绕数据组织指令

    Java体系结构：
        Java编写语言
        Java Class文件格式(字节码，二进制编码)
        Java API：
        Java VM
                
    Java编程语言特性
        面向对象、多线程、结构化错误处理
        垃圾收集、动态链接、动态扩展
    三个技术流派
        J2SE ==> Java 2 SE
        J2EE ==> Java 2 EE
                 Servlet JSP EJB JMX JavaMail
        J2ME ==> Java 2 ME   
    Web Container：
        JDK，Servlet，JSP
        商业实现：
            WebSphere
            WebLogic
            Oc4j
            Glassfish
            JonAS
            JBoss
        开源实现：
            Tomact
            jetty
            resin 
</pre>

####JVM的核心组成部分：
    class Loader
    执行引擎
![](https://i.imgur.com/28riC0U.png)<br>
<pre>
    JVM运行时区域：运行多个线程
        方法区：线程共享，用于存放被虚拟机加载的类信息，常量，静态变量，也叫永久代
               存放类描述符
               Class只需要加载一次
               涉及到扩容的问题
               共享
               用到谁就加载谁
               在所有线程间共享
        堆：java堆是jvm所管理的内存中最大的一部分，也是GC管理的主要区域，主流基于分带收集方法进行，新生代和老年代
               存放对象和属组的地方
               在所有线程间共享
        Java栈：线程私有，存放线程自己的局部变量等信息
               每个线程对应一个栈
               每个进程至少一个线程(主线程)
        PC寄存器，线程独占的内存空间
        本地方法栈：依赖于运行平台

https://stackoverflow.com/


进程：程序运行时就是进程
线程：进程并发执行的代码段
</pre>
![](https://i.imgur.com/xamLuYp.png)<br>


####Tomcat核心组件
<pre>
    catalina：servlet container
    Coyote：http connection
    Jasper：JSP Engine


Tomcat Instance：运行中的tomcat进程(java进程)
    Server：即一个tomcat实例
    
    Engine：Tomcat的核心组件，用于运行jsp和servlet代码，只能运行代码，不能接收服务请求，通常需要和连接器配合

    service：用于将connector关联至engine组件，一个service只能包含一个engine组件和一个或多个conntor

    Connector：连接器，接收并解析用户，将请求映射为Engine中运行的代码，之后，将运行结果构成响应报文

    Host：类似于httpd中的虚拟主机

    context：类似于httpd中的alias
    注意：每个组件都是"类"来实现，有些组件实现还不止一种
        顶级类组件：server
        服务类组件：service
        容器里组件：可以部署webapp组件，engine host contex
        连接类组件：conector
        被嵌套类组件：valve logger realm

        <server>
            <service>
                <connector />
                <connector />
                ....
                <engine>
                    <host>
                        <contex />
                        ...
                    </host>
                    ...
                <engine>
            <service>
        </server>

    Tomcat得运行模式：

        
</pre>

####安装tomcat
<pre>
官方站点：http://tomcat.apaceh.org
下载好jdk和tomcat
解压配置好环境变量

ln -s /usr/java/jdk1.8.0_20 /usr/java/latest 
ln -s /usr/java/latest   /usr/java/default 
export JAVA_HOME=/usr/java/latest
export PATH=$JAVA_HOME/bin:$PATH

export CATLINA_HOME=/usr/local/tomcat
export PATH=$CATLINA_HOME/bin:$PATH


Tomcat的目录结构：
    bin：脚本及启动时用到的类
    lib：类库
    conf：配置文件
    logs：日志文件
    webapps：应用程序默认部署
    work：工作目录
    tmp：临时文件目录

配置文件：
    server.xml：主配置文件
    context.xml：每个webapp都可以有专用的配置文件，这些配置文件通常位于webapp应用程序目录下的web
    INF目录中，用于定义会话管理，JOBC等，conf/context.xml是为各webapp提供默认配置
    web.xml：每个webapp部署之后才能被访问，此文件则用于额为所有的webapp提供默认配置
    tomat-user.xml：用户认证的账号和密码配置文件
    catalina.policy：当使用-security选项启动tomcat实例时会读取此配置文件来实现其安全运行策略
    catalina.properties：java属性定义文件，用于设定类加载器默认路径，以及一些JVM性能相关的调优参数
    logging.properties：日志相关的配置信息



Java WebApp组织结构：
    有特定的组织形式，层次型的目录结构，主要包含了servlet代码文件，JSP页面文件，类文件，部署描述符文件等
        /usr/local/tomcat/webapps/app1/
            /：webapp的根目录
            WEB-NIF/：当前webapp的私有资源目录，通常存放当前webapp自用的web.xml
            META-INF/：当前webapp的私有资源目录，通常存放当前webapp自用的context.xml
            classes/：
            lib/：此webapp的私有类，被打包为jar格式类
            index.jsp：webapp的主页
    webapp归档格式：
        .war：webapp
        .jar：EJB的类
        .rar：资源适配器
        .ear：企业级应用程序

手工添加一个测试应用程序：
    1、创建webapp特拥有的目录结构
        mkdir -pv myapp/{lib,classes,WEB-INF,META-INF}
    2、提供webapp各文件
        myapp/index.jsp

        <%@ page language="java" %>
        <%@ page import="java.util.*" %>
        <html>
            <head>
                <title>JSP Test</title>
            </head>
        
            <body>
                <% out.println("Hello,world."); %>
            </body>
        </html>
   
       

部署(deployment) webapp相关的操作




<role rolename="manager-gui"/>
<user username="tomcat" password="tomcat" roles="manager-gui,admin-gui"/>
</pre>



##JVM调优
<pre>
-Xms    //堆初始值 1/64（1<1G）
-Xmx    //堆最大值 1/4（1<1G）
-Xmn    //年轻代(eden + s0 + s1)，-Xmn150M

--XX:NewSize //设置年轻代大小
--XX:MaxNewSize //设置年轻带最大值
--XX:PermSize //设置永久带值
--XX:MaxPermSize //设置永久带最大值


Old：yang = 2:1
eden：survivor = 3:1




</pre>