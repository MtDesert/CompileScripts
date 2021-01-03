source `dirname $0`/shell.sh

#main
if [ $# == 1 ]; then
	#参数
	projectName=$1 #工程名
	para=$2 #其它参数
	#创建目录
	objDir=objects #中间文件的目录名
	mkdirp $objDir
	changeDir $objDir
	mkdirp $projectName #中间目录中创建工程目录(放中间文件用)
	#编译客户端
	make -f ../$projectName/Makefile projectDir=../$projectName DEST_PLATFORM=MinGW $para
else
	echo "Syntax: `basename $0` projectName"
fi