#!/bin/bash
if [ $# == 1 ]; then
	scriptDir=`dirname $0` #when this shell script has same path with cmake.sh
	for sys in Linux Android #compile one project to all the target system. See ./CMakeLists.txt
	do
		$scriptDir/cmake.sh $1 $sys
		if [ $? != 0 ]; then #break if error appear while compiling
			break
		fi
	done
else
	echo "Syntax: $0 ProjectDirectory(which contain CMakeLists.txt)"
fi
