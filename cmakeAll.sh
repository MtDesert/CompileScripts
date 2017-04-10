#!/bin/bash
exitWhileError()
{
	if [ $? != 0 ];then
		exit
	fi
}
#main()
scriptDir=`dirname $0`
platforms="Linux Android Windows Mac" #这是目前考虑的系统列表,不完善,需要补充
platform=false
project=false
for para in $@
do
	#select platform name
	isPlatform=false
	for pf in $platforms
	do
		if [ $para = $pf ]; then # $para is platform name 要么参数是平台名,要么是项目名
			platform=$para
			#echo "platform = $para"
			project=false
			isPlatform=true
			project=false
			break
		fi
	done
	#set project name
	if [ $isPlatform = false ]; then # $para is project name 要么参数是平台名,要么是项目名
		project=$para
		#echo "project = $para"
	fi
	#compile project-platform 只要确定了项目名和目标平台名,就可以进行编译
	if [ $platform != false -a $project != false ]; then
		#echo "$project $platform"
		$scriptDir/cmake.sh $project $platform
		exitWhileError
	fi
done