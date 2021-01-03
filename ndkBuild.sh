source `dirname $0`/shell.sh

#main
if [ $# == 1 -o $# == 2 ]; then
	#参数
	name=$1 #工程名
	para=$2 #其它参数
	#创建中间文件的目录
	objDir=objsAndroid #目录名
	mkdirp $objDir
	changeDir $objDir #切换目录以便执行cmake
	#执行ndk-build
	ndk-build NDK_PROJECT_PATH=../${name} NDK_APPLICATION_MK=../${scriptDirectory}/Application.mk APP_BUILD_SCRIPT=../${name}/Makefile NDK_OUT=${workingDirectory}/${objDir} NDK_LIBS_OUT=${workingDirectory}/${objDir} DEST_PLATFORM=Android $para
else
	echo "语法: `basename $0` 工程名 附加参数"
fi
