LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE    := Cpp11
LOCAL_SRC_FILES := $(wildcard ../libCpp11/*.cpp)
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := Algorithm
LOCAL_SRC_FILES := $(wildcard ../libAlgorithm/*.cpp)
LOCAL_C_INCLUDES+= ../libCpp11
LOCAL_SHARED_LIBRARIES:= libCpp11
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := Zipper
LOCAL_SRC_FILES := $(wildcard ../libZipper/*.cpp)
LOCAL_SRC_FILES := $(wildcard ../libZipper/FileStructs/*.cpp)
LOCAL_SRC_FILES := $(wildcard ../libZipper/zlib/*.c)
LOCAL_C_INCLUDES+= ../libCpp11
LOCAL_SHARED_LIBRARIES:= libCpp11
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := Image
LOCAL_SRC_FILES := $(wildcard ../libImage/*.cpp)
LOCAL_SRC_FILES := $(wildcard ../libImage/FileStructs/*.cpp)
LOCAL_SRC_FILES := $(wildcard ../libImage/ColorSpaces/*.cpp)
LOCAL_C_INCLUDES+= ../libCpp11 ../libZipper
LOCAL_SHARED_LIBRARIES:= libZipper libCpp11
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := Font
LOCAL_SRC_FILES := $(wildcard ../libFont/*.cpp)
LOCAL_C_INCLUDES+= ../libCpp11 ../libMath ../libImage
LOCAL_SHARED_LIBRARIES:= libImage libZipper libCpp11
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := lua
LOCAL_SRC_FILES := $(wildcard ../lua/*.c)
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := tinyxml2
LOCAL_SRC_FILES := $(wildcard ../tinyxml2/*.cpp)
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
EXE_PATH :=../Games/libGamesEngines/executable
LOCAL_MODULE    := GamesAndroid
LOCAL_SRC_FILES := $(EXE_PATH)/GamesNativeActivity.cpp \
	$(EXE_PATH)/GamesEGL.cpp
LOCAL_C_INCLUDES := $(NDK_ROOT)/platforms/android-19/arch-arm/usr/include/GLES
LOCAL_LDLIBS    := -llog -landroid -lEGL -lGLESv1_CM
LOCAL_STATIC_LIBRARIES := android_native_app_glue
include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/native_app_glue)
