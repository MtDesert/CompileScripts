source `dirname $0`/shell.sh

compile()
{
	$scriptDirectory/cmake.sh $1 $2 $3
}

#main
if [ $# == 2 ]; then
	#设置游戏名相关的变量
	gameName=$1 #游戏名
	options=$2 #客户端还是服务端
	#输出目录
	export libPath=$gameName
	export exePath=$gameName
	#是否编译工具集(在编译核心模块和游戏模块之后编译)
	if [ $options == Tools ]; then
		COMPILE_TOOLS=ON
	fi
	#编译核心
	compile lua #lua核心
	compile libGamesEngines -DGAME_NAME=$gameName -DCOMPILE_TOOLS=$COMPILE_TOOLS #通用引擎
	#编译客户端
	if [ $options == Client ]; then
		echo jiujiujiu
		#compile libGamesClient #客户端引擎库
		#compile libGamesClient -DGAME_NAME=$gameName #客户端游戏库
		#compile libGamesClient -DGAME_NAME=$gameName -DCOMPILE_GAME_EXE=ON #客户端可执行文件
	fi
	#编译服务端
	if [ $options == Server ]; then
		outputDir=$workingDirectory/GamesServer #目标文件输出目录
		compile libGamesServer #服务端引擎库
		compile libGamesServer -DGAME_NAME=$gameName #服务端游戏库
	fi
else
	echo "Syntax: `basename $0` gameName option"
fi