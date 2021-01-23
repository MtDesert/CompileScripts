source `dirname $0`/shell.sh

srcDir=objsAndroid/local
destDir=NativeActivity/libs

cpuType=armeabi-v7a
#复制so文件
rm -R $destDir/*
for cpuType in `ls $srcDir`
do
	echo $cpuType
	mkdirp $destDir/$cpuType
	cp $srcDir/$cpuType/*.so $destDir/$cpuType
	exitWhenError 复制出错
done

#生成相关打包文件
changeDir NativeActivity
android -v update project --path . --target android-29
exitWhenError android更新工程出错
#打包出未签名的APK文件
ant -v release
exitWhenError ant打包出错

#keytool生成签名文件(签名文件一般为~/.android/xxxx.keystore,只需生成一次)
#-genkey 生成文件(无参)
#-alias 别名
#-keyalg 加密算法
#-validity 有效期
#-keystore 文件名
#keytool -genkey -alias MyAlias -keyalg RSA -validity 2000000 -keystore xxxx.keystore
#exitWhenError keytool生成签名文件出错

#keytool查看签名文件
#keytool -list -v -keystore xxxx.keystore

#进行签名(一般要指定-keystore选项,该选项后面跟着.keystore文件,最后的参数要指明密钥别名以便从文件中提取)
#格式:jarsigner [各种选项和参数] 未签名的apk 密钥名称
#参数如下:
#-verbose:all  签名/验证时输出详细信息。子选项可以是all,grouped或summary
#-sigalg 签名算法名称,用keytool -list -v来确认算法的名字
#-digestalg 摘要算法名称,一般用SHA1
#-keystore .keystore文件路径
#-signedjar 输出的.apk文件
jarsigner -verbose:all -sigalg SHA256withRSA -digestalg SHA1 -keystore ~/.android/release.keystore -signedjar bin/NativeActivity.apk bin/NativeActivity-release-unsigned.apk CERT
exitWhenError jarsigner签名出错

#安装APK文件到Android设备(请先确保Android设备正常接入)
/usr/bin/adb install -ru bin/NativeActivity.apk
exitWhenError adb安装出错
#清除日志,准备查看调试信息
/usr/bin/adb logcat -c
exitWhenError adb日志猫清除出错
#查看特定调试信息
#/usr/bin/adb logcat|grep games.engines
/usr/bin/adb logcat
exitWhenError adb日志猫出错