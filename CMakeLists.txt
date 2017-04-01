cmake_minimum_required(VERSION 2.8)

message("Cmake Version: " ${CMAKE_VERSION})
message("System Name: " ${CMAKE_SYSTEM_NAME})
message("System Version: " ${CMAKE_SYSTEM_VERSION})
message("System Processer: " ${CMAKE_SYSTEM_PROCESSOR})

aux_source_directory(. SRC_LIST)
include_directories(.)
set(CMAKE_CXX_FLAGS "-Wall -O3 -fPIC -std=c++11")

#set(TARGET_SYSTEM_NAME Linux)
#set(TARGET_SYSTEM_NAME Android)
#set(TARGET_SYSTEM_NAME Windows)

if(${TARGET_SYSTEM_NAME} STREQUAL Linux)
	message("Linux平台")
	include_directories(/usr/include/GL)
elseif(${TARGET_SYSTEM_NAME} STREQUAL Android)
	message("Android平台")
	set(TOOLCHAIN /media/WORK/android/arm-linux-androideabi-4.9) #change as you like, this is lastest version for linux 32bit is ndk-r10e
	set(CMAKE_C_COMPILER ${TOOLCHAIN}/bin/arm-linux-androideabi-gcc)
	set(CMAKE_CXX_COMPILER ${TOOLCHAIN}/bin/arm-linux-androideabi-g++)
	include_directories(${TOOLCHAIN}/include/c++/4.9)
	link_directories(${LIBRARY_OUTPUT_PATH})
elseif(${TARGET_SYSTEM_NAME} STREQUAL Windows)
	message("Windows平台")
	set(CMAKE_C_COMPILER /usr/bin/x86_64-w64-mingw32-gcc)
	set(CMAKE_CXX_COMPILER /usr/bin/x86_64-w64-mingw32-g++)
else()
	message(FATAL_ERROR "未知的平台" ${TARGET_SYSTEM_NAME})
endif()

message("Binary directory: " ${PROJECT_BINARY_DIR})

#add_library(${PROJECT_NAME} SHARED ${SRC_LIST})
#add_executable(${PROJECT_NAME} ${SRC_LIST})
