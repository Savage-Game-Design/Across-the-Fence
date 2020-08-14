@echo off

:: get file/subfolder names from argument
SET FOLDERNAME=%1
SET OUTSUBFOLDER=%2

cd ..
cd packed
:: check if subfolder/addons exists, if not create it
if not exist %OUTSUBFOLDER%\addons\ md %OUTSUBFOLDER% & md %OUTSUBFOLDER%\addons

cd %OUTSUBFOLDER%\addons
SET OUTPATH=%CD%

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: set name and path directly to "\packed\@SOMETHING\addons\FOLDERNAME.pbo"
:: e.g:
:: FOLDERNAME=		an_client
:: OUTSUBFOLDER=	@anarchy_client
:: Result:			\packed\@anarchy_client\addons\an_client.pbo
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SET OUTFILE=%OUTPATH%\%FOLDERNAME%.pbo

:: build the .pbo
MakePbo.exe "-PsFW" "-X=thumbs.db,*.txt,*.h,*.dep,*.cpp,*.bak,*.png,*.log,*.pew, *.hpp,source,*.tga" "P:\sgd\anarchy\%FOLDERNAME%" "%OUTFILE%"
