##bash基础特性
###bash配置文件：
* 按生效范围划分：
    * 全局配件
        * /etc/profile
        * /etc/profile.d
        * /etc/bashrc
    * 个人配置
         * ~/.bash_profile
         * ~/.bashrc

* 按功能划分：
    * profile类：为交互登陆的shell提供配置
        * 全局：/etc/profile，/etc/proflie.d/*.sh
        * 个人：/etc/.bash_profile
        * 公用：
            * 用于定义环境变量
            * 运行命令或脚本
    * bashrc类：为非交互式登陆的shell提供配置
        * 全局：/etc/bashrc
        * 个人：~/.bashrc
        * 公用：
            * 定义命令别名
            * 定义本地变量

* shell登陆
    * 交互式登陆
        * 直接通过终端输入账户密码登陆
        * 使用"su - UserName"或"su -l UserName"切换的用户
        * /etc/profile --> /etc/profile.d/*.sh --> ~/.bash_profile --> ~/.bashrc --> /etc/bashrc
    * 非交互式登陆：
        * su UserName
        * 图形界面打开的终端
        * 执行脚本
        * ~/.bashrc/ --> /etc/bashrc --> /etc/profile.d/*.sh
     > 编辑配文件定义新的配置的生效方式<br>
     > 1. 
     > 重新启动shell进程<br>
     > 2. 使用source或.命令进程(不建议使用)<br>



###特性1:
    命令行展开:~,{},{1..100}
    命令别名:alias/unalias 如:alias vi='vim'
###特性2:
    命令历史:history
    命令和路径补全:$PATH
    glob:*,?,[],[^]取反
    快捷键:ctrl+{a,e,l,c,u,k}
    命令hash:hash
###特性3:
* shell程序:提供了编程环境</br>
    * 程序的编程风格</br>
        过程式:以指令为中心,围绕指令组织数据</br>
        对象式:以数据为中心,围绕数据组织指令</br>
        &emsp;&emsp;&emsp;先设计类，由类实例化对象，然后在对象上设计方法</br>
        **bash为面向过程的编程语言,解释执行**
* 过程式编程
    * 顺序执行
    * 循环执行
    * 选择执行
* 编程语言的基本结构:
    * 数据存储:变量、数组
    * 表达式
    * 语句
* shell脚本:文本文件
    * shebang:</br>
        `#!/bin/bash`</br>
        `#!/usr/bin/python`</br>
        `#!/usr/bin/perl`</br>
        magic number:魔数
    * 运行脚本：
        * 给予执行权限,通过具体的文件路径指定文件执行
        * 直接运行解释器，将脚本作为解释器程序的参数运行
    * 变量：命令的内存空间
        * 作用：  
            * 数据存储的格式
            * 参与的运算
            * 表示的数据范围
        * 编程程序语言：
            * 强类型：定义变量时必须指定类型，参与运算必须符合类型要求，调用未声明变量是为错误
            * 弱类型：无需指定类型，默认均为字符型，参与运算会自动进行隐式类型转换，变量无需事先定义可以直接调用
                * bash
                * 把所有要存储的数据统统当做字符进行
                * 不支持浮点数
        * 短路运算
            * 与：</br>
                第一个为0，结果必定为0</br>
                第一个为1，第二个必须要参与运算</br>
            * 或：</br>
                第一个为1，结果必定为1</br>
                第一个0，第二个必须要参与运算</br>

###特性4:
* 变量的三重作用
    * 数据存储格式
    * 存储空间大小
    * 参与运算的种类
* bash中变量的种类
    * 根据变量的生效范围等标准
        * 本地变量：生效范围为当前shell进程，对当前shell之外的其它shell进程，包括当前shell的子shell进程均无效
            * 变量赋值：name='value'</br>
              value：</br>
              &emsp;&emsp;&emsp;1. 可以是直接字符串：name="username"</br>
              &emsp;&emsp;&emsp;2. 变量引用：name="${username}"</br>
              &emsp;&emsp;&emsp;3. 命令引用：name=\`username\`，name=$(username)</br>
            * 变量引用：$(name),$name
                * "":弱引用，其中的变量引用会替换为变量值
                * '':强引用，其中的变量引用不会被替换为变量值，而保持原字符串
            * 显示已定义的所有变量
                * set
                * unset name销毁变量
        * 环境变量：生效范围为当前shell进程及子进程
            * 变量声明、赋值：
                * export name=value 
                * declare -x name=value (相当于export设置环境变量)
            * 变量引用：$(name),$name
            * 显示已定义的所有变量
                * export env printenv set(四个命令均可以查询)
                * unset name
        * 局部变量：生效范围为当前shell进程中某代码片段(通常指函数)
        * 位置变量：$1,$2....来表示，用于让脚本在脚本代码中调用通过命令行传递给它的参数
            * $1,$2,...：对应调用第1，第2等参数
                * shift [n]换挡操作
            * $0:命令本身
            * $*：传递给脚本的所有参数(将所有参数视为单个字符串"$1$2$3......")
            * $@：传递给脚本的所有参数(将每个参数视为"$1" "$2" "$3" "……")
                * 注意$*和$@在使用""双引号的情况下，满足上述扩展中的要求
            * $#：传递给脚本的参数的个数
        * 特殊变量：$?,$0,$*,$@,$#
        * 只读变量
            * readonly name
            * declare -r name

* 变量的命名法则：
    * 不能使用程序中的保留字
    * 只能使用数字、字母及下划线，且不能以数字开头
    * 见名知义，尽量不要使用全部大写，也尽量不要使用_开头


###特性5:
* bash的的I/O重定向及管道
    * 程序：指令+数据
        * 读入数据：input
        * 输出数据：output
    打开的文件都有个fd：file descripor文件描述符
    * 标准输入：keyboard 0
    * 标准输出：monitor 1
    * 标准错误输出：monitor 2
    
    * I/O重定向：改变标准位置
        * 输出重定向：
            * >：覆盖重定向，目标文件中的源文件内容会被清楚
            * >>：追加重定向，新内容会追加至目标文件尾部<br>
            set -C：禁止将内容覆盖输出至已有文件中,强制覆盖 >|即可<br>
            set -C：允许将内容覆盖输出至已有文件中
        * 错误输出重定向：  
            * 2>：覆盖重定向错误输出数据流
            * 2>>：追加重定向错误输出数据流<br>
            
            * 标准输出和错误输出各自定向至不同位置<br>
                * command > /path/to/file.out1 2> /path/to/file.out2
                * command > /path/to/file.out1 2> &1
            * 合并标准输出和错误输出为同一个数据流进行重定向
                * &>
                * &>> 
            

###bash算术运算

* 实现算术运算：
    * let varlue=算术表达式；let没有返回值所有必须引用变量
    * var=$[算术表达式]或echo $[算术表达式]
    * var=$((算术表达式))或echo $((算术表达式))
    * var=$(expr arg1 + arg2);乘法符号需要转义\*
* bash内建的随机数生成器
    * RANDOM(0-65535)
* 增强型赋值：
    * +=, -=, *=, /=, %=
    * 自增，自减
        * let varlue++，((varlue++))脚本中可以直接这样写
        

* 条件测试：
    * 测试命令
        * test expression
        * [ expression ]
        * [[ expression ]]<br>
        Note：expression前后必须有空白字符，命令运行后直接有返回状态，除此之外需要使用测试命令[]或者[[]]进行引用
    * bash的测试类型
        * 数值测试：
            * -gt：是否大于
            * -ge：是否大于等于
            * -eq：是否等于
            * -ne：是否不等于
            * -lt：是否小于
            * -le：是否小于等于
        * 字符串测试：
            * ==/=：是否等于
            * !=：是否不等于
            * =~：左侧字符串是否能够被右侧的pattern所匹配，用于双中括号中"[[  ]]"
                * [[ "test" =~ ^t ]]左侧为字符串，右侧为正则表达式（无需单双引号）
                  
        * 文件测试：
            * 文件存在性测试
                * -e：文件存在性测试，存在为真，否则为假
                * -d：是否存在为目录文件
                * -f：是否存在为普通文件
                * -b：文件存在且为块设备文件
                * -c：文件存在且为字符设备文件
                * -p：文件存在且为管道文件
                * -L：文件存在且为符号链接文件
                * -S：文件存在且为套接字文件
            * 文件权限测试：当前用户
                * -r：是否存在且可读
                * -w：是否存在且可写
                * -x：是否存在且可执行
            * 文件大小测试：
                * -s：文件存在且非空
            * 文件特殊权限测试
                * -g：是否存在且有sgid权限
                * -u：是否存在且有suid权限 
                * -k：是否存在且有sticky权限
            * 文件是否被打开
                * -t：文件描述符是否已经打开且与其某终端相关
            * 其它
                * -N：文件自上一次被读取之后是否被修改过
                * -O：当前有效用户是否为文件属主
                * -G：当前有效用户是否为文件属组
            * 双目测试：
                * file1 -ef file2：file1与file2是否指向同一个设备的相同inode 
                * file1 -nt file2：file1是否新于file2(时间戳)
                * file1 -ot file2：file1是否旧于file2(时间戳)
* 组合测试条件：
    * 逻辑运算
        * 第一种方式
            * command1 && command2
            * command1 || command2
            * ！command
        * 第二种方式
            * expression1 -a expression2
            * expression1 -o expression2
            * ! expression

                [ c > b -a  "\`hostname\`" == "localhost" -o -z "\`hostname\`" ] <br>
                [ "\`hostname\`" == "localhost" ] || [ -z "\`hostname\`" ]<br>
                摩根定律：
                        [ ! -r file -a ! -w file ] == [ !\(-r file -o -w file\) ]
                        
###bash自定义退出状态码
* exit [n]：自定义退出状态码
    * 注意：脚本中一旦遇到exit命令，脚本立即终止，终止退出状态取决于exit命令后面的数字；如果未给定脚本指定退出状态码，整个脚本的退出状态码取决于脚本中执行的最后一条命令的状态码



###if语句
<pre>
bash命令：
    用命令的执行状态结果：
        成功：true
        失败：flase
    成功或失败的意义：取决于用到的命令


if 判断条件；then
    条件为真的分支代码
fi
-------------------------
if 判断条件；then
    条件为真的分支代码
eles
    条件为假的分支代码
fi


单分支：
    if CONDITION；then
        if-true
    fi
双分支：
    if CONDITION；then
        if-ture
    else
        if-false
    fi
多分支：
    if CONDITION1；then
        if-true
    elif CONDITION2；then
        if-true
    elif CONDITION3；then
        if-true
    ....
    fi
    自上往下逐条进行判断，第一次遇到“真”条件时，执行其分支，而后结束，if语可嵌套

注意：if ！判断条件；then 条件取反也可以
        条件为真的分支代码
     fi

#!/bin/bash
#Version：0.0.1
#Author：Tan
#Description:
#Date
if [ $# -eq 0 ];then
    echo "At least one argument"
    exit 1
fi

if id $1 &> /dev/null;then
    echo "$1 is exists."
else
    useradd $1
    [ $? -eq 0 ] && echo '123456'|passwd --stdin $1 &> /dev/null && echo 'useradd is successful' && exit 0 || exit 1
    
fi
</pre>


###for循环语句
<pre>
    循环体：要执行的代码，可能要执行n遍
        进入条件：
        退出条件：
for循环：
    for value_name in 列表
    do
        循环体
    done
    
    执行机制：
        依次将列表中的元素赋值给"变量名"；每次赋值后即执行一次循环体；直到列表中的元素耗尽，循环结束
    
    列表生成方式：
        1.直接给出列表：
        2.整数列表
            a.{start..end}
            b.$(seq [start seep end])
        3.返回列表的命令
            $(command)
            需要注意相对目录和绝对目录路径
        4.globel
            /var/*
            这个无需注意目录和绝对目录路径
        5.变量引用：
            $@，$*


for循环的特殊格式
    for ((控制变量初始化；条件判断表达式；控制变量的修正表达式))双小括号中可以直接使用算术表达式
        循环体
    done
    控制变量初始值：仅在运行代循环代码段时执行一次；
    控制变量的修正表达式：每轮循环结束会先进行控制变量修正值，而这再做条件判断
        
#!/bin/bash
#
declare -i established=0 定义整形变量
declare -i listen=0

for stat in `netstat -tan|egrep '^tcp\>'|awk '{print $NF}'`
do
    if [ "$stat" == "ESTABLISHED" ];then
        let established++
    elif [ "$stat" == "LISTEN" ];then
        let listen++
    fi
done

echo "ESTABLISHED: $established"
echo "LISTEN: $listen"

打印九九乘法表
#!/bin/bash
#
for j in  `seq 1 $1`;do
    for i in `seq 1 $j`;do
        echo -en "$i*$j=$[i*j] \t"
    done
        echo 
done

利用RANDON生成10个随机数字，输出这个10个数字，并显示其中最大者和最小者
#!/bin/sh
#
declare -i max=0
declare -i min=0
declare -i i=1
declare -i rand=0

rand=$RANDOM
max=$rand
min=$rand
echo $rand

while [ $i -le 9 ];do
    rand=$RANDOM
    echo $rand
    if [ $rand -gt $max ];then
        max=$rand
    fi

    if [ $rand -lt $min ];then
        min=$rand
    fi
    let i++

done

echo "max=$max min=$min"





</pre>


###while循环
<pre>
循环执行
    将某代码重复运行多次
    重复运行多少次
        循环次数先已知
        循环次数事先未知
    
    必须有进入条件和退出条件
    
    for，while，until

函数：结构化编程及代码重用

while循环：
    while condition；
    do
        循环体
    done

    condition：循环体控制条件；进入循环之前，先做一次判断，每一次循环之后再次做判断
        条件为"true"，则执行一次循环，直到条件测试状态为"false"终止循环
        因此：condition一般应用换行控制变量，而此变量的值会在循环体不断被修正

    condition可以为表达式，也可以是命令返回状态
until循环和while条件判断相反

until循环：
    until condition； 条件为假进入，条件为真退出
    do
        循环体
    done


while循环的特殊用法(遍历文件的每一行)
    while read line；do
        循环体
    done < /path/from/somefile

    依次读取/path/from/somefile文件中的每一行，且将行赋值给变量line

</pre>


####循环控制语句
<pre>
continue [N]：提前结束第N层的本轮循环，而直接进入下一轮判断
break [N]：提前结束循环

</pre>

####case语句
<pre>
case 变量引用 in
pat1)
    分支1
        ;;
pat2)
    分支2
        ;;
...

*)
    默认分支
esac

case支持glob风格的通配符
    *：任意长度的任何字符
    ?：任意单个字符
    []：指定范围内的任意单个字符
    a|b：a或b


</pre>


####bash函数
<pre>
function：函数
    过程式编程：代码重用
        模块化编程
        结构化编程
    语法一：
        function f_name () {

            ...函数体...
        }

    语法二：
        f_name(){

            ...函数体...
        }

调用：函数只有被调用才会执行
    调用：给定函数名
         函数名出现的地方，会被自动替换为函数代码
    函数的生命周期：被调用时创建，返回值终止
         return命令返回自定义状态结果
         0：成功
         1-255：失败

函数的返回值：
    函数的执行结果返回值
        1. 使用echo或print命令进行输出
        2. 函数体中调用命令执行结果
    函数的退出状态码
        1. 默认取决于函数体中执行的最后一条命令的退出状态码
        2. 自定义退出状态码
           return 

    变量作用域：
        1. 本地变量：当前shell进程，为了执行脚本会启动专用的shell进程；因此，本地变量的作用范围是当前shell脚本程序文件
        2. 局部变量：函数的生命周期；函数结束时变量被自动销毁
           如果函数中有局部变量，其名称同本地函数名，如果没有局部变量，将会修改本地变量的值
           在函数中定义局部变量的方法
                local name=value  
        

    函数递归：
        函数直接或间接调用自身

    #!/bin/bash
    #

    fab(){
        if [ $1 -eq 1 ];then
            echo 1
        elif [ $1 -eq 2 ];then
            echo 1
        else
            echo $[`fab $[$1-1]`+`fab $[$1-2]`]

    
        fi
    }
    
    fab $1


            
        

case语句和function编写启动服务脚本标准范例：

#!/bin/bash
#
prog="server_neme"
lockfile=/var/lock/subsys/$prog

start(){
    if [ -e $lockfile ];then
        echo "prog is aleady runing"
    else
        touch $lockfile
        [ $? -eq 0 ] && echo "starting $prog finished"  
    fi
}


stop(){
    if [ -e $lockfile ];then
        rm -f $lockfile && echo "Stop $prog"

    else
        echo "$proc stopped yet"

    fi

}
status(){
    if [ -e $lockfile ];then
        echo "$proc is runing"
    else
        echo "$proc is stopped"
    fi

}

usage(){
    echo "Usage: $proc {start|stop|restart|status}"

}

case $1 in
start)
        start
        ;;
stop)
        stop
        ;;
restart)
        stop
        start
        ;;
status)
        status
        ;;
*)
        usage
        exit 1
        ;;
esac

</pre>


####数组
<pre>
变量：存储单个元素的内存空间
数组：存储多个元素的连续的内存空间
        数组名
        索引：编号从0开始，属于数值索引
             注意：索引页可以支持使用自定义的格式，而不仅仅是数值格式
             bash的数组支持稀疏格式：  
        引用数组中的元素的：${ARRAY_NAME[INDEX]}

声明数组：
        declare -a ARRAY_NAMW
        declare -A ARRAY_NAME：关联数值
数组元素的赋值：
        1. 一次只赋值一个元素：
           ARRAY_NAME[INDEX]=VALUE
            weekdays[0]="Sunday"
        2. 一次赋值全部元素，括号一定不能省略
           ARRAY_NAME=("VALUE1","VALUE2","VALUE3")
        3. ARRAY_NAME=([0]="VAL1" [2]="VAL2")
        4. read -a ARRAY 
           
引用数组元素：${ARRAY_NAME[INDEX]}
    注意：省略[INDEX]表示引用下标为0的元素
数组的元素个数：${#ARRAY_NAME[*]}或者${#ARRAY_NAME[@]}
向数组中追加元素：ARRAY[${#ARRAY_NAME[*]}]
实例：生成20个随机数，并找出最大值和最小值
#!/bin/bash
#
declare -a rand
declare -i max=0
declare -i min=1

for i in {0..19};do
    rand[$i]=$RANDOM
    echo ${rand[$i]}
done
min=${rand[0]}
for i in {0..19};do
    if [ ${rand[$i]} -gt $max ];then
        max=${rand[$i]}
    fi

    if [ ${rand[$i]} -le $min ];then
        min=${rand[$i]}
    fi

done

echo "Max=$max Min=$min"



定义一个数组，数组中的元素是/var/log目录下所有以.log结尾的文件，要统计其下标为偶数的文件中的行数之和
#!/bin/bash
#
declare -a file
declare -i line=0
file=(`find /var/log/  -type f -name "*.log"`)

for i in `seq 0 $[${#file[*]}-1]`;do
    if [ $[$i%2] -eq 0 ];then
        let line+=`wc -l ${file[$i]}|cut -d ' ' -f1`
    fi

done
echo "$line"

</pre>




####bash字符串处理工具
<pre>
字符串切片：
    ${var:1:3}：表示从第一个字符到第三个字符
    取字符串最右侧几个字符：${var: -lengh}
        注意：冒号后面必须有一空白字符
    
基于模式取字符串：
    ${var#*word}:其中word可以是指定的任意字符；
    功能：自左向右，查找var变量所存储的字符串中，第一次出现的word删除字符串开头至第一次出现word字符之间所有的字符
        file="/var/log/messages" 
        echo ${file#*/}：var/log/messages
    ${var##*word}：同上，不过，删除的是字符串开头至最后一次由word指定的字符之间的所有内容
        file="/var/log/messages" 
        echo ${file##*/}：messages
    ${var%word*}:其中word可以是指定的任意字符；
    功能：自右而左，查找var变量所存储的字符串中，第一次出现的word删除字符串开头至第一次出现word字符之间所有的字符
    ${var%%word*}:同上，不过，删除的是字符串右侧的字符向左至最后一次由word指定的字符之间的所有内容
    
    实例：url=http://www.magedu.com:80
          ${file##*:}
          ${file##:*}

查找替换：
    ${var/pattern/substi}：查找var所表示的字符串中，第一次被pattern所匹配到的字符串，以substi替换之
    ${var//pattern/substi}：查找var所表示的字符串中，所有被pattern所匹配到的字符串，以substi替换之
    
    ${var/#pattern/substi}：查找var所表示的字符串中，行首被pattern所匹配到的字符串，以substi替换之
    ${var/%pattern/substi}：查找var所表示的字符串中，行尾被pattern所匹配到的字符串，以substi替换之    
查找并删除
    ${var/pattern}   
    ${var//pattern}   
    ${var/#pattern}   
    ${var/%pattern}   
字符大小写转换：
    ${var^^}：把var中所有大写转换为小写
    ${var,,}：把var中所有小写转换为大写
变量赋值：
    ${var:-value}：如果var为空或为设置，那么返回value，否则，则返回var的值
    ${var:=value}：如果var为空或为设置，那么返回value，并将value赋值给var，否则，则返回var的值

</pre>