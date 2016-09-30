@echo off
echo Source:      "%~1" 
echo Destination: "%~2"
echo Start downloading. . .
cscript -nologo -e:jscript "download.js" "%~1" "%~2" "http://ms.version.binghenet.com/preview/version.manifest" "version.manifest"
echo OK!

