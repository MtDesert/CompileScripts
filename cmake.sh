#这是一个编译项目用的命令行脚本,主要依赖cmake,make和./CMakeLists.txt来工作
#主要的使用语法为:
#cmake.sh 工程路径 目标平台
#其中,工程路径里面必须包含有工程的CMakeLists.txt,而且强烈建议这个CMakeLists.txt能包含./CMakeLists.txt
#目标平台主要是传给./CMakeLists.txt,具体哪些平台可以使用,以及相关的编译过程,请参阅本文件和./CMakeLists.txt

#!/bin/bash
source `dirname $0`/shell.sh

#main()
if [ $# == 1 -o $# == 2 ]; then
	#first, projectPath must exist
	#首先,工程路径必须存在
	projectPath=$1
	paremeters=$2
	getAbsolutePath $projectPath
	projectName=`basename ${absolutePath}`

	#second, maybe we need a directory to put the compiled object of our source files(for make our project directory clean)
	#其次,我们可能需要一个目录去装我们编译出来的中间文件(为了使我们的源码目录看起来很干净)
	objectPath=objs #(change the name as you like,换成你想起的名字吧)
	mkdirp $objectPath

	#also, maybe we need some different directories to put different platform's libraries file and executable file
	#同样,我们可能也需要不同的目录来放置不同平台下编译出来的库文件和执行文件
	libPath=bin #(change the name as you like,换成你想起的名字吧)
	mkdirp $libPath
	exePath=bin #(change the name as you like,换成你想起的名字吧)
	mkdirp $exePath

	#third, make a directory name $projectPath-$platform in $objectPath
	#接下来,在中间文件的目录中建立一个文件夹
	cd $objectPath
	mkdirp $projectName
	cd $workingDirectory

	#根据系统调整参数
	if [[ $OS =~ Windows ]]; then
		generatorName="MinGW Makefiles" #推荐使用MinGW编译
		makeCommand=mingw32-make #MinGW用的make
	else #默认环境(类Unix)环境
		generatorName="Unix Makefiles"
		makeCommand=make
	fi

	#开始编译
	cd $workingDirectory/$objectPath/$projectName
	cmake -G "$generatorName" -DLIBRARY_OUTPUT_PATH=$workingDirectory/$libPath -DEXECUTABLE_OUTPUT_PATH=$workingDirectory/$exePath $workingDirectory/$projectPath $paremeters
	exitWhenError
	$makeCommand
else
	echo "Syntax: `basename $0` projectDir"
fi
