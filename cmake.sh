echo "参数数量$#"
if [ $# == 2 ]; then
	#set parameter
	projectPath=$1
	platformName=$2
	
	#execute shell
	if [ ! -d $projectPath ]; then
		return
	fi
	cd $projectPath
	
	if [ ! -d build-${platformName} ]; then
		mkdir build-${platformName}
	fi
	cd build-${platformName}
	cmake -DCMAKE_SYSTEM_NAME=${platformName} ..
	make
else
	echo "Syntax: $0 ProjectDirectory(which contain CMakeLists.txt) platform"
fi
