source `dirname $0`/shell.sh

clear #清屏,如果想看make.sh前的步骤也可以不清屏
mkFile=Makefile
#参数
if [ $# == 0 ]; then #显示帮助
	echo 根据工程路径下的${mkFile}来编译
	echo 语法A: `basename $0` 工程路径
	echo 语法B: `basename $0` 参数表
	echo "语法A只针对1个参数,主要用于常规(make,mingw32-make等)编译命令"
	echo "语法B针对n个参数,主要用于特殊(比如ndk-build需要指定一堆参数)编译命令"
	exit
elif [ $# == 1 ]; then #只有一个参数,那就是工程路径
	echoInfo 工程路径${projectPath:=$1}
fi
#工程路径可能是一大串路径,我们可以逐个检查路径下有没有$mkFile,然后再执行make
scanMakeFilePath $projectPath
if [ $makeFilePath ]; then
	echoWarn ${mkFile}所在路径:${makeFilePath}
else
	exitWhenError ${mkFile}不存在,退出
fi
#变量修正
if [[ $OS =~ Windows ]]; then #Windows环境
	makeCommand=mingw32-make #MinGW用的make
fi
#变量默认值
echoInfo make命令:${makeCommand:=make} #make命令名
echoInfo 目标环境:${DEST_PLATFORM:=Linux} #目标环境
echoInfo 中间目录:${objDir:=objs} #中间文件输出目录
#推测Makefile参数
if [ $# == 1 ]; then #通用参数
	makeParameters="-f ../${makeFilePath}/${mkFile} projectDir=../${makeFilePath} projectPath=${projectPath} DEST_PLATFORM=$DEST_PLATFORM"
fi
if [ $gameName ]; then #特殊参数,指明游戏名
	makeParameters="$makeParameters GAME_NAME=$gameName"
fi
if [ $exeName ]; then #特殊参数,指明执行程序名
	makeParameters="$makeParameters exeName=$exeName"
fi
echoWarn ${makeCommand}参数:$makeParameters

#准备就绪,开始编译,创建缓存目录
changeDir $workingDirectory
makeDir $objDir
changeDir $objDir
makeDir $projectPath #缓存目录中创建工程目录(放中间文件用)
#开始执行make
if [ $makeClean ]; then #检查是否要清除缓冲
	$makeCommand $makeParameters clean
fi
$makeCommand $makeParameters
exitWhenError make失败
echoOK 工程${projectPath}构建完成
