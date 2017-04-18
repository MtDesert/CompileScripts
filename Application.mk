APP_OPTIM := release #debug
APP_ABI := armeabi #all armeabi armeabi-v7a x86 mips
#APP_CFLAGS :=
APP_CPPFLAGS += -std=c++11
#APP_BUILD_SCRIPT := Android.mk #This is default
APP_STL := stlport_shared #system gabi++_static gabi++_shared stlport_static stlport_shared gnustl_static gnustl_shared
#APP_GNUSTL_FORCE_CPP_FEATURES := exceptions rtti
APP_PLATFORM := android-19
