source `dirname $0`/shell.sh

if [ $# == 1 ]; then
	#设置游戏名相关的变量
	gameName=$1 #游戏名
	objDir=objs/lib$gameName #中间文件的目录名
	outputDir=$workingDirectory/$gameName #目标文件输出目录
	cmakeParameter="-DTARGET_SYSTEM_NAME=Linux -DLIBRARY_OUTPUT_PATH=$outputDir -DEXECUTABLE_OUTPUT_PATH=$outputDir -DGAME_NAME=$gameName" #cmake命令参数
	#创建目录
	mkdirp $objDir
	exitWhenError
	cd $objDir #切换目录以便执行cmake
	cmake $cmakeParameter -DGAME_LIB=1 $workingDirectory/lib$gameName
	exitWhenError
	make #开始编译
	exitWhenError
	#编译引擎模块
	mkdirp ../libGamesEngines
	exitWhenError
	cd ../libGamesEngines
	cmake $cmakeParameter $workingDirectory/libGamesEngines
	exitWhenError
	make
else
	echo "Syntax: `basename $0` gameName"
fi
