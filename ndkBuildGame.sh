source `dirname $0`/shell.sh

compile()
{
	cd lib$1
	ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=../${scriptDirectory}/Application.mk APP_BUILD_SCRIPT=Android.mk NDK_OUT=${workingDirectory}/${objDir} NDK_LIBS_OUT=${workingDirectory}/${objDir}
	cd ..
}

#main
if [ $# == 1 ]; then
	#设置游戏名相关的变量
	gameName=$1 #游戏名
	objDir=objsAndroid #中间文件的目录名
	#创建目录
	mkdirp $objDir
	#执行ndk-build
	compile GamesEngines
else
	echo "Syntax: `basename $0` gameName"
fi