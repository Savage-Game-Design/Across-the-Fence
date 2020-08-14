SET BACKEND=D:\Workdrive_Python\work\ArmaServerCompanion\ASC
SET ARMACLIENT=D:\Arma_Steam\steamapps\common\Arma 3
SET ARMASERVER=D:\#A3-Server
SET PDRIVE=D:\Workdrive_Arma

:: P-Drive
mklink /J "%PDRIVE%\asc\" "%BACKEND%\pdrive\asc"
:: for filePatching
mklink /J "%ARMACLIENT%\asc\" "%BACKEND%\pdrive\asc"
:: working copy
mklink /J "%ARMASERVER%\asc_files\" "%BACKEND%\backend\dev"

pause
exit