#这里包含常用的shell函数,以及产生一些基本变量

#函数部分
echoColor() #输出带颜色的文本(背景色号,文本色号,文本)
{
	echo -e "\033[$1;$2m$3\033[0m"
}
echoInfo() #输出调试信息,告知用户当前执行到了哪步
{
	echoColor 40 34 $1
}
echoOK() #输出OK信息,告知用户哪步执行成功了
{
	echoColor 40 32 $1
}
exitWhenError() #只要出错就退出,这样我们可以检查在哪一步出了问题
{
	if [ $? != 0 ];then
		echoColor 40 31 $1
		exit
	fi
}
mkdirp() #创建成功或者目录存在的时候继续往下执行,否则退出并报错(mkdir自带报错功能)
{
	mkdir -p $1
	exitWhenError 目录创建失败:$1
}
changeDir() #切换目录,失败时候报错
{
	cd $1
	exitWhenError 目录切换失败:$1
}

#变量部分
workingDirectory=`pwd` #工作目录,即此命令执行时候的工作目录
scriptDirectory=`dirname $0` #脚本目录,此文件所在的目录
