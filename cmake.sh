#!/bin/bash
exitWhileError()
{
	if [ $? != 0 ];then
		exit
	fi
}
mkdirp()
{
	mkdir -p $1
	exitWhileError
}

#main()
workingDirectory=`pwd`
if [ $# == 2 ]; then
	projectPath=$1
	projectName=`basename $projectPath`
	platform=$2
	#first, projectPath must exist
	#首先,工程路径必须存在
	if [ ! -d $projectPath ]; then
		echo "No project directory $projectPath"
		exit
	fi
	#second, maybe we need a directory to put the compiled object of our source files(for make our project directory clean)
	#其次,我们可能需要一个目录去装我们编译出来的中间文件(为了使我们的源码目录看起来很干净)
	objectPath=objs #(change the name as you like,换成你想起的名字吧)
	mkdirp $objectPath
	#also, maybe we need some different directories to put different platform's libraries file and executable file
	#同样,我们可能也需要不同的目录来放置不同平台下编译出来的库文件和执行文件
	libPath=lib-$platform #(change the name as you like,换成你想起的名字吧)
	mkdirp $libPath
	exePath=exe-$platform #(change the name as you like,换成你想起的名字吧)
	mkdirp $exePath

	#third, make a directory name $projectPath-$platform in $objectPath
	#接下来,在中间文件的目录中建立一个文件夹,以"工程路径-平台"的方式命名
	cd $objectPath
	mkdirp $projectName-$platform
	cd $workingDirectory
	#fourth, check platform and do methods of theirselves
	#接下来,检查一下目标平台,并执行特定的编译命令
	if [ $platform == Linux -o $platform == Android ]; then #we can use cmake, and then make
		cd $workingDirectory/$objectPath/$projectName-$platform
		cmake -DTARGET_SYSTEM_NAME=${platform} -DLIBRARY_OUTPUT_PATH=$workingDirectory/$libPath -DEXECUTABLE_OUTPUT_PATH=$workingDirectory/$exePath $workingDirectory/$projectPath
		exitWhileError
		make
	elif [ $platform == Mac ]; then #not sure
		echo "How to build for Mac????"
	elif [ $platform == Windows ]; then #not sure
		echo "How to build for Windows????"
	else
		echo "Unknown platform: $platform"
	fi
else
	echo "Syntax: make.sh projectDir targetPlatform"
fi