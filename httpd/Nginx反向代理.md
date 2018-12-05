##nginx负均衡载
<pre>
ngx_http_proxy_module模块：

server {
    listen
    server_name
    location /forum/ {
        proxy_pass http://192.168.80.134；
        注意：代理服务器地址为192.168.80.133
             192.168.80.133/forum  --> http://192.168.80.134
             http://192.168.80.134后面可以跟任何设置好的路径的资源
    }

    location ~* \.(jpg|pgn|gif)$ {
        proxy_pass http://192.168.80.134；
        注意：代理服务器地址为192.168.80.133
             192.168.80.133/images/1.jpg  --> http://192.168.80.134/images/1.jpg
             http://192.168.80.134后面不能跟任何内容，模式配对到的内容原封不动的附加在后面"images/1.jpg"
    }

}





</pre>
