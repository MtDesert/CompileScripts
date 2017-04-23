#!/bin/bash
source `dirname $0`/shell.sh

cmake.sh libCpp11 Linux
exitWhenError
cmake.sh Games/libGamesEngines Linux
exitWhenError
cmake.sh Games/libAdvanceWars Linux
exitWhenError
exe-Linux/AdvanceWarsGLUT
