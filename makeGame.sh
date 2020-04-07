source `dirname $0`/shell.sh

compile()
{
	name=$1
	para=$2
	mkdirp $name
	make -f ../$name/Makefile $para
	exitWhenError
}

#main
if [ $# == 2 ]; then
	#设置游戏名相关的变量
	gameName=$1 #游戏名
	clientOrServer=$2 #客户端还是服务端
	objDir=objects #中间文件的目录名
	#创建目录
	mkdirp $objDir
	cd $objDir #切换目录以便执行cmake
	#编译客户端
	if [ $clientOrServer == Client ]; then
		rm ../$gameName/*.so
		rm ../$gameName/*.exe
		rm *.so
		rm *.exe
		#核心部分
		compile lua #lua核心
		compile libGamesEngines #通用引擎
		compile lib$gameName #游戏内核
		compile libGamesClient #客户端引擎
		mkdirp lib${gameName}Client
		compile lib$gameName Client=true #客户端游戏库
		mkdirp libGamesClient/executable
		compile libGamesClient Executable=$gameName #客户端可执行文件
		#移动文件到游戏目录
		cp *.so ../$gameName
		cp *.exe ../$gameName
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