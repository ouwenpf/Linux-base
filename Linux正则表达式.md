##Linux上文本处理的三剑(grep  sed  awk)
####grep:文本过滤(模式：pattern)工具</br>
&emsp;`grep，egrep，fgrep`</br>

* grep：Global search REgular epression and Print out the line.</br>
    * 作用：文本搜索工具，根据用户指定的"模式"对目标文本逐行进行匹配检查：打印匹配到的行
        * 模式：有正则表达式字符及文本字符所编写的过滤条件
        * REGEPX：由一类特殊字符及文本字符所编写的模式，其中有些字符不表达字符字面的含义，而表示控制或通配的功能
            * 分两类
                * 基本的正则表达式：BRE
                * 扩展的正则表达式：ERE


####基本正则表达式元字符
<pre>
字符匹配：
        .:  匹配任意单个字符
        []: 匹配指定范围内的任意单个字符
        [^]:匹配指定范围外的任意单个字符
            [:space:]空白字符  [:punct:]所有标点符号
匹配次数：用在要指定次数的字符后面，用于指定前面的字符要出现的次数
        *： 匹配前面的字符任意次数
        .*：匹配任意长度的任意字符
        ?： 匹配前面字符0次或1次(即可有可无)
        +： 匹配前面字符1或多次
精确匹配次数：
        {m}:匹配前面字符m次
        {m,n}:匹配前面的字符至少m次，至多n次
        {m,}:匹配前面字符至少m次
        {,n}：匹配前面字符至多n次
位置锚定：
        ^:行首锚定；用于模式的最左侧
        $:行尾锚定；用于模式的最右侧
        ^$:空行
        ^[[:space:]]*$:空白行包含^$

        \b或\<:词首锚定，用于字符模式的左侧
        \b或\>:词首锚定，用于字符模式的右侧
        \bPATTERN\b:匹配整个字符
分组：
        ():将一个或者多个字符捆绑在一起，当做一个整体进行处理
        后项引用：引用前面的分组括号中的模式所匹配字符(非模式本身)
        Note:分组括号中的模式匹配到的内容会被正则表达式引擎记录于内部的变量中，这些变量的命令方式为：\1,\2,\3,.....
        \1：从左侧起，第一个左括号以及与之匹配右括号之间的模式所匹配到的字符
            (a+b+(xy)*)  
                \1:(a+b+(xy)*) 
                \2:xy
            理解括号嵌套左右括号之间的模式
或者： 
        a|b|c|...
        ^(a|b)

练习：

    1. 找出/etc/rc.d/init.d/functions文件中某单词后面跟一个小括号的行
        grep -o  '^(_|[a-zA-Z])+\(\)'  /etc/init.d/functions
    2. 使用echo输出一个绝对路径，使用grep取出其基名：basename
        echo '/etc/yum.repos.d/'|grep -o   '[^/]+/?$'|cut -d / -f1

    3. 使用echo输出一个绝对路径，使用grep取出其目录名dirname
        #!/bin/bash
        #
        
        dirname1=`echo "$1"|grep  -c '/'`
        dirname2=`echo "$1"|grep  -o   '^/.*[/]\b'`
        
        
        if [ $dirname1 -eq 0 ];then
                echo '.'
        elif [ -z $dirname2 ];then
                echo '/'
        else
                echo "$1"|grep  -o   '^/.*[/]\b'|sed   -n  's#\/$##p'
        
        fi
        使用sed取其dirname
        echo '/etc/sysconfig/network-scripts/ifcfg-eth0' |sed 's#[^/]\+/\?$##'|sed 's#/$##'
        使用grep取其base那么
        echo   /etc/sysconfig/network-scripts/ifcfg-eth0/|egrep  -o '[^/]+/?$'|awk -F '/' '{print $1}' 

    4. 找出ifconfig命令结果中1-255之间的数值
        ifconfig |grep  -o   '[0-9]*'|sort -n|uniq|awk '$1>=1 && $1<=255{print $1}'
    5. 找出ifconfig命令结果中的IP地址
        ifconfig|egrep  '([0-9]+\.){3}[0-9]+\b'
你会了吗！！！！
</pre>



####grep命令
<pre>
>grep
    --color=auto：对匹配的文本着色显示
    -v：显示不能被pattern匹配到的行
    -i：忽略字符大小写
    -o：仅显示匹配到的字符串
    -q：静默模式，不输出任何信息，shell编程中使用
    
    
    -B：before显示匹配到的行及前N行
    -A：after显示匹配到的行前后N行
    -C：context显示匹配到的行前后各N行

