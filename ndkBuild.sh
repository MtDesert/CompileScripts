#!/bin/bash
source `dirname $0`/shell.sh

#main()
#编译.so库
cd ${scriptDirectory}
ndk-build NDK_LOG=1 NDK_PROJECT_PATH=. NDK_APPLICATION_MK=${scriptDirectory}/Application.mk APP_BUILD_SCRIPT=${scriptDirectory}/Android.mk NDK_OUT=${workingDirectory}/objs NDK_LIBS_OUT=${workingDirectory}/lib-Android
exitWhenError
cd ..

projectPath=Games/NativeActivity
if [ ! -d $projectPath ]; then
	echo "No project directory $projectPath"
	exit
fi
cd $projectPath
exitWhenError
rm -R libs/*
cp -rv ../../lib-Android/* libs
exitWhenError

#生成相关打包文件
android -v update project --path . --target android-17
exitWhenError
#打包出未签名的APK文件
ant -v release
exitWhenError
#进行签名
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore ~/.android/debug.keystore -signedjar bin/NativeActivity.apk bin/NativeActivity-release-unsigned.apk androiddebugkey
exitWhenError
#安装APK文件到Android设备(请先确保Android设备正常接入)
/usr/bin/adb install -ru bin/NativeActivity.apk
exitWhenError
#清除日志,准备查看调试信息
/usr/bin/adb logcat -c
exitWhenError
#查看特定调试信息
/usr/bin/adb logcat|grep games.engines
