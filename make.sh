#!/bin/bash
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
	if [ ! -d $objectPath ]; then 
		mkdir $objectPath
		echo fanhuizhi $?
	fi
	#third, make a directory name $projectPath-$platform
	cd $objectPath
	if [ ! -d $projectPath-$platform ]; then 
		mkdir $projectPath-$platform
	fi
	cd $workingDirectory
	
	#fourth, check platform and do theirselves' methods
	if [ $platform == Linux ]; then #we can use cmake, and then make
		cd $projectPath
		projectFullPath=`pwd`
		cd $workingDirectory/$objectPath/$projectPath-$platform
		cmake -DTARGET_SYSTEM_NAME=${platform} $projectFullPath
		sudo make
	elif [ $platform == Android ]; then #we use android-ndk-rxxx/ndk-build
		echo "there are mamy things to do...."
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
