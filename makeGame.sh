source `dirname $0`/shell.sh

compile()
{
	$scriptDirectory/make.sh $1 $2
	exitWhenError
}

#main
if [ $# == 2 ]; then
	#设置游戏名相关的变量
	gameName=$1 #游戏名
	clientOrServer=$2 #客户端还是服务端
	#编译主模块
	compile lua #lua核心
	compile curl
	compile libGamesEngines #通用引擎
	compile lib$gameName #游戏内核
	#编译客户端
	if [ $clientOrServer == Client ]; then
		compile libGamesClient #客户端引擎
		compile lib$gameName Client=true #游戏客户端
		compile libGamesClient Executable=$gameName #客户端可执行文件
		#移动文件到游戏目录
		cp objects/*.so $gameName
		cp objects/GamesGLUT $gameName
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