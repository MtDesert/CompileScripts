source `dirname $0`/shell.sh

if [ $# == 1 ]; then
	#编译游戏模块
	gameName=$1 #游戏名
	objDir=objs/lib$gameName #中间文件的目录名
	outputDir=$workingDirectory/$gameName #目标文件输出目录
	mkdirp $objDir #创建目录
	exitWhenError
	cd $objDir #切换目录以便执行cmake
	cmake -DTARGET_SYSTEM_NAME=Linux -DLIBRARY_OUTPUT_PATH=$outputDir -DEXECUTABLE_OUTPUT_PATH=$outputDir $workingDirectory/lib$gameName
	exitWhenError
	make
	exitWhenError
	#编译C++11基础库
	#编译引擎模块
	mkdirp ../libGamesEngines
	exitWhenError
	cd ../libGamesEngines
	exitWhenError
	cmake -DTARGET_SYSTEM_NAME=Linux -DLIBRARY_OUTPUT_PATH=$outputDir -DEXECUTABLE_OUTPUT_PATH=$outputDir -DGAME_NAME=$gameName $workingDirectory/libGamesEngines
	exitWhenError
	make
else
	echo "Syntax: `basename $0` gameName"
fi
