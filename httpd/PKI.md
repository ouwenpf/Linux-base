##PKI
<pre>
CA
RA
CRL
证书存取库
</pre>

####建立私有CA
<pre>
OpenCA
Openssl
</pre>

####证书申请及签署步骤
1. 生成申请列表
2. RA验证
3. CA签署
4. 获取证书
####创建私有CA
<pre>
openssl配置文件：/etc/pki/tls/openssl.cnf
(1) 创建所需要的文件
	 touch index.txt
	 echo 01 > serial
(2) CA自签证书	
	(umask 077;openssl genrsa -out /etc/pki/CA/private/cakey.pem 2048)生成私钥文件
	openssl req -new -x509 -key /etc/pki/CA/private/cakey.pem  -days 7300 -out  /etc/pki/CA/cacert.pem
			-new：生成新证书签署的请求
			-x509：专用于CA生成自签证书
			-key：生成请求时用到的私钥文件
			-days n：证书的有效期限
			-out  ：证书的保存路径

(3) 发证			
	a、用到证书的主机生成证书请求；
		 (umask 077;openssl genrsa -out /etc/httpd/ssl/httpd.key 2048)
		 openssl req -new  -key /etc/httpd/ssl/httpd.key  -days 365 -out  /etc/httpd/ssl/httpd.csr
	b、把请求文件传给CA
	c、CA签署证书，并将证书发还给请求者
		 openssl ca -in  /tmp/httpd.csr -out /etc/pki/CA/certs/httpd.crt  -day 365 
		 
		 查看证书中的信息：
			opensll  x509 -in  /etc/pki/CA/certs/httpd.crt  -noout  -text|-subject|-serial
			
(4) 吊销证书
	a、获取要吊销的证书的serial
		 opensll  x509 -in  /etc/pki/CA/certs/httpd.crt  -noout  -subject  -serial
	b、CA
		 先根据客户提交的serial于subject信息，对比验证是否与index.txt文件中的信息一致
		 吊销证书：
			openssl ca  -revoke  /etc/pki/CA/newcerts/SERIAL.pem
			
	c、生成吊销证书的编号（第一次吊销一个证书）
		echo 01 > /etc/pki/CA/crlnumber
	
	d、更新证书吊销列表
		 openssl ca  -gencrl  -out  thisca.crl
		 
		 查看crl文件：
			openssl crl -in  /PATH/FROM/CRL_FILE.crl  -noout  -text
</pre>