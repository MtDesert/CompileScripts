#这里包含常用的shell函数,以及产生一些基本变量

#函数部分
exitWhenError() #只要出错就退出,这样我们可以检查在哪一步出了问题
{
	if [ $? != 0 ];then
		exit
	fi
}
mkdirp() #创建成功或者目录存在的时候继续往下执行,否则退出并报错(mkdir自带报错功能)
{
	mkdir -p $1
	exitWhenError
}
exitWhenNoDir() #当目录不存在的时候退出
{
	if [ ! -d $1 ]; then
		echo "No project directory $1"
		exit
	fi
}

#变量部分
workingDirectory=`pwd` #工作目录,即此命令执行时候的工作目录
scriptDirectory=`dirname $0` #脚本目录,此文件所在的目录
