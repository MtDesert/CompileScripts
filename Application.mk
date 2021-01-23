APP_OPTIM:=release #debug和release任选1项
#APP_ABI:=all #可用的值为arm64-v8a armeabi-v7a x86 x86_64,也可以用all
#APP_CFLAGS := #C编译选项
APP_CPPFLAGS:=-std=c++11 -frtti -fexceptions #C++编译选项
#APP_BUILD_SCRIPT := Android.mk #默认值
APP_STL:=c++_shared #可用的值为none system c++_shared c++_static
#APP_GNUSTL_FORCE_CPP_FEATURES := exceptions rtti #GNUSTL库用,选择是否支持异常特性,rtti
APP_PLATFORM:=android-29