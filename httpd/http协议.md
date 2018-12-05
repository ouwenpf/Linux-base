##http协议和http的配置
<pre>
URL:Unifrom resource locator
    URL方案：scheme
    服务器地址：ip：port
    资源路径
    http：//www.magedu.com/bbs/index.html
    https://
    基本语法：
        <scheme>://<user>:<password>@<host>:<port>/<path>;<params>?<query>#<frag>
            params：参数
    		  http://www.magadu.com/bbs/hello;gender=f
            query：
    		  http://www.magadu.com/bbs/item.php?username=tom&title=abc
            frag：
    		  https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/6.9_Release_Notes/index.html#known_issues_installation_and_booting
    相对URL：(同站点内文档)
    相对URL：(跨站点内引用)          
</pre>

####http协议
<pre>
http协议：
    http/0.9, http/1.0, http/1.1, http/2.0
    http协议：stateless
	   服务器无法持续追踪访问者来源
		  cookie，session
          Session是在服务端保存的一个数据结构，用来跟踪用户的状态，这个数据可以保存在集群、数据库、文件中；
          Cookie是客户端保存用户信息的一种机制，用来记录用户的一些信息，也是实现Session的一种方式。
          https://www.zhihu.com/question/19786827

http事务：
    请求：request
    响应：response
    
    报文语法格式：
        request报文
            <method><request-URL><version>   
            <headers> 


            <entity-boby>
        
        resonse报文
            <version><status><reason-phrase>   
            <headers> 


            <entity-boby>
            

    method：请求方法，标明客户端希望服务器对资源执行的动作 GET、HEAD、POST			
    version：HTTP/<major>.<minor>		
    status:三位数字：如200,301,302,404,502标记请求过程中发生的情况		
    reaseon-phrase：状态码所标记的状态简要描述  
    headers：每个请求或响应报文可包含任意首部；每个首部都有首部名称，后面跟一个冒号，而后跟上一个
    		可选空格，接着是一个值	
    entity-boby：请求时附加的数据或响应时附加的数据，请求报文可能为空
		      



展开详细说明：
    method：（客户端告诉服务端你要做什么）
            GET：从服务器获取一个资源
            HEAD：只从服务器后期文档的响应首部
            POST：向服务器发送要处理的数据
            PUT：将请求的主体部分存储在服务器上
            DELETE：请求删除服务器上通过URL指定的文档
            TRACE：追踪请求到达服务器中间经过的代理服务器
            OPTIONS：请求服务器返回对指定资源支持使用请求方法

            协议查看或分析的工具：
	        tcpdump，tshark，wireshark

    status：（服务端告诉客户端你的请求发生了什么）
            1xx：100-101，信息提示
            2xx：200-206，成功类响应
            3xx：300-305，重定向类的
            4xx：400-415，客户端错误信息   
            5xx：500-505，服务端错误信息
            
            常用状态码：
            200：成功，请求的所有数据通过响应报文的entity-body部分发送，OK

            301：请求的URL指向的资源已经被删除，但是在响应的报文中通过首部Location指明了资源所在的新位置，              Moved Permanently
            302：与301相似，但是在响应报文中通过location指明资源所在临时新位置；Found
            304：客户端发出了条件请求，但是服务器上的资源未曾发生改变，则通过此响应状态码通知客户端：NOT Modified
            
            401：需要输入账号和认证方可访问资源：Unauthorized
            403：请求被禁止：Forbidden
            404：服务器无法找到客户端请求的资源：Not Found
            
            500：服务器内部错误：Internal Server Error
            502：代理服务器从后端服务器收到一条伪响应:Bad Geteway


首部分类：Name Value
        通用首部
        请求首部
        响应首部
        实体首部
        扩展首部


        通用首部：
            Date：报文创建的时间
            Connection：连接状态，如keep-alive，close
            Via：显示报文经过的中间节点
            Cahce-Control：控制缓存
        请求首部：
            Accept：通过服务器自己可接受的媒体类型
            Accept-Charset
            Accept-Encoding:接受编码格式，如gzip
            Accept-Language：接受的语言
            
            Client-IP
            Host：请求服务器名车端口号
            Referer：包含当前正在请求的资源的上一级资源
            User-Agent：客户端代理
            
            条件式请求首部：
                Expect：
                If-Modified-Since：自从指定的时间之后，请求的资源是否发生
                If-Unmodified-Since：
                If-None-Match：本地缓存中存储的文档的ETag标签是否与服务器文档的Etag不匹配
                If-Match：
            安全请求首部：
                Authorization：向服务器发送认证信息，如账户和密码
                Cookie：客户端想服务器发送cookie
                Cookie2：
            代理请求首部：
                Proxy-Authorization：向代理服务器认证
        
        
        响应首部：
            信息性：
                Age：响应持续时长
                Server：服务器程序软件名称和版本

            协商首部：某资源有多种表示方法时使用
                Accept-Ranges：服务器可接受请求范例类型
                Vary：服务器查看的其它首部列表
        
            安全响应首部：
                Set-Cookie：向客户端设置cookie
                Set-Cookie：
                WWW-Authenticate：来自服务器的对客户端的质询认证
        
        实体首部：
            Allow：列出对此实体可以使用的请求方法
            Location：告诉客户端真正实体位于何处
            
            Content-Rncoding：
            Content-Language：
            Content-Length：主体的长度
            Content-Type：主体的对象类型

            缓存相关：
                ETag：实体的扩展标签
                Expires：实体的过期时间
                Last-Modified：最后一次修改的时间
                   
            
</pre>