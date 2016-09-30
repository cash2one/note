@echo off & setlocal enabledelayedexpansion

cd ./Classes
set out_file=./../proj.android/jni/Android.mk
echo. > %out_file%

echo LOCAL_PATH := $(call my-dir)>>%out_file%
echo.>>%out_file%

echo include $(CLEAR_VARS)>>%out_file%
echo.>>%out_file%

echo LOCAL_MODULE := cocos2dlua_shared>>%out_file%
echo.>>%out_file%

echo LOCAL_MODULE_FILENAME := libcocos2dlua>>%out_file%
echo.>>%out_file%

echo LOCAL_SRC_FILES := hellolua/main.cpp \>>%out_file%
for /r %%i in (*.cpp) do (
	set str=%%i
	set str2=!str:\=/!
	set str3=!str2:*/Classes=../../Classes!
	call echo %%str3%% \>>%out_file%
)
echo.>>%out_file%
echo.>>%out_file%


echo LOCAL_C_INCLUDES := \>>%out_file%
echo $(LOCAL_PATH)/../../Classes \>>%out_file%
echo $(LOCAL_PATH)/../../Classes/runtime \>>%out_file%
echo $(LOCAL_PATH)/../../../quick-Community/external \>>%out_file%
echo $(LOCAL_PATH)/../../../quick-Community/external/protobuf-lite/src \>>%out_file%
echo $(LOCAL_PATH)/../../../quick-Community/quick/lib/quick-src \>>%out_file%
echo $(LOCAL_PATH)/../../../quick-Community/quick/lib/quick-src/extra \>>%out_file%

echo $(LOCAL_PATH)/../protocols/android \>>%out_file%
echo $(LOCAL_PATH)/../protocols/include \>>%out_file%

echo $(LOCAL_PATH)/../../Classes\lua\auto \>>%out_file%
echo $(LOCAL_PATH)/../../Classes\lua\classes>>%out_file%

rem echo LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../quick-Community/>>%out_file%
echo.>>%out_file%
echo.>>%out_file%

rem dragonbones
rem echo LOCAL_C_INCLUDES += \>>%out_file%
rem echo $(LOCAL_PATH)/../../../quick-Community/cocos/editor-support/dragonbones \>>%out_file%
rem echo $(LOCAL_PATH)/../../../quick-Community/cocos/editor-support/dragonbones/renderer/cocos2d-x-3.x>>%out_file% \


rem echo LOCAL_WHOLE_STATIC_LIBRARIES += PluginProtocolStatic>>%out_file%
rem echo.>>%out_file%


echo LOCAL_STATIC_LIBRARIES := cocos2d_lua_static>>%out_file%
echo LOCAL_STATIC_LIBRARIES += lua_extensions_static>>%out_file%
echo LOCAL_STATIC_LIBRARIES += extra_static>>%out_file%
echo.>>%out_file%

rem dragonbones
rem echo LOCAL_WHOLE_STATIC_LIBRARIES += dragonbones_static>>%out_file%
rem echo.>>%out_file%

echo include $(BUILD_SHARED_LIBRARY)>>%out_file%
echo.>>%out_file%
echo.>>%out_file%

echo $(call import-add-path,$(LOCAL_PATH)/../../../quick-Community)>>%out_file%
echo $(call import-add-path,$(LOCAL_PATH)/../../../quick-Community/cocos)>>%out_file%
echo $(call import-add-path,$(LOCAL_PATH)/../../../quick-Community/quick/lib)>>%out_file%
echo $(call import-add-path,$(LOCAL_PATH)/../../../quick-Community/quick/templates/lua-template-quick/frameworks/runtime-src/proj.android)>>%out_file%
echo.>>%out_file%


echo $(call import-module, scripting/lua-bindings/proj.android)>>%out_file%
echo.>>%out_file%

echo $(call import-module, quick-src/lua_extensions)>>%out_file%
echo $(call import-module, quick-src/extra)>>%out_file%
echo.>>%out_file%

echo $(call import-module, protocols/android)>>%out_file%
echo.>>%out_file%

rem dragonbones
rem echo $(call import-module,editor-support/dragonbones/renderer/cocos2d-x-3.x/android)>>%out_file%
rem echo.>>%out_file%


echo.>>%out_file%
echo.>>%out_file%


cd ../

set cocoslua_so_file=proj.android\\libs\\armeabi\\libcocos2dlua.so
if exist "%cocoslua_so_file%" (del "%cocoslua_so_file%")

set cocoslua_so_file2=proj.android\\libs\\armeabi-v7a\\libcocos2dlua.so
if exist "%cocoslua_so_file2%" (del "%cocoslua_so_file2%")


