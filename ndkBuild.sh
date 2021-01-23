source `dirname $0`/shell.sh

#main
if [ $# == 1 -o $# == 2 ]; then
	#参数
	name=$1 #工程名
	para=$2 #其它参数
	echoInfo 编译工程${name}
	echoInfo 参数${para}
	#创建中间文件的目录
	objDir=objsAndroid #目录名
	mkdirp $objDir
	changeDir $objDir #切换目录以便执行cmake
	#确定默认参数
	if [ -z APP_ABI ]; then
		APP_ABI=all
	fi
	#执行ndk-build
	ndk-build NDK_PROJECT_PATH=../${name} NDK_APPLICATION_MK=../${scriptDirectory}/Application.mk APP_ABI=${APP_ABI} APP_BUILD_SCRIPT=../${name}/Makefile NDK_OUT=. NDK_LIBS_OUT=. DEST_PLATFORM=Android $para
	exitWhenError ndk-build失败
	echoOK ndk-build成功
else
	echo "语法: `basename $0` 工程名 附加参数"
fi