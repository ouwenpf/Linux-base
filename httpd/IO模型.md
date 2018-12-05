##http协议基础及IO模型
<pre>
 MPM：Multipath Processing Modules
     prefork：多进程模型，每个进程响应一个请求
         一个主进程：负责生产N个子进程，子进程也称工作进程，每个子进程处理一个用户请求，即便没有用户请求，也会预先生成多个空闲进程，随时等待请求到达，最大不会超过1024个
     worker：多线程模型，多个进程生成，一个进程生成多个线程，每个线程响应一个请求
     event：事件驱动模型，一个线程响应多个请求

I/O类型：
    同步和异步：synchronous，asyncronous
        关注是消息通知机制
        
        同步：调用发出之后不会立即返回，但一旦返回，则返回即是最终结果
        异步：调用发出之后，被调用方立即返回消息，但返回的并非最终结果，被调用者通过状态，通知机制等来通知调用者，或者通过回调函数来处理
    
    阻塞和非阻塞：block，nonblock
        关注是调用者的状态
        
        阻塞：调用结果返回之前，调用者会被挂起，调用者至有在得到返回结果之后才能继续.
        非阻塞：调用者在结果返回之前，不会被挂起，即调用不会阻塞调用者
        

I/O模型：
    blocking IO：阻塞式IO
    nonblock IO：非阻塞式IO
    IO multiplexing：IO复用
        select()，poll()
    signal driven IO：事件驱动式IO
    asyncronous IO：异步IO

第一阶段：数据从磁盘加载到内核内存
第二阶段：数据从内核内存复制到进程内存
 blocking IO和nonblock IO属于比较早期的模型，nonblock IO处理盲等待过程
    两种模型效率并未有多大改善，性能也没有提升

 IO multiplexing：IO复用
    select()，poll()复用性IO的代理，没有阻塞在进程上，只是阻塞在代理上，也是属于阻塞式的
    第一阶段没有阻塞，可以接受其它新的请求，第二阶段仍然阻塞
    性能也没有提升
    prefork和worker属于IO复用

signal driven IO：事件驱动式IO
    第一段非阻塞，第一阶段大大解放
    第二段阻塞
    通知：
        水平触发，多次通知
        边缘触发，只通知一次
    event属于事件驱动式IO
asyncronous IO：异步IO
    第一阶段非阻塞
    第二阶段非阻塞
 </pre>   
![](https://i.imgur.com/H9A92hC.png)   

