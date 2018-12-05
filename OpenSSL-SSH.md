##OpenSSL
<pre
NIST:
    保密性：
        数据保密性
        隐私性
    完整性：
        数据完整性
        系统完整性
    可用性：
        
安全性攻击：
    被动攻击：窃听
    主动攻击：伪装、重放，消息篡改、拒绝服务


密码算法和协议：
    对称加密
    公钥加密
    单向加密
    认证协议

Linux系统：Openssl，gpg(pgp是个协议)是个软件
</pre>

###加密算法和协议：
<pre>
对称加密：加密和解密使用同一个秘钥
特性：
    1、加密，解密使用同一个秘钥
    2、将原始数据分割成固定大小的块，逐个进行加密
缺陷：
    1. 秘钥太多
    2. 秘钥分发


公钥加密：秘钥是成对出现
    公钥：公开给任何人pubkey
    私钥：自己留存，必须保证其私密性；secret key
    特点：用公钥加密的数据，只能使用与之匹对的私钥解密；反之亦然
          用私钥加密的数据，只能使用与之匹对的公钥解密

    功能：
        身份认证(数字签名)：
        秘钥交换：发送方用对方的公钥加密一个对称秘钥，并发给对方
        数据加密
        算法：RSA身份认证和数据加密，DSA，ELGamal

单向加密：只能加密，不能解密；提出数据指纹
    特性：定长输出，雪崩效应
    算法：
        md5：128bits
        sha1:160bits
        sha1sum
        sha224sum  
        sha256sum  
        sha384sum  
        sha512sum 
    功能：保证数据的完整性
</pre>

###PKI：Public key Ingrastructure
<pre>
签证机构：CA
注册机构：RA
证书电销列表：CRL
证书存取库

证书作用：是对方可靠的取得公钥信息
X.509：定了证书的格式
    版本号
    序列号
    签署算法ID
    发行者的名称
    有效期限
    主体名称(如：域名)
    主体公钥
    发行者的唯一标识
    住体的唯一标识
    扩展
    发行者签名
</pre>

###SSL：Secure Socket Layer
<pre>
SSL--> TLS

SSL(TLS)在应用层和传输层之间，加了半层协议
分层设计：
    1. 最底层：基础算法原语的实现，aes，rsa，md5
    2. 向上一层：各种算法的实现
    3. 再向上一层，组合算法实现的半成品
    4. 用各种组件拼装而成的各种成品密码学协议软件

OpenSSL：开源项目
    三个组件：
        openssl：多用途的命令行工具
        libcrypto：公共加密库
        libssl：库，实现了ssl及tls


对称加密:
    enc命令
        加密：openssl enc -e -des3 -a -salt -in test.sh -out /tmp/test.sh
        解密：openssl enc -d  -des3 -a -salt -in  /tmp/test.sh  -out /root/openssl.sh
             dest3属于openssl ？ 中的Cipher commands任意一种算法即可

单向加密
    dgst命令：
        openssl dgst -md5 /path/to/somefile

生成用户密码：
    openssl passwd -1 -salt xxxxxxxx password  
生成随机数
    openssl rand -base64 NUM
	openssl rand -hex NUM
    NUM：表示字节数；-hex时，每个字符4位，出现的字符数为NUM*2



公钥加密：不作为加密数据，作为秘钥交换使用




随机数生成器：
    熵池：    
        /dev/random：仅从熵池中返回随机数；随机数用尽，阻塞
        /dev/urandom：从熵池返回数据；随机数用尽，会利用软件生成伪随机数；非阻塞



生成私钥：(umask 077;openssl  genrsa  -out rsakey.private 2048) 小括号表示在linux中在子shell中运行命令，和当前shell无关
提取公钥：openssl rsa -in  rsakey.private  -pubout 

ssl handshake
 
</pre>


##OpenSSH
<pre>
本地终端mingetty(本身没有远程登录的功能) -- login（用户输入用户名和密码完成认证工作）

ssh：sucure shell，protocol，22/tcp，安全的远程登录
OpenSSH：ssh协议的开源实现
    

OpenSSH：
    C/S
        C：ssh，scp，sftp
            windows客户端
                xshell，putty，securecrt，sshsecureshellclient
        S：sshd
    客户端组件：
        ssh，配置文件：/etc/ssh/ssh_config
        格式：
             ssh [user@]host [command]
                -p Port：远程服务器监听的端口

             常用选项：
                StrictHostKeyChecking ask|no，第一次连接主机是否要接受远程主机的秘钥
                Port 22：默认使用的端口，注意：此端口需要和服务端配置一样才可以不用加-p参数
                
                基于秘钥的认证：
                    1. 在客户端生成秘钥对
                        ssh-keygen -t rsa  -P ''  -f   ~/.ssh/id_rsa
                    2. 公钥传送至远程服务器对应用户的家目录
                        ssh-copy-id -i id_rsa.pub
                    注意：如果是其它普通用户，使用当前用户创建.ssh文件权限位700
                         创建authorized_keys权限为600，把秘钥粘贴进去即可

    scp命令：
        scp 
            存在两种情形
                PULL：scp user@host：/path/from/somewhere   /path/from/somewhere 
                PUSH：scp /path/from/somewhere   user@host：/path/from/somewhere   
            -r：递归复制
            -p：保持文件属性
            -P：指定监听的端口
            -q：静默模式
    sftp命令：
        sftp user@host
        sftp help
        
    

        服务器端：
            sshd，配置文件：/etc/ssh/sshd_config

        常用参数：
            Port
            ListenAddress
            PermitRootLogin
            MaxAuthTries：最大尝试次数
            PasswordAuthentication：是否使用秘钥登陆
            X11Forwarding：X11为显示图像界面的协议，在本地是否能够打开远程图形界面
            UseDNS no 是否DNS反解析
            PermitEmptyPasswords no
            GSSAPIAuthentication no
        
            限制用户登陆的办法：
                AllowUsers user1 user2
                AllowGroups
    
ssh服务的最佳实践：
    1. 不要使用默认端口
    2. 禁止使用protocol version 1
    3. 限制可登陆用户
    4. 设定空隙会话超时时长
    5. 利用防火墙设置ssh访问策略
    6. 仅监听特定的IP地址
    7. 使用强密码策略
    8. 使用口令认证的时候，使用强密码策略
       tr -dc A-Za-z0-9 < /dev/urandom |head -c 30|xargs
    9. 使用基于秘钥的认证
    10. 直接使用空密码
    11. 限制ssh的访问频率和并发在线数
    12. 做好日志
</pre>