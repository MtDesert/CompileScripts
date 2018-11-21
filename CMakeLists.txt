#这是个给cmake使用的文件,此脚本主要目的是作为其它项目的公共脚本,主要针对C/C++项目
#此脚本目前的功能是提供交叉编译的的功能,主要用来描述编译到各个平台时需要配置哪些内容,具体请查看cmake的手册
#比如,你有个工程叫MyCppLib,那么你的工程目录需要的文件是:头文件,源文件,CMakeLists.txt,那么你可以在这个工程的CMakeLists.txt文件中include此文件,即

#cmake_minimum_required(VERSION 2.8)
#project(MyCppLib)
#include(../CompileScripts/CMakeLists.txt) #相对或者绝对路径指向本文件
#(other things about MyCppLib)

#这样做可以让大多数项目使用相同的交叉编译配置,而在各自的项目中进行差异化处理

cmake_minimum_required(VERSION 2.8)

message("Cmake版本: " ${CMAKE_VERSION})
message("系统名: " ${CMAKE_SYSTEM_NAME})
message("系统版本: " ${CMAKE_SYSTEM_VERSION})
message("系统处理器: " ${CMAKE_SYSTEM_PROCESSOR})

aux_source_directory(. SRC_LIST)
include_directories(.)

macro(srcInclude name)
	aux_source_directory(${name} SRC_LIST)
	include_directories(${name})
endmacro()

if(${TARGET_SYSTEM_NAME} STREQUAL Linux)
	message("Linux平台")
	set(CMAKE_C_FLAGS "-fPIC -Wall -Werror -O2")#编译选项要把所有的警告都视为错误,因为某些警告不处理好的话可能会导致程序崩溃
	set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++11")
	include_directories(/usr/include/GL)
	link_directories(${LIBRARY_OUTPUT_PATH})
elseif(${TARGET_SYSTEM_NAME} STREQUAL Android)#编译基本没有问题,但是不保证编译出来的APK用的.so文件一定没有问题
	message("Android平台")
	set(ANDROID_NDK /media/WORK/android/android-ndk-r13b)#根据情况自行修改路径
	set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++11")
	include_directories(${ANDROID_NDK}/platforms/android-19/arch-arm/usr/include)
	include_directories(${ANDROID_NDK}/sources/android/native_app_glue)
	link_directories(${LIBRARY_OUTPUT_PATH})
elseif(${TARGET_SYSTEM_NAME} STREQUAL Windows)
	message("Windows平台")
	set(CMAKE_C_COMPILER /usr/bin/x86_64-w64-mingw32-gcc)
	set(CMAKE_CXX_COMPILER /usr/bin/x86_64-w64-mingw32-g++)
else()
	message(FATAL_ERROR "未知的平台" ${TARGET_SYSTEM_NAME})
endif()

message("Binary directory: " ${PROJECT_BINARY_DIR})
