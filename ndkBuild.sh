#!/bin/bash
source `dirname $0`/shell.sh

#main()
if [ $# == 1 ]; then
	#first, projectPath must exist
	#首先,工程路径必须存在
	projectPath=$1
	getAbsolutePath $projectPath
	projectName=`basename ${absolutePath}`

	ndk-build NDK_LOG=1 NDK_PROJECT_PATH=${projectPath} NDK_APPLICATION_MK=${scriptDirectory}/Application.mk APP_BUILD_SCRIPT=${scriptDirectory}/Android.mk NDK_OUT=${workingDirectory}/objs NDK_LIBS_OUT=${workingDirectory}/lib-Android PROJECT_NAME=${projectName} WORKING_DIRECTORY=${workingDirectory}
else
	echo "Syntax: `basename $0` projectDir"
fi
