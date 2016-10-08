if [ $# == 2 ]; then
	#set parameter
	projectPath=$1
	platformName=$2
	
	#execute shell
	if [ -d $projectPath ]; then
		cd $projectPath
		if [ ! -d build-${platformName} ]; then
			mkdir build-${platformName}
		fi
		cd build-${platformName}
		cmake -DCMAKE_SYSTEM_NAME=${platformName} ..
		sudo make
	else
		echo "No such directory $projectPath"
	fi
else
	echo "Syntax: $0 ProjectDirectory(which contain CMakeLists.txt) PlatformName(Linux,Android,etc.)"
fi
