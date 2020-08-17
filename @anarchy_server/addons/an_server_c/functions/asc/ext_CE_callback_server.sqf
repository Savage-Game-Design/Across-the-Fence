#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"

params ["_extName", "_functionTag", "_data"];

diag_log "-------------------- AN_ASC - EXT_CE_CALLBACK_SERVER --------------------";
diag_log format["_this        :  %1", _this];
if(_extName isEqualTo "asc_extension")then
{
	_data = DATA_PARSE(_data);
	diag_log format["CALLBACK: SERVER: _functionTag :  %1", _functionTag];
	diag_log format["CALLBACK: SERVER: _data        :  %1", _data];
	diag_log "--------------------------";
	
	if(_functionTag in ["address_read","INIT_FUNCTIONS"] && isNil "AN_S_INITFUNCTIONS_SERVER_DONE")then
	{
		if(_functionTag == "address_read")exitWith{[_data] call AN_S_fnc_asc_address_set;};
		if(_functionTag == "INIT_FUNCTIONS")exitWith{AN_S_INITFUNCTIONS_SERVER_DONE = compileFinal "true"; [_data] call AN_G_fnc_tags_set;};
	}else{
		_fnc = missionNameSpace getVariable[_functionTag, Nil];
		if(isNil "_fnc")exitWith{diag_log format["ERROR: AN_ASC - EXT_CE_CALLBACK_SERVER: Tag/Function not found: Tag: %1", _functionTag];};
		[_data] call _fnc;
	};
};
