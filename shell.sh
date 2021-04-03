#这里包含常用的shell函数,以及产生一些基本变量

if [[ -z $DEST_PLATFORM && $OS =~ Windows ]]; then #修改目标环境
	DEST_PLATFORM=Windows
fi

#颜色代码
#文字:30黑31红32绿33黄34蓝35紫36天蓝37白
#底色:40黑开始,和文字代码一样逐渐递增

#函数部分
setColor(){ #设置文字颜色(背景色$1,文字色$2)
	echo -e "\033[$1;$2m\c" #echo默认会换行,\c是不换行
}
echoColor(){ #输出带颜色的文本
	echo -e "$scriptName: $*\033[0m"
}
echoInfo(){ #输出调试信息,告知用户当前执行到了哪步
	setColor 40 34
	echoColor $*
}
echoOK(){ #输出OK信息,告知用户哪步执行成功了
	setColor 40 32
	echoColor $*
}
echoWarn(){ #输出警告信息,提醒用户可能潜在的问题
	setColor 40 33
	echoColor $*
}
echoError(){ #输出错误信息
	setColor 40 31
	echoColor $*
}
exitWhenError() #只要出错就退出,这样我们可以检查在哪一步出了问题
{
	errorNumber=$? #执行其它代码后,$?会改变,所以要先复制
	if [ $errorNumber != 0 ];then
		echoError $*
		exit $errorNumber
	fi
}
makeDir(){ #创建成功或者目录存在的时候继续往下执行,否则退出并报错(mkdir自带报错功能)
	mkdir -p $1
	exitWhenError 目录创建失败:$1
}
changeDir(){ #切换目录,失败时候报错
	cd $1
	exitWhenError 目录切换失败:$1
}
#扫描当前目录下有没有Makefile,没有则返回上级目录继续找,直到当前目录为工作目录或根目录
#找到时结果存在makeFilePath
scanMakeFilePath(){
	makeFilePath=$1
	if [ -f $makeFilePath ]; then #如果路径为文件,则换成其所在的路径
		makeFilePath=`dirname $makeFilePath`
	fi
	changeDir $makeFilePath
	makeFilePath= #清空结果
	while [ $workingDirectory != `pwd` ]
	do
		if [ -f Makefile ]; then #找到了,记录到makeFilePath变量中
			makeFilePath=`pwd`
			if [ $makeFilePath == $workingDirectory ]; then
				makeFilePath=.
			else
				makeFilePath=${makeFilePath/"$workingDirectory"/}
				makeFilePath=${makeFilePath/"/"/}
			fi
			break
		else #切换回上级目录继续搜索
			changeDir ..
		fi
	done
}

#变量部分
workingDirectory=`pwd` #工作目录,即此命令执行时候的工作目录
scriptDirectory=`dirname $0` #脚本目录,此文件所在的目录
scriptName=`basename $0` #脚本名,用于提供当前是哪个脚本发出的信息
