@echo off
for %%i in (.\config\*.xml) do (    
	echo ���ڴ���%%i
	lua xmltolua_f.lua %%i > .\config_lua\%%~ni.lua
	echo.
	echo.
)
pause