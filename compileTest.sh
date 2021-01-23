source `dirname $0`/shell.sh

#获取参数
if [ $# == 0 ]; then
	echo "语法: `basename $0` 工程名 [参数]"
	exit
fi

projectName=$1
para=$2
libName=lib$projectName

#注意:当编译测试出现编译报错时,修正完代码再编译,注释掉删除命令可以不再重新编译已经正确的源文件,以节省编译时间
#强烈建议:修正完后再进行完整的清空和编译,以保证项目能编译成各种环境的代码
cmdShred="$scriptDirectory/shred.sh -remove"
cmdMake="$scriptDirectory/make.sh"
cmdNdkBuild="$scriptDirectory/ndkBuild.sh"

#清除缓冲
clearCache()
{
	if [ -z $needClean ]; then
		return 0
	fi
	#开始清理
	if [ -d $objDir/$projectName ]; then #工程名没有lib打头
		$cmdShred $objDir/$projectName
	elif [ -d $objDir/$libName ]; then #工程名有lib打头
		$cmdShred $objDir/$libName
	fi
}
#编译工程
compile()
{
	makeCmd=$1
	if [ -d $projectName -a -f $projectName/Makefile ]; then #工程名没有lib打头
		$makeCmd $projectName $para
	elif [ -d $libName -a -f $libName/Makefile ]; then #工程名有lib打头
		$makeCmd $libName $para
	else
		exitWhenError 找不到项目$projectName
	fi
}

#编译测试Linux
compileLinux(){
	objDir=objs
	clearCache
	compile $cmdMake #清除完缓存,开始编译
}

#编译测试NDK
compileNDK(){
objDir=objsAndroid
for cpuType in armeabi-v7a #arm64-v8a x86 x86_64 #请根据所选的NDK进行修改
do
	echo $cpuType
	#清除中间文件和库
	if [ -n $needClean ]; then
		echo 你妈
		rm $objDir/$cpuType/$libName.so
		rm $objDir/local/$cpuType/$libName.so
		$cmdShred $objDir/local/$cpuType/objs/$projectName
	fi
	#开始编译
	export APP_ABI=$cpuType
	compile $cmdNdkBuild
done
}

#编译测试MinGW
compileMinGW(){
export DEST_PLATFORM=MinGW
export objDir=objects
clearCache
compile $cmdMake #清除完缓存,开始编译
}

#main
needClean=true #根据测试和修正过程对此变量进行开关操作(简单的注释操作即可)
#编译各个平台的程序或库,如果某个平台编译有问题,可注释掉其它平台的编译命令
compileLinux
compileNDK
compileMinGW