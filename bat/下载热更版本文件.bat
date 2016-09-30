@echo off
call ..\platform\macro.bat
set down_version=temp_downversionfile
set down_project=temp_downprojectfile
set version_key=remoteManifestUrl
set save_path="..\..\%platform_res%\project.manifest"


cd ..\..\tools\download
call download.bat %platform_upload% "%down_version%"


echo ==================================
@setlocal ENABLEDELAYEDEXPANSION
set #file_str=""
for /f "delims=" %%a in (%down_version%) do set #file_str=!#file_str!%%a
set #file_str=!#file_str: =!
set #file_str=!#file_str:"=!
set #file_str=!#file_str:{=!
set #file_str=!#file_str:}=!
for %%a in (!#file_str!) do (
	for /f "tokens=1 delims=," %%b in ("%%~a") do (
		for /f "tokens=1,2,3 delims=:" %%c in ("%%~b") do (
			if "%%~c" == "%version_key%" (
				call download.bat %%d:%%e %down_project%
				goto project_file_down_end
			)
		)
	)
)
:project_file_down_end


echo ==================================
replaceStr.py %down_project% %save_path% %version_key% %platform_upload% 


rm %down_version%
rm %down_project%
pause

ss1


ss2

ss3
