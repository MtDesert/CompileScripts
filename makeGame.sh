source `dirname $0`/shell.sh

compile()
{
	echoOK 开始编译工程$1
	$scriptDirectory/make.sh $1
	exitWhenError 工程出错$1
}

#main
if [ $# == 2 ]; then
	#设置游戏名相关的变量
	gameName=$1 #游戏名
	clientOrServer=$2 #客户端还是服务端
	#export makeClean=true
	#编译主模块
	compile lua #lua核心
	compile curl
	compile libGamesEngines #通用引擎
	compile lib$gameName/Game #游戏内核
	#编译客户端
	if [ $clientOrServer == Client ]; then
		if [ $DEST_PLATFORM == Windows ]; then
			compile freeglut
		fi
		compile libGamesClient #客户端引擎
		compile lib$gameName/Client #游戏客户端
		export gameName #需要在此时导出给make.sh使用
		compile libGamesClient/executable #客户端可执行文件
		#编译完成,确定扩展名
		if [ $DEST_PLATFORM == Windows ]; then
			dllSuffix=.dll
			exeSuffix=.exe
		else
			dllSuffix=.so
			exeSuffix=
		fi
		#移动文件到游戏目录
		for filename in lua curl GamesEngines $gameName freeglut GamesClient ${gameName}Client
		do
			cp objs/lib${filename}${dllSuffix} $gameName
		done
		cp objs/GamesGLUT$exeSuffix $gameName
	fi
	#编译服务端
	if [ $clientOrServer == Server ]; then
		compile libGamesServer #服务端引擎
		compile lib$gameName/Server #游戏客户端
	fi
	#编译工具集
	if [ $clientOrServer == Tools ]; then
		compile libGamesTools
		./libGamesTools/make.sh #使用脚本自定义的编译过程
		#compile lib$gameName/Tools
	fi
else
	echo "语法: `basename $0` 游戏名 Client|Server|Tools"
fi
