source `dirname $0`/shell.sh

#main()
#参数表
projectPath=$1
paraA=$2
paraB=$3
projectName=`basename ${projectPath}`
#设置输出文件夹
objectPath=objs #存放中间文件
if [ -z $libPath ]; then #默认库输出目录
	libPath=bin
fi
if [ -z $exePath ]; then #默认程序输出目录
	exePath=bin
fi
#创建文件夹
mkdirp $objectPath
mkdirp $objectPath/$projectName
mkdirp $libPath
mkdirp $exePath
#根据系统调整参数
if [[ $OS =~ Windows ]]; then
	generatorName="MinGW Makefiles" #推荐使用MinGW编译
	makeCommand=mingw32-make #MinGW用的make
else #默认环境(类Unix)环境
	generatorName="Unix Makefiles"
	makeCommand=make
fi
#开始编译
changeDir $objectPath/$projectName
cmake -G "$generatorName" -Wno-dev -DLIBRARY_OUTPUT_PATH=../../$libPath -DEXECUTABLE_OUTPUT_PATH=../../$exePath ../../$projectPath $paraA $paraB
exitWhenError cmake失败
$makeCommand
exitWhenError make失败