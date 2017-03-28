#!/bin/bash
if [ $# == 2 ]; then
	#set parameter
	projectPath=$1
	targetSys=$2
	
	#execute shell
	if [ -d $projectPath ]; then
		cd $projectPath
		if [ ! -d build-${targetSys} ]; then
			mkdir build-${targetSys}
		fi
		cd build-${targetSys}
		cmake -DTARGET_SYSTEM_NAME=${targetSys} ..
		sudo make
	else
		echo "No such directory $projectPath"
	fi
else
	echo "Syntax: $0 ProjectDirectory(which contain CMakeLists.txt) TargetSystemName(Linux,Android,etc.)"
fi
