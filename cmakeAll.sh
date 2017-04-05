#!/bin/bash
exitWhileError()
{
	if [ $? != 0 ];then
		exit
	fi
}
#main()
scriptDir=`dirname $0`
platforms="Linux Android Windows Mac"
platform=false
project=false
for para in $@
do
	#select platform name
	isPlatform=false
	for pf in $platforms
	do
		if [ $para = $pf ]; then # $para is platform name
			platform=$para
			#echo "platform = $para"
			project=false
			isPlatform=true
			project=false
			break
		fi
	done
	#set project name
	if [ $isPlatform = false ]; then # $para is project name
		project=$para
		#echo "project = $para"
	fi
	#compile project-platform
	if [ $platform != false -a $project != false ]; then
		#echo "$project $platform"
		$scriptDir/cmake.sh $project $platform
		exitWhileError
	fi
done
