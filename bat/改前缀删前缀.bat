@echo off
setlocal enabledelayedexpansion

for /f %%i in ('dir /b *.lua') do (
	ren %%i app.config.%%i
)

for /f %%i in ('dir /b *.lua') do (
	set s1=%%i
	set s2=!s1:app.config.=!
	if "!s1!" NEQ "!s2!"  (
		ren "!s1!" "!s2!"
	)
)

pause
