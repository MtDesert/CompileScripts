source `dirname $0`/shell.sh

makeShell=$scriptDirectory/make.sh
#参数
if [ $# != 1 ]; then
	echo 语法: `basename $0` 工程路径
	echo 请参考$makeShell细则,如下
	$makeShell
	exit
fi
#修改make.sh的默认参数
export projectPath=$1
export makeCommand=ndk-build
export DEST_PLATFORM=Android
export objDir=objsAndroid
scanMakeFilePath $projectPath
#确定默认ABI类型
if [ -z APP_ABI ]; then
	APP_ABI=all
fi
#开始编译
changeDir $workingDirectory
$makeShell NDK_PROJECT_PATH=../${makeFilePath} NDK_APPLICATION_MK=../${scriptDirectory}/Application.mk APP_ABI=${APP_ABI} APP_BUILD_SCRIPT=../${makeFilePath}/Makefile NDK_OUT=. NDK_LIBS_OUT=.