source `dirname $0`/shell.sh

function shredFile() #粉碎文件
{
	if [ $shredMode == remove ]; then
		echoWarn 删除文件:`pwd`/$1
		rm $1
	else
		echoWarn 粉碎文件:`pwd`/$1
		shred -fuz $1
	fi
	exitWhenError $1:文件删除出错
}

function shredDir() #粉碎目录
{
	#删除目录下的所有文件
	changeDir $1
	for filename in *
	do
		shredFilename $filename
	done
	#删除自己
	changeDir ..
	echoWarn 删除目录:`pwd`/$1
	rmdir $1
	exitWhenError 目录删除出错:$1
}

shredFilename() #粉碎文件或目录
{
	if [ -f $1 ]; then
		shredFile $1
	elif [ -d $1 ]; then
		shredDir $1
	fi
}

#开始粉碎
if [ $# -ge 1 ]; then
	#分析参数
	if [ $1 == "-"remove ]; then
		shredMode=remove
		name=$2
	else
		name=$1
	fi
	#递归切换目录
	changeDir $name
	changeDir ..
	shredFilename `basename $name`
else
	echo "语法: `basename $0` [-remove] 目录名"
	echo 当带有-remove时候,删除文件执行的是rm命令而不是shred命令
	echoWarn 此脚本主要用于粉碎目录,粉碎文件请使用shred
fi