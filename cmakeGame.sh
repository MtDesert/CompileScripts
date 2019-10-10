source `dirname $0`/shell.sh

#基于cmake的编译环境
compileEnv=Linux #请自行修改成当前的编译环境
executeEnv=Linux #请自行修改成当前的运行环境

#根据编译环境修改编译参数
if [ $compileEnv == Windows ]; then #Windows下编译
	generatorName="MinGW Makefiles" #推荐使用MinGW编译
	makeCommand=mingw32-make #MinGW用的make
	makeLuaParam=mingw
else #默认环境(类Unix)环境
	generatorName="Unix Makefiles"
	makeCommand=make
	makeLuaParam=linux
fi

cmakeG() #执行cmake过程
{
	cmake -G "$generatorName" $cmakeParameter $1
	exitWhenError
}

makeG() #执行make过程
{
	$makeCommand
	exitWhenError
}

compileFreeglut() #编译freeglut
{
	cd freeglut
	mkdirp build && cd build
	cmake -G "$generatorName" -DCMAKE_BUILD_TYPE=Release -DFREEGLUT_BUILD_DEMOS=OFF -DFREEGLUT_BUILD_SHARED_LIBS=ON -DFREEGLUT_BUILD_STATIC_LIBS=OFF ..
	exitWhenError #cmake有时候会检测到PATH中有sh执行程序而罢工,再次运行本文件即可,如果问题依旧,那要找找其它原因
	makeG
	#编译后复制到游戏目录下
	cd ../..
	cp freeglut/build/bin/libfreeglut.dll $gameName
}

compileLua() #编译lua
{
	cd lua
	$makeCommand $makeLuaParam
	cd ..
	#编译后复制到游戏目录下
	cp lua/src/lua53.dll $gameName #53指的是lua的版本号5.3.x,请根据源码的版本自行修改
	exitWhenError
}

compileCurl(){
	cd curl/lib
	$makeCommand -f Makefile.m32
	#编译后复制到游戏目录下
	cd ../..
	cp curl/lib/libcurl.dll $gameName
}

compile()
{
	name=$1
	para=$2
	mkdirp $name && cd $name
	cmakeG "$para $workingDirectory/$name"
	makeG
	cd ..
}

setOutputDir()
{
	outputDir=$1
	cmakeParameter="-DTARGET_SYSTEM_NAME=$executeEnv -DLIBRARY_OUTPUT_PATH=$outputDir -DEXECUTABLE_OUTPUT_PATH=$outputDir" #cmake命令参数
}

#main
if [ $# == 2 ]; then
	#设置游戏名相关的变量
	gameName=$1 #游戏名
	clientOrServer=$2 #客户端还是服务端
	objDir=objs #中间文件的目录名
	#Windows编译环境下,需要编译特定依赖库
	if [ $compileEnv == Windows ]; then
		compileFreeglut
		compileLua
		compileCurl
	fi
	#创建目录
	mkdirp $objDir
	cd $objDir #切换目录以便执行cmake
	#编译客户端
	if [ $clientOrServer == Client ]; then
		setOutputDir $workingDirectory/$gameName #目标文件输出目录
		#核心部分
		compile libGamesEngines -DGAME_NAME= #通用引擎
		compile libGamesEngines -DGAME_NAME=$gameName #专用引擎
		#客户端部分
		compile libGamesClient -DGAME_NAME= #客户端引擎库
		compile libGamesClient "-DGAME_NAME=$gameName -DCOMPILE_GAME_EXE=OFF" #客户端游戏库
		compile libGamesClient "-DGAME_NAME=$gameName -DCOMPILE_GAME_EXE=ON" #客户端可执行文件
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