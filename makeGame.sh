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
	if [ $DEST_PLATFORM == Windows ]; then
		compile freeglut
	fi
	compile libGamesEngines #通用引擎
	compile lib$gameName/Game #游戏内核
	#编译客户端
	if [ $clientOrServer == Client ]; then
		compile libGamesClient #客户端引擎
		compile lib$gameName/Client #游戏客户端
		export gameName #需要在此时导出给make.sh使用
		compile libGamesClient/executable #客户端可执行文件
		#移动文件到游戏目录
		if [ $DEST_PLATFORM == Windows ]; then
			cp objs/*.dll $gameName
			cp objs/*.exe $gameName
		else
			cp objs/*.so $gameName
			cp objs/GamesGLUT $gameName
		fi
	fi
	#编译服务端
	if [ $clientOrServer == Server ]; then
		setOutputDir $workingDirectory/GameServer #目标文件输出目录
		compile libGamesEngines -DGAME_NAME= #通用引擎
		compile libGamesServer -DGAME_NAME= #服务端引擎库
	fi
	#compile lib$gameName -DTOOLS=ON #工具集
else
	echo "Syntax: `basename $0` gameName clientOrServer"
fi
