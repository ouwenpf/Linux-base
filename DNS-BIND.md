##DNS and BIND
<pre>
DNS：Domain Name Service，协议(C/S，53/udp，53/tcp)应用层协议
BIND：
TCP：面向连接的协议
UDP：user datagram protocol用户数据报协议，无连接协议

本地名称解析配置文件：hosts
    /etc/hosts
    %windows/system32/drivers/etc/hosts

Top Level Domail；tld
    com，edu，ail，gov，net，org，int

三类：组织域，国家域(.cn .hk  .tw)、反向域

DNS查询类型：
    递归查询：
    迭代查询：

名称服务器，域类负责解析本域内的名称主机
    根服务器：13组服务器
每个域都有自己的负责人，这个负责人就是DNS服务器
域是概念模型，DNS是属于物理模型


解析类型：
    Name -- IP 
    IP -- Name 
    注意：正反向解析是两个不同的名称空间，是两颗不同的解析树

DNS服务器的类型：
    主DNS服务器
    辅助DNS服务器
    缓存DNS服务器
    转发器

    主DNS服务器：维护所负责解析的域内解析库服务器
    从DNS服务器：从主DNS服务器或其它从DNS服务器那里"复制"(区域传递)一份解析库
        序列号：解析库的版本号，前提：主服务器解析库内容发生变化，其序列号递增
        刷新时间：从服务器从主服务器请求的同步解析库的时间间隔
        重试时长：从服务器从主服务器请求同步解析库失败时，再次尝试的时间间隔
        过期时长：从服务器始终联系不到主服务器，多久放弃从服务器，停止提供服务

        "通知"机制：
    区域传递：
        全量传送：传送整个解析库
        增量传送：传递解析库标号的那部分内容

    DNS：
        Domain：
            正向：FQDN -- IP    FQDN：Full Qualified Domain Name完全合格域名www.xxxx.com.
            反向：IP -- FQDN
            
            各需要一个解析库来分别负责本地域的正向和反向解析
                正向区域
                反向区域


一次完成的查询请求经过的流程
    Client -- hosts文件 -- DNS Service
        Local cache -- DNS server(recursion) --server cache --iteration(迭代) --->

    
    解析答案：
        肯定答案：
        否定答案：请求的条目不存在等原因导致无法返回结果
        
        权威答案：
        非权威答案：
    
        
    分区容错性
    可用性
    数据一致性



资源记录：Resourec Record RR
    记录类型：A，AAAA，PTR，SOA，NS，CNAME，MX

    SQA：start of authority起始授权记录，一个区域解析库有且只有一个SOA记录，而且必须为解析库的第一条记录
    A：internet Address 作用，FQDN -- IP
    AAAA：FQDN -- IPv6
    PTR：PoinTer IP -- FQDN
    NS：Name Server，专用于标明当前区域的DNS服务器
    CNAME：Canonical Name：别名记录
    MX：Mail eXchanger邮件交换机


    
</per>