#!/bin/bash
function shredFile()
{
	echo Deleting File... $1
	shred -fuvz $1
}

function shredDir()
{
	echo Deleting Dir: $1
	cd $1
	for filename in ./*
	do
		shredFilename $filename
	done
	cd ..
	rmdir $1
}

shredFilename()
{
	if [ -f $1 ]; then
		shredFile $1
	elif [ -d $1 ]; then
		shredDir $1
	fi
}

if [ $# == 1 ]; then
	shredFilename $1
fi
