$(info Makefile总文件)

ifeq ($(DEST_PLATFORM),Android) #android系统,使用ndk-build进行编译
projectDir:=$(NDK_PROJECT_PATH)
endif
projectName:=$(shell basename $(projectDir))

#源文件的目录
allSrcC:=$(strip $(foreach name,$(allSrcDir),$(wildcard $(projectDir)/$(name)/*.c))) #搜索出所有c文件
allSrcCpp:=$(strip $(foreach name,$(allSrcDir),$(wildcard $(projectDir)/$(name)/*.cpp))) $(if $(Executable),$(allSrcCpp),) #搜索出所有cpp文件
allSrcCpp:=$(subst /./,/,$(allSrcCpp)) #去掉/./
#包含目录
allIncDir+=$(allSrcDir) #源文件的目录也当作包含目录
rootIncDir:=$(filter /%,$(allIncDir)) #分离出"/"开头的目录
rootIncDir+=$(filter ../%,$(allIncDir)) #分离出"../"开头的目录
allIncDir:=$(filter-out /% ../%,$(allIncDir)) #先处理非"/"开头的目录
allIncDir:=$(patsubst %,$(projectDir)/%,$(allIncDir)) #所有包含目录加上工程名
allIncDir+=$(rootIncDir) #重新添加
allIncDir:=$(subst /.,,$(allIncDir)) #去掉/.
#库命名方式
libPrefix:=lib
libSuffix:=.so
ifeq ($(DEST_PLATFORM),Windows)
libSuffix:=.dll
endif
#链接库和中间文件
sysLibs:=$(patsubst %,-l%,$(sysLibs)) #给每个系统库都加上链接格式
linkUserLibs:=$(patsubst %,$(libPrefix)%$(libSuffix),$(userLibs)) #给每个自定义库都加上链接格式
allObjsC:=$(patsubst %.c,%.o,$(allSrcC)) #利用每个c源文件推导出中间文件
allObjsCpp:=$(patsubst %.cpp,%.o,$(allSrcCpp)) #利用每个cpp源文件推导出中间文件
#不要把中间文件和源文件放在一起,以防污染工程目录
allObjsC:=$(strip $(patsubst ../%,%,$(allObjsC)))
allObjsCpp:=$(strip $(patsubst ../%,%,$(allObjsCpp)))

#目标
libName:=$(strip $(libName))
exeName:=$(strip $(exeName))
targetFile:=$(strip $(if $(libName),$(libPrefix)$(libName)$(libSuffix),$(exeName))) #确定本次编译目标
isShared:=$(strip $(if $(libName),-shared,)) #编译共享库的选项

allDefines:=$(strip $(patsubst %,-D%,$(allDefines))) #所有宏定义加上"-D"

#输出各种信息
ifeq (""," ")#多行注释的一种方法
$(info 工程名$(projectName))
$(info 工程目录$(projectDir))
$(info 宏定义$(allDefines))
$(info 源目录)
$(foreach name,$(allSrcDir),$(info $(name)))
$(info 源文件)
$(foreach name,$(allSrcCpp),$(info $(name)))
$(foreach name,$(allSrcC),$(info $(name)))
$(info 中间文件)
$(foreach name,$(allObjsCpp),$(info $(name)))
$(foreach name,$(allObjsC),$(info $(name)))
$(info 包含目录)
$(foreach name,$(allIncDir),$(info $(name)))
$(info 链接用户库$(userLibs))
$(info 链接系统库$(sysLibs))
$(info 输出库名$(libName))
$(info 输出程序名$(exeName))
$(info 目标文件$(targetFile))
$(info 目标环境$(DEST_PLATFORM))
endif

ifeq ($(DEST_PLATFORM),Android) #android系统,使用ndk-build进行编译
LOCAL_PATH:=$(call my-dir)

#编译代码
include $(CLEAR_VARS) 
LOCAL_MODULE:=$(if isShared,$(libName),$(exeName))#模块名
LOCAL_SRC_FILES:=$(allSrcCpp) $(allSrcC)#所需要的源文件
LOCAL_C_INCLUDES:=$(allIncDir)#需要的包含目录
LOCAL_LDLIBS:=-lc -ldl -lm -lz -llog -landroid -lEGL -lGLESv1_CM -lGLESv2#所依赖的系统库
LOCAL_LDFLAGS:=-L../objsAndroid/local/$(APP_ABI) $(linkUserLibs)#所依赖的自定义库
LOCAL_CFLAGS:=$(allDefines)
#需要编译apk用的执行程序
ifneq ($(Executable),)
LOCAL_SRC_FILES+=$(NDK_ROOT)/sources/android/native_app_glue/android_native_app_glue.c
LOCAL_C_INCLUDES+=$(NDK_ROOT)/sources/android/native_app_glue
endif
moduleName:=$(LOCAL_MODULE)#备份
include $($(if isShared,BUILD_SHARED_LIBRARY,BUILD_EXECUTABLE))
#编译规则
clean:
	rm -rfv local/$(APP_ABI)/objs/$(moduleName)

else #使用常规编译

$(foreach name,$(allSrcDir),$(shell mkdir -p $(projectName)/$(name))) #创建各种目录
$(if $(Executable),$(shell mkdir -p $(projectName)/executable),)

#选择编译器
ifeq ($(DEST_PLATFORM),MinGW) #Linux交叉编译Windows程序
CC=/usr/bin/x86_64-w64-mingw32-gcc
CXX=/usr/bin/x86_64-w64-mingw32-g++
LINK_DIR=-L/usr/x86_64-w64-mingw32/lib #这是编译系统的lib目录
endif

#编译选项
CC_FLAGS:=$(strip -fPIC -Wall -Werror -O2)
CXX_FLAGS:=$(strip $(CC_FLAGS) -std=c++11)

allIncDir:=$(patsubst %,-I%,$(allIncDir)) #所有包含目录加上"-I"
allIncDir:=$(strip $(allIncDir))
#编译规则
$(targetFile):$(allObjsCpp) $(allObjsC) $(linkUserLibs) #链接动态库或程序
	$(CXX) $^ $(sysLibs)$(LINK_DIR)$(isShared)-o $@
$(allObjsCpp):%.o:../%.cpp #编译cpp文件
	$(CXX) -c $< $(allIncDir) $(CXX_FLAGS) $(allDefines)-o $@
$(allObjsC):%.o:../%.c #编译c文件
	$(CC) -c $< $(allIncDir) $(CC_FLAGS) $(allDefines)-o $@
clean:
	rm -rfv $(projectPath)
endif
$(info Makefile总文件结束)
