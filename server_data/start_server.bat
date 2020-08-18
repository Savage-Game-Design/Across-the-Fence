@echo off

taskkill /IM arma3server_x64.exe /F
taskkill /IM bec.exe /F

:: ADJUST ME
SET ArmaFolder=D:\#A3-Server
D:
:: DO NOT TOUCH ME
CD %ArmaFolder%
SET ExtFolder=%ArmaFolder%\#ServerData
SET ArmaUserFolder=%ExtFolder%\AN-User
SET ArmaConfigFolder=%ExtFolder%\AN-Config



@echo on
start "Server_AN" /high "arma3server_x64.exe" -filepatching -enableHT -malloc=system -autoInit -port=2302 -loadMissionToMemory -noPause -maxmem=3071 -noSound -bandwidthAlg=2 "-servermod=@anarchy_server;" "-mod=@anarchy_client;@CBA_A3;@task_force_radio;" -config=%ArmaConfigFolder%\server_config_AN.cfg -cfg=%ArmaConfigFolder%\basic_AN.cfg -profiles=%ArmaUserFolder% -name=Server_AN
::   -ServerMod=%ExtFolder%\@IFAD_Server;
::   /affinity F 

:: timeout 5
:: start runme

cls
exit