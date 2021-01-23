cmake_minimum_required(VERSION 2.8)

message("CMake版本: " ${CMAKE_VERSION})
message("系统名: " ${CMAKE_SYSTEM_NAME})
message("系统版本: " ${CMAKE_SYSTEM_VERSION})
message("系统处理器: " ${CMAKE_SYSTEM_PROCESSOR})

set(CMAKE_C_FLAGS "-fPIC -Wall -Werror -O2 -g")#编译选项要把所有的警告都视为错误,因为某些警告不处理好的话可能会导致程序崩溃
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++11")
link_directories(${LIBRARY_OUTPUT_PATH})

#添加包含目录,以prefix为统一前缀,
macro(includeAll prefix)
	foreach(name ${ARGN})
		include_directories(${prefix}${name})
		message(包含目录${prefix}${name})
	endforeach()
endmacro()

#添加源文件路径和包含文件路径name
macro(srcInclude srcList name)
	aux_source_directory(${name} ${srcList})
	include_directories(${name})
endmacro()

#将includeList目录表全部加入源文件路径和包含路径
macro(srcIncludeAll srcList prefix)
	foreach(name ${ARGN})
		srcInclude(${srcList} ${prefix}${name})
		message(源目录${prefix}${name})
	endforeach()
endmacro()