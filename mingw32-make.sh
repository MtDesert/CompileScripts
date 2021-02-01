source `dirname $0`/shell.sh

makeShell=$scriptDirectory/make.sh
#参数
if [ $# != 1 ]; then
	echo 语法: `basename $0` 工程路径
	echo 请参考$makeShell细则,如下
	$makeShell
	exit
fi
#修改make.sh的默认参数
name=$1
export makeCommand=make
export DEST_PLATFORM=MinGW
export objDir=objects
#开始编译
$makeShell $name