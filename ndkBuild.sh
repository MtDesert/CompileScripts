#!/bin/bash
source shell.sh

#main()
if [ $# == 1 ]; then
	#first, projectPath must exist
	#首先,工程路径必须存在
	projectPath=$1
	exitWhenNoDir ${projectPath}
	projectName=`basename ${projectPath}`

	cd ${projectPath}
	ndk-build NDK_LOG=1 NDK_PROJECT_PATH=. NDK_APPLICATION_MK=${scriptDirectory}/Application.mk APP_BUILD_SCRIPT=${scriptDirectory}/Android.mk LOCAL_MODULE=${projectName} NDK_OUT=${workingDirectory}/objs NDK_LIBS_OUT=${workingDirectory}/lib-Android
else
	echo "Syntax: `basename $0` projectDir"
fi
