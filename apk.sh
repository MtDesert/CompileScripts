if [ $# == 1 ]; then
	#set parameter
	apkPath=$1
	
	#execute shell
	if [ ! -d $apkPath ]; then
		return
	fi
	cd $apkPath
	
	ant release
	jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore ~/.android/debug.keystore -signedjar ./bin/APK.apk ./bin/APK-release-unsigned.apk androiddebugkey
else
	echo "Syntax: $0 ProjectDirectory(which contain CMakeLists.txt) PlatformName(Linux,Android,etc.)"
fi
