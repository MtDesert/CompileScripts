source `dirname $0`/shell.sh

#基于cmake的编译环境
compileEnv=Linux #请自行修改成当前的编译环境
executeEnv=Linux #请自行修改成当前的运行环境

#根据编译环境修改编译参数
if [ $compileEnv == Windows ]; then #Windows下编译
	generatorName="MinGW Makefiles" #推荐使用MinGW编译
	makeCommand=mingw32-make #MinGW用的make
else #默认环境(类Unix)环境
	generatorName="Unix Makefiles"
	makeCommand=make
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
	objDir=objs/lib$gameName #中间文件的目录名
	outputDir=$workingDirectory/$gameName #目标文件输出目录
	cmakeParameter="-DTARGET_SYSTEM_NAME=$executeEnv -DLIBRARY_OUTPUT_PATH=$outputDir -DEXECUTABLE_OUTPUT_PATH=$outputDir -DGAME_NAME=$gameName" #cmake命令参数,
	#创建目录
	mkdirp $objDir
	cd $objDir #切换目录以便执行cmake
	cmakeG "-DGAME_LIB=1 $workingDirectory/lib$gameName"
	makeG #开始编译
	#编译引擎模块
	mkdirp ../libGamesEngines
	cd ../libGamesEngines
	cmakeG "$workingDirectory/libGamesEngines"
	makeG
else
	echo "Syntax: `basename $0` gameName"
fi
