@echo off

taskkill /IM arma3server_x64.exe /F
taskkill /IM bec.exe /F


SET CurrentFolder=%~dp0
SET DataFolder=%CurrentFolder%#ServerData
SET ArmaUserFolder=%DataFolder%\AN-User
SET ArmaConfigFolder=%DataFolder%\AN-Config



@echo on
start "Server_AN" /high "arma3server_x64.exe" -filepatching -enableHT -malloc=system -autoInit -port=2302 -loadMissionToMemory -noPause -maxmem=3071 -noSound -bandwidthAlg=2 "-servermod=@anarchy_server;" "-mod=@anarchy_client;@vn;@task_force_radio;@CBA_A3;" "-config=%ArmaConfigFolder%\server_config_AN.cfg" "-cfg=%ArmaConfigFolder%\basic_AN.cfg" "-profiles=%ArmaUserFolder%" -name=Server_AN
::   /affinity F 

:: timeout 5
:: start runme

cls
exit