</pre>
####fgrep命令
<pre>
不支持正则表达式，不使用正则表达式的时候使用fgrep效率极大
>fgrep
    -rl：查询只输出包含匹配字符的文件名，递归查询
        grep  -rl 'test'   ./ 列出当前目录那些文件包含test字符
</pre>


####sed：stream deitor，文本编辑工具</br>
<pre>
sed：Stream EDitor，行编辑器
>sed
    -n：不输出模式中的内容至屏幕
    -e：多点编辑
    -f：/path/to/script_file：从指定文件中读取编辑脚本
    -r：使用扩展正则表达式
    
    地址定界：
        1. 不给地址，对全文进行处理
        2. 单地址：
            #：指定的行
            /pattern/：被此次模式所能够匹配到的每一行
        3. 地址范围
            #，#
            #，+#
            /pat1/，/pat2/
            #，/pat1/
        4. ~步进
            1~2
            2~2  sed  -n  '1~2p' /etc/fstab
    删除命令：
        d：删除，命令写在地址定界的后面
        p：显示模式空间中的内容，与-n一起使用
        a \test1\ntext2：在模式匹配到行后进行追加，支持使用\n实现多行追加
        i \test1\ntext2：在模式匹配到行前进行追加，支持使用\n实现多行追加
        c \test1\ntext2：替换行为当行或者多行文本，注意为匹配到的行替换成指定的内容
        w /path/to/somefile：保存模式空间中的内容至指定的文件中与-n一起使用
        r /path/to/somefile：读取指定文件的文件流至模式空间中的行后
        =：为模式空间中的行打印行号
        !：对地址定界取反；例如：sed '/^UUID/!d' test
        s///：支持使用其它分隔符，s@@@，@###
              替换标记：
                    g：行内全局替换
                    p：显示替换成功的行
                    w：path/to/somefile：将替换成功的结果保存至指定文件中

sed高级用法，保持空间，默认为模式空间
    h：把模式空间的内容覆盖至保持空间中
    H：把模式空间中的内容追加至保持空间中
    g：从保持空间中取出数据覆盖至模式空间
    G：从保持空间中取出数据追加至模式空间
    x：把模式空间内容和保持空间的内容互换操作
    n：读取匹配到的行的下一行至模式空间
    N：追加匹配到行的下一行至模式空间
    d：删除模式空间中的行
    D：删除多行模行式空间中的所有
</pre>


####awk：Linux上的实现gawk，文本报告生成器</br>
<pre>
>akw
    基本用法：gawk [option] 'program' file ...
    program：pattern{action statements}
        语句之间用分号分割
        print printf
    选项：
        -F：指明输入时用到字符分隔符
        -v：var=value：自定义变量，变量引用无需使用$符号
            每个-v定义一个变量
    1、print
        print Item，item2，...
        要点：
            1. 逗号分隔开
            2. 输出的各item可以字符串，也可以是数值，
            3. 如果省略item，相当于print $0
     
    2、内建
        内建变量：
            FS：input field seperator输入时的分割符，默认为空白字符
            OFS：output field seperator输入时的分割符，默认为空白字符
            RS：input record seperator，输入时的换行符，默认为空白字符
            ORS：output record seperator，输出的换行符，默认为空白字符
                例如：awk -v RS=":" -v ORS="%%" '{print $0}' /etc/passwd
                     把":"分隔符替换成"%%"
            NF：number of field，字段行数
            NR：number of record，行数
           FNR：各个文件分别统计，行数
           FILENAME：当前文件名
           ARGC：命令行参数的个数
                 awk   -F :  'BEGIN{print ARGC}'  /etc/passwd  /etc/issue
                 显示为3
           ARGV：数组，保存的是命令行所给定的各参数
                 awk   -F :  'BEGIN{print ARGV[0]}'  /etc/passwd  /etc/issue
                 awk   -F :  'BEGIN{print ARGV[1]}'  /etc/passwd  /etc/issue
                 awk   -F :  'BEGIN{print ARGV[2]}'  /etc/passwd  /etc/issue   
                 分别显示：awk  /etc/passwd  /etc/issue

        自定义变量：
            1. -v var=value
               变量名区分大小写
               awk -v test="hello gawk" '{print $0}' /etc/fstab
               
            2. 在program中直接定义
               awk  '{test="hello gawk"; print test}' /etc/fstab 
			3. a=test,b=test1
			   awk 'NF>"'$a'" && NF<"'$b'" {print $1}'
               注意变量后面有分号结束，awk中都要使用中括号 
			awk中使用:'$var'或"'$var'" awk '{print '$var'}'
			sed中使用：sed 's/200/'$var'/g'
    3、printf命令
        格式化输出：
            (1)FORMAT必须给出
            (2)不会自动换行，需要格式给出换行控制符，\n
            (3)FORMAT中需要分别为后面的每个item指定一个格式化符号
        格式符：
            %c：显示ASCII码
            %d：显示十进制整数
            %f：显示浮点数
            %g：以科学计数法或浮点形式显示数值
            %s：显示字符串
            %u：显示无符号整数
            %%：显示%自身 
        修饰符：格式符前面加上修饰符，可以完成特定格式的输出，如在%和f之间加上修饰符
               %1.2f第一个数字控制显示宽度，第二个数字控制小数点后面的精度
               -：左对齐
               +：显示数值的符号，如：+5 -5
               {printf "%s1,%s2",$1,$2}
               其中$1和$2的格式输出取决于 "%s1,%s2" 中的内容，%s1,%s2之间的逗号表示$1和$2直接分割也是逗号，$1,$2直接的逗号在awk中表示空格隔开，为固定写法



    4、Pattern == pattern{action statements}
        1. empty：控模式，匹配每一行      
        2. /regular expression/：仅处理能够被此次的模式匹配到的行
        3. relational expression：关系表达式；结果"真" 有 "假"；结果为"真"才会被处理
           真：结果为非0，非空字符串
        4. line range：行范围
           startline，endline：/par1/,/par2/从第一次匹配pat1内容到匹配pat2内容之间的内容
        5. BEGIN/END模式
           BEGIN{}：仅在开始处理文件中的文本之前执行一次
           END{}：仅在文本处理完成之后执行一次
    5、常用的action
        1. expressions
        2. control statements：fi，while等
        3. compound statements：组合表达式
        4. input statements
        5. output statements

    7、控制语句
        if(condition){statements}
        if(condition){statements}else{statements}
        for(expr1;expr2;expr3){statements}
        break
        continue
        delete arrar[index]
        delete arrar
        exit
        {statements}

        if-else
            语法：if(condition){statements}
            使用场景：对awk取得整行或某个字段做条件判断
            实例：
                awk -F ':' '{if($3>1000){printf "%s %s %d\n", "Comm User",$1,$3}else {printf "%s %s %d\n", "Sysuser",$1,$3}}' /etc/passwd

                awk -F ':'  '{if($NF=="/bin/bash"){print $1,$3}}' /etc/passwd
                df  -h|awk  -F '[ %]+'  '$1~/\/dev\/sd/{if($5<=3){print $1}}'  
        
        for循环
            语法：for(expr1;expr2;expr3){statements}
            awk -F '[ ]+'  '{for(i=1;i<=NF;i++){if(length($i)>=10){print $i;a+=length($i)};word+=length($i)}}END{print a,word}' test  
            awk '{for(i=1;i<=NF;i++){if(length($i)>10){printf $i" ";print "("NR,i")"}}}' /etc/fstab
            找出test文件中字符数大于10个的所在的单词，且统计出大于10的所有单词的字符数
            说明：逗号后面表示每循环一个单词执行后面的语句
            
            特殊用法：
                能够遍历数组中的元素：
                语法 for(var in array){for-boby}
        next
            提前结束对本行的处理而直接进入下一行，控制awk内生的循环
            awk  -F ':' '{if($3%2!=0){next}{ print $1,$3}}'  /etc/passwd
            使用awk完全取代while的特殊用法
            while read line;do
            userid=`echo ${line}|awk -F ':' '{print $3}'`
            if [ $[$userid%2] -eq 0 ];then
                echo ${line}|awk -F ':' '{print $1,$3}'
            fi
            done < /etc/passwd


        array：重点内容
            关联数组：array[index-expression]
            index-expression
                1. 可以使用任意字符串，字符串要使用双引号
                2. 如果某数组元素事先不存在，在引用时，awk会自动创建此元素，并将其值初始化为"空串"
                若要判断数组中是否存在某元素，要使用"index in array"
                若要遍历数组中的每个元素，要使用for循环
                for(var in array){for-body}
                注意：var会遍历array的每个索引
                awk '!a[$1]++'是按照最早出现去重，最前面的行
                awk '{a[$1]=$0}END{for(i in a){print a[i]}}'  access-test.log按照最晚出现去重，最后面的行
                awk '{a[$1]++;b[$1]+=$10}END{for(i in a)print i,a[i],b[i]}' access_2010-12-8.log
                统计/etc/fstab/文件中的每个单词出现的次数
                awk '{for(i=1;i<=NF;i++){a[$i]++}}END{for(i in a)print i,a[i]}'  /etc/fstab
       
        函数：
            内置函数
                数值处理：
                    rand()：返回0和1直接的一个随机数
                字符串处理：
                    length($i)：返回指定字符串的长度
        <<sed和awk>> <<linux命令行与shell脚本编程大全>>

</pre>



