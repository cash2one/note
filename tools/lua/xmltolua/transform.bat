@echo off
for %%i in (.\config\*.xml) do (    
	echo 正在处理%%i
	lua xmltolua_f.lua %%i > .\config_lua\%%~ni.lua
	echo.
	echo.
)
pause