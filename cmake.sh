#!/bin/bash
mkdirp()
{
	mkdir -p $1
	if [ $? != 0 ];then
		exit
	fi
}

workingDirectory=`pwd`
if [ $# == 2 ]; then
	projectPath=$1
	platform=$2
	#first, projectPath must exist
	if [ ! -d $projectPath ]; then
		echo "No project directory $projectPath"
		exit
	fi
	#second, maybe we need a directory to put the compiled object of our object(for make our project directory clean)
	objectPath=obj #(change the name as you like)
	mkdirp $objectPath
	#third, make a directory name $projectPath-$platform
	cd $objectPath
	mkdirp $projectPath-$platform
	cd $workingDirectory
	#fourth, check platform and do theirselves' methods
	if [ $platform == Linux -o $platform == Android ]; then #we can use cmake, and then make
		cd $workingDirectory/$objectPath/$projectPath-$platform
		cmake -DTARGET_SYSTEM_NAME=${platform} ../../$projectPath
		sudo make
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
