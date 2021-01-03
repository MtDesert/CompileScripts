#这里包含常用的shell函数,以及产生一些基本变量

#函数部分
exitWhenError() #只要出错就退出,这样我们可以检查在哪一步出了问题
{
	if [ $? != 0 ];then
		echo $1
		exit
	fi
}
mkdirp() #创建成功或者目录存在的时候继续往下执行,否则退出并报错(mkdir自带报错功能)
{
	mkdir -p $1
	exitWhenError 目录创建失败:$1
}
changeDir()
{
	cd $1
	exitWhenError 目录切换失败:$1
}
getAbsolutePath() #获取首参数的绝对路径(用于各种复杂的.和..的路径名称)
{
	currentPath=`pwd`
	changeDir $1
	absolutePath=`pwd`
	changeDir ${currentPath} #记得回到原路径
}

#变量部分
workingDirectory=`pwd` #工作目录,即此命令执行时候的工作目录
scriptDirectory=`dirname $0` #脚本目录,此文件所在的目录
absolutePath= #getAbsolutePath()的返回值
