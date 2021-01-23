source `dirname $0`/shell.sh

compile()
{
	$scriptDirectory/ndkBuild.sh $1 $2
	exitWhenError
}

#main
if [ $# == 1 ]; then
	gameName=$1
	#开始编译各个库
	compile lua
	compile curl
	compile libGamesEngines
	compile lib$gameName
	compile libGamesClient
	compile lib${gameName} Client=true
	compile libGamesClient Executable=$gameName
else
	echo "Syntax: `basename $0` gameName"
fi
