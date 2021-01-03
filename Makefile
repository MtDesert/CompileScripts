$(info Makefile总文件)

ifeq ($(DEST_PLATFORM),Android) #android系统,使用ndk-build进行编译
projectDir:=$(NDK_PROJECT_PATH)
endif
projectName:=$(shell basename $(projectDir))

#去掉首尾空格
allSrcDir:=$(strip $(allSrcDir))
allIncDir:=$(strip $(allIncDir))
userLibs:=$(strip $(userLibs))
sysLibs:=$(strip $(sysLibs))
libName:=$(strip $(libName))

allSrc += $(foreach name,$(allSrcDir),$(wildcard $(projectDir)/$(name)/*.c)) #搜索出所有c文件
allSrc += $(foreach name,$(allSrcDir),$(wildcard $(projectDir)/$(name)/*.cpp)) #搜索出所有cpp文件
allSrc := $(strip $(allSrc))
allIncDir += $(allSrcDir) #源文件的目录也当作包含目录
allIncDir := $(patsubst %,$(projectDir)/%,$(allIncDir)) #所有包含目录加上工程名
sysLibs := $(patsubst %,-l%,$(sysLibs)) #给每个系统库都加上链接格式
userLibs := $(patsubst %,-l%,$(userLibs)) #给每个自定义库都加上链接格式
allObjs := $(patsubst %.c,%.o,$(allSrc)) #利用每个c源文件推导出中间文件
allObjs := $(patsubst %.cpp,%.o,$(allObjs)) #利用每个cpp源文件推导出中间文件
allObjs := $(patsubst %,$(projectName)/%,$(allObjs)) #不要把中间文件和源文件放在一起,以防污染工程目录
#目标
targetFile:=$(if $(libName),lib$(libName).so,$(exeName).exe) #确定本次编译目标
isShared:=$(if $(libName),-shared,) #编译共享库的选项

allDefines := $(patsubst %,-D%,$(allDefines)) #所有宏定义加上"-D"

$(info 工程名$(projectName))
$(info 工程目录$(projectDir))
$(info 宏定义$(allDefines))
$(info 源目录)
$(foreach name,$(allSrcDir),$(info $(name)))
$(info 包含目录)
$(foreach name,$(allIncDir),$(info $(name)))
$(info 链接用户库$(userLibs))
$(info 链接系统库$(sysLibs))
$(info 输出库名$(libName))
$(info 输出程序名$(exeName))

ifeq ($(DEST_PLATFORM),Android) #android系统,使用ndk-build进行编译
LOCAL_PATH := $(call my-dir)

#编译代码
include $(CLEAR_VARS) 
LOCAL_MODULE:= $(if isShared,$(libName),$(exeName)) #模块名
LOCAL_SRC_FILES:= $(allSrc) #所需要的源文件
LOCAL_C_INCLUDES:= $(allIncDir) #需要的包含目录
LOCAL_LDLIBS:= -lz -llog -landroid -lEGL -lGLESv1_CM -lGLESv2 #所依赖的系统库
LOCAL_LDFLAGS+= -L../objsAndroid/local/armeabi-v7a $(userLibs) #所依赖的自定义库
LOCAL_CFLAGS:= $(allDefines)
include $($(if isShared,BUILD_SHARED_LIBRARY,BUILD_EXECUTABLE))

else #使用常规编译

$(foreach name,$(allSrcDir),$(shell mkdir -p $(projectName)/$(name))) #创建各种目录

#选择编译器
ifeq ($(DEST_PLATFORM),MinGW) #Linux交叉编译Windows程序
CC = /usr/bin/x86_64-w64-mingw32-gcc
CXX = /usr/bin/x86_64-w64-mingw32-g++
LINK_DIR = -L/usr/x86_64-w64-mingw32/lib #这是编译系统的lib目录
else ifeq ($(DEST_PLATFORM),Windows) #Windows下的MinGW
CC = C:/MinGW/bin/mingw32-gcc.exe
CXX = C:/MinGW/bin/mingw32-g++.exe
LINK_DIR = -LC:/MinGW/lib #这是编译系统的lib目录
else #Linux系统下编译
$(info Linux系统默认编译环境)
endif

#编译选项
CC_FLAGS = -fPIC -Wall -Werror -O2
CXX_FLAGS = $(CC_FLAGS) -std=c++11

allIncDir := $(patsubst %,-I%,$(allIncDir)) #所有包含目录加上"-I"
#编译规则
$(targetFile): $(allObjs) $(userLibs) #链接动态库或程序
	$(CXX) $^ $(sysLibs) $(LINK_DIR) $(isShared) -o $@

$(projectName)/%.o: %.cpp #编译cpp文件
	$(CXX) -c $< $(allIncDir) $(CXX_FLAGS) $(allDefines) -o $@

$(projectName)/%.o: %.c #编译c文件
	$(CC) -c $< $(allIncDir) $(CC_FLAGS) $(allDefines) -o $@
endif
$(info Makefile总文件结束)