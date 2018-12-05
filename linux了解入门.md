##Linux哲学思想
1. **一切皆文件**<br>
把几乎所有资源，包括硬件设备都组织为文件格式</br>
2. **由众多单一小程序组成**<br>
一个程序只实现一个功能，而且要做好组合小程序完成复杂任务
3. **尽量避免跟用户交互**<br>
目标：实现脚本编程，以自动化完成某些功能
4. **使用纯文件保存配置信息**<br>
目标：一款使用的文件编辑器既能完成系统配置工作
##Linux的发行版
* slackware
    * suse
        * opensuse
* debian
    * ubuntu
        * mint
* redhat
    * rhel：redhat enterpries linux
        * 每18个月发行一个新版本
    * fedora：每6个月发行一个新版本


##如何获取CentOS的发行版
> <http://mirrirs.aliyun.com><br>
<http://mirrirs.souhu.com><br>
<http://mirrirs.163.com>



##终端
###用户与主机交互，必然用到的设备
1. **物理终端**：直接接入本机的显示器和键盘设备；/dev/console
2. **虚拟终端**：附件在物理终端之上的以软件方式虚拟实现的终端，CentOS 7默认启动6个虚拟终端<br>
				&emsp;&emsp;&emsp;&emsp;&emsp;使用`Ctrl+Alt+F1-F6`进行切换<br>
				&emsp;&emsp;&emsp;&emsp;&emsp;设备文件的路径`/dev/tty1-tty6`
3. **模拟终端**：图形界面下打开的命令行接口，基于ssh协议或telnet协议等远程打开的界面<br>
				&emsp;&emsp;&emsp;&emsp;&emsp;设备文件的路径`/dev/pts[1,oo]`
> 查看当前的终端设备：`tty`

----
###交互式接口：启动终端后，在终端设备附加一个交互式应用程序

####GUI:
<pre>
	X protocol, window manager, desktop
	
	Desktop:
		GNOME:(C,gtk)
		KDE:(C++,qt)
		XFCE:(轻量级桌面)
</pre>
> 服务器系统安装都使用最小化安装，如果需要安装图形界面请使用<br>
> `yum groupinstall "GNOME Desktop" "Graphical Administration Tools"`
> startx

####GLT:
<pre>
	shell程序
		bash(bourn again shell),GPL
		sh(bourn)
		csh
		tcsh
		ksh(korn)
		zsh
</pre>
> 显示当然使用的shell<br>
> \#echo $SHELL<br>
> 显示当前系统使用的所有shell<br>
> cat /ect/shells