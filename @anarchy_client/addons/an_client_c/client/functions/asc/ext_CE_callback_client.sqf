#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"

params ["_extName", "_functionTag", "_data"];

diag_log "-------------------- AN_ASC - EXT_CE_CALLBACK_CLIENT --------------------";
diag_log format["_this        :  %1", _this];
if(_extName isEqualTo "asc_extension")then
{
	_data = DATA_PARSE(_data);
	diag_log format["CALLBACK: CLIENT: _functionTag :  %1", _functionTag];
	diag_log format["CALLBACK: CLIENT: _data        :  %1", _data];
	diag_log "--------------------------";
	
	if(_functionTag isEqualTo "INIT_FUNCTIONS" && isNil "AN_C_INITFUNCTIONS_CLIENT_DONE")then
	{
		if(_functionTag == "INIT_FUNCTIONS")exitWith{AN_C_INITFUNCTIONS_CLIENT_DONE = compileFinal "true"; [_data] call AN_G_fnc_tags_set;};
	}else{
		_fnc = missionNameSpace getVariable[_functionTag, Nil];
		if(isNil "_fnc")exitWith{diag_log format["ERROR: AN_ASC - EXT_CE_CALLBACK_CLIENT: Tag/Function not found: Tag: %1", _functionTag];};
		[_data] call _fnc;
	};
};