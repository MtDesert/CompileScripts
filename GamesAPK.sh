#!/bin/bash
source `dirname $0`/shell.sh

#main()
#工程目录必须存在
projectPath=Games/NativeActivity
if [ ! -d $projectPath ]; then
	echo "No project directory $projectPath"
	exit
fi
#进入工程目录,执行ant
cd $projectPath

rm -R bin
rm -R libs
rm -R obj
rm -R res
ndk-build NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk
exitWhenError
android update project --path . --target 2
exitWhenError
ant release
exitWhenError
jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore ~/.android/debug.keystore -signedjar bin/NativeActivity.apk bin/NativeActivity-release-unsigned.apk androiddebugkey
exitWhenError
/usr/bin/adb install -ru bin/NativeActivity.apk
exitWhenError
/usr/bin/adb logcat -c
exitWhenError
/usr/bin/adb logcat|grep games.engines
