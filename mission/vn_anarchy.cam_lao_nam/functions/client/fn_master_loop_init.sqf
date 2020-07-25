/*
  Author: Aaron Clark

  Description:
	compliled master loop

  Example Usage:
	0 spawn vn_an_fnc_master_loop_init;

  Parameter(s):
  	NA
*/
disableSerialization;
_config = (missionConfigFile >> "gamemode" >> "masterloop");
_build_sqf = preprocessFile getText (_config >> "init" >> "file");
_configs = "true" configClasses (_config >> "events");
_condition = getText (_config >> "events" >> "condition");
_file = getText (_config >> "events" >> "file");
{
	_configName = configName _x;
	_varName = format["_vn_an_%1",_configName];
	_build_sqf = _build_sqf + '
		'+_varName+' = diag_tickTime;
	';
} forEach _configs;
_build_sqf = _build_sqf + '
while {'+_condition+'} do {
	_ticktime = diag_tickTime;
';
{
	_delay = getNumber(_x >> "delay");
	_configName = configName _x;
	_varName = format["_vn_an_%1",_configName];
	_code = preprocessFile format ["%1\%2.sqf",_file,_configName];
	_build_sqf = _build_sqf + '
	if (_ticktime > '+_varName+') then {
		'+_varName+' = _ticktime + '+str(_delay)+';
		'+_code+'
	};
	';
} forEach _configs;
_build_sqf = _build_sqf + '
	uiSleep 0.1;
};';
call compile _build_sqf;
