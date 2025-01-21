#########################################################################
# File Name: ADD_COLOR.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2016年11月19日 星期六 16时00分38秒
#########################################################################
#!/bin/sh

# 颜色设置
RES='\e[0m'
BLACK_COLOR='\e[30m'       # 黑色字 
RED_COLOR='\e[1;31m'       # 红色字
GREEN_COLOR='\e[1;32m'     # 绿色字
YELLOW_COLOR='\e[1;33m'	   # 黄色字
BLUE_COLOR='\e[1;34m'      # 蓝色字
PURPLE_COLOR='\e[1;35m'    # 紫色字
SKY_BLUE_COLOR='\e[1;36m'  # 天蓝色字
WHITE_COLOR='\e[1;37m'     # 白色字


#echo -e "\e[1;4;5;42;31m字符串内容\e[0m"   1:高亮,4:下划线,5:闪烁,42:背景绿色,31m:字体颜色

ADD_COLOR(){
    case `echo $1|tr "[A-Z]" "[a-z]"` in
        31) 
           shift
            echo -e "$RED_COLOR$* $RES"
            exit
            ;;  
        32)
            shift
            echo -e "$GREEN_COLOR$* $RES"
            exit
            ;; 

        33) 
            shift
            echo -e "$YELLOW_COLOR$* $RES"
            exit
            ;;  
        34)
            shift
            echo -e "$BLUE_COLOR$* $RES"
            exit
            ;; 
        35) 
            shift
            echo -e "$PURPLR_COLOR$* $RES"
            exit
            ;;  
        36)
            shift
            echo -e "$SKY_BLUE_COLOR$* $RES"
            exit
	    ;;
        30)
            shift
            echo -e "$BLACK_COLOR$* $RES"
            exit
            ;;
        37)
            shift
            echo -e "$WHITE_COLOR$* $RES"
            exit
    
    esac                        
                                            
}                                                       
                                                                    
#ADD_COLOR  $*
