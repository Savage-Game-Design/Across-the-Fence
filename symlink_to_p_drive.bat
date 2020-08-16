@echo off
TITLE SGD Anarchy Symlink Setup
set FILE_DIR=%~dp0

CALL :Create_Dir_If_Not_Exist P:\sgd
CALL :Create_Dir_If_Not_Exist P:\sgd\anarchy

for /D %%f IN (%FILE_DIR%@anarchy_client\addons\* , %FILE_DIR%@anarchy_server\addons\*) DO (
	CALL :Create_Junction_If_Not_Exist P:\sgd\anarchy\%%~nf %%f
)

pause
EXIT /B 0

:Create_Dir_If_Not_Exist
IF NOT EXIST %~1 (
	echo Creating %~1
	mkdir %~1
) else (
	echo %~1 already exists - Skipping creation
)
EXIT /B 0

:Create_Junction_If_Not_Exist
IF NOT EXIST %~1 (
	echo Linking %~2 to %~1
	mklink /j %~1 %~2
) else (
	echo %~1 already exists - Skipping link
)
EXIT /B 0