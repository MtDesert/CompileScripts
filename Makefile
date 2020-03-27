$(info Makefile总文件)
projectDir:=$(shell dirname $(word 1,$(MAKEFILE_LIST))) #获取Makefile所在目录
projectDir:=$(strip $(projectDir))
projectName:=$(shell basename $(projectDir))

#去掉首尾空格
allSrcDir:=$(strip $(allSrcDir))
allIncDir:=$(strip $(allIncDir))
userLibs:=$(strip $(userLibs))
sysLibs:=$(strip $(sysLibs))
libName:=$(strip $(libName))

$(info 工程名$(projectName))
$(info 工程目录$(projectDir))
$(info 源目录$(allSrcDir))
$(info 包含目录$(allIncDir))
$(info 链接用户库$(userLibs))
$(info 链接系统库$(sysLibs))
$(info 库名$(libName))
$(info 程序名$(exeName))

#编译器
CC = /usr/bin/x86_64-w64-mingw32-gcc
CXX = /usr/bin/x86_64-w64-mingw32-g++
LINK_DIR = -L/usr/x86_64-w64-mingw32/lib #这是编译系统的lib目录

allSrc += $(foreach name,$(allSrcDir),$(wildcard $(projectDir)/$(name)/*.c)) #搜索出所有c文件
allSrc += $(foreach name,$(allSrcDir),$(wildcard $(projectDir)/$(name)/*.cpp)) #搜索出所有cpp文件
allSrc := $(strip $(allSrc))
allIncDir += $(allSrcDir) #源文件的目录也当作包含目录
allIncDir := $(patsubst %,-I$(projectDir)/%,$(allIncDir)) #所有包含目录加上"-I"
userLibs := $(patsubst %,-l%,$(userLibs)) #给每个自定义库都加上链接格式
sysLibs := $(patsubst %,-l%,$(sysLibs)) #给每个系统库都加上链接格式
allObjs := $(patsubst %.c,%.o,$(allSrc)) #利用每个c源文件推导出中间文件
allObjs := $(patsubst %.cpp,%.o,$(allObjs)) #利用每个cpp源文件推导出中间文件
allObjs := $(patsubst %,$(projectName)/%,$(allObjs)) #不要把中间文件和源文件放在一起,以防污染工程目录
$(foreach name,$(allSrcDir),$(shell mkdir -p $(projectName)/$(name))) #创建各种目录
$(info 源文件$(allSrc))
#目标
targetFile:=$(if $(libName),lib$(libName).so,$(exeName).exe) #确定本次编译目标
isShared:=$(if $(libName),-shared,) #编译共享库的选项

$(targetFile): $(allObjs) $(userLibs) #链接动态库或程序
	$(CXX) $^ $(sysLibs) $(LINK_DIR) $(isShared) -o $@

$(projectName)/%.o: %.cpp #编译cpp文件
	$(CXX) -c $< $(allIncDir) -o $@

$(projectName)/%.o: %.c #编译c文件
	$(CC) -c $< $(allIncDir) -o $@

$(info ............)