source `dirname $0`/shell.sh

#基于cmake的编译环境
compileEnv=Windows #请自行修改成当前的编译环境
executeEnv=Windows #请自行修改成当前的运行环境

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

#main
if [ $# == 1 ]; then
	#设置游戏名相关的变量
	gameName=$1 #游戏名
	objDir=objs #中间文件的目录名
	outputDir=$workingDirectory/$gameName #目标文件输出目录
	cmakeParameter="-DTARGET_SYSTEM_NAME=$executeEnv -DLIBRARY_OUTPUT_PATH=$outputDir -DEXECUTABLE_OUTPUT_PATH=$outputDir -DGAME_NAME=$gameName" #cmake命令参数
	#编译freeglut
	cd freeglut
	mkdirp build && cd build
	cmake -G "$generatorName" -DCMAKE_BUILD_TYPE=Release -DFREEGLUT_BUILD_SHARED_LIBS=ON ..
	exitWhenError #cmake有时候会检测到PATH中有sh执行程序而罢工,再次运行本文件即可,如果问题依旧,那要找找其它原因
	makeG
	cd ../..
	cp freeglut/build/bin/libfreeglut.dll $gameName
	#编译lua库
	cd lua
	$makeCommand $makeLuaParam
	cd ..
	cp lua/src/lua53.dll $gameName #53指的是lua的版本号5.3.x,请根据源码的版本自行修改
	exitWhenError
	#创建目录
	mkdirp $objDir
	cd $objDir #切换目录以便执行cmake
	#编译引擎模块
	mkdirp libGamesEngines
	cd libGamesEngines
	cmakeG "-DENGINE_LIB=ON $workingDirectory/libGamesEngines"
	makeG
	cd ..
	#编译游戏模块
	mkdirp lib$gameName
	cd lib$gameName
	cmakeG "-DGAME_LIB=ON $workingDirectory/lib$gameName"
	makeG
	cd ..
	#编译执行程序
	cmakeG "$workingDirectory/libGamesEngines"
	makeG
else
	echo "Syntax: `basename $0` gameName"
fi