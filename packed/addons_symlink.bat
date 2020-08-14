SET PACKEDFILES=D:\Workdrive_Arma\#work\gameModes\Anarchy\packed
SET ARMAROOT=D:\Arma_Steam\steamapps\common\Arma 3
SET ARMASERVERROOT=D:\#A3-Server
SET BACKEND=D:\Workdrive_Python\work\ArmaServerCompanion\ASC\backend\dev\

:: Client:
mklink /J "%ARMAROOT%\@anarchy_client\" "%PACKEDFILES%\@anarchy_client"

:: Server:
mklink /J "%ARMASERVERROOT%\@anarchy_client\" "%PACKEDFILES%\@anarchy_client"
mklink /J "%ARMASERVERROOT%\@anarchy_server\" "%PACKEDFILES%\@anarchy_server"

:: Backend
mklink /J "%PACKEDFILES%\asc_files" "%BACKEND%"
:: backend to Server
mklink /J "%ARMASERVERROOT%\asc_files\" "%BACKEND%"

pause
exit