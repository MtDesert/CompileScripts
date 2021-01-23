source `dirname $0`/shell.sh

#参数
projectName=$1 #工程名
para=$2 #其它参数
echoInfo 编译工程${projectName}
echoInfo 参数${para}
#变量默认值
makeCommand=${makeCommand:=make} #make命令名
DEST_PLATFORM=${DEST_PLATFORM:=Linux} #目标环境
objDir=${objDir:=objs} #中间文件输出目录
#变量修正
if [[ $OS =~ Windows ]]; then #Windows环境
	makeCommand=mingw32-make #MinGW用的make
fi
#创建目录
mkdirp $objDir
changeDir $objDir
mkdirp $projectName #中间目录中创建工程目录(放中间文件用)
#编译客户端
$makeCommand -f ../$projectName/Makefile projectDir=../$projectName DEST_PLATFORM=$DEST_PLATFORM $para
exitWhenError make失败
echoOK 工程${projectName}构建完成
