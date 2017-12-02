APP_OPTIM := release #debug和release任选1项
APP_ABI := armeabi #可用的值为armeabi armeabi-v7a x86 mips,也可以用all
#APP_CFLAGS := #C编译选项
APP_CPPFLAGS += -std=c++11 #C++编译选项
#APP_BUILD_SCRIPT := Android.mk #默认值
APP_STL := gnustl_static #可用的值为system gabi++_static gabi++_shared stlport_static stlport_shared gnustl_static gnustl_shared
#APP_GNUSTL_FORCE_CPP_FEATURES := exceptions rtti #GNUSTL库用,选择是否支持异常特性,rtti
APP_PLATFORM := android-19
