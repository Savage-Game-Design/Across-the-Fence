/*
  Author: Aaron Clark

  Description:
	Debug Monitor

  Example Usage:
	call vn_mf_fnc_debug_monitor;

  Parameter(s):
  	NA
*/
private _texts = [];
{
	if (isClass(_x)) then
	{
		private _name = configName _x;
		_texts pushBack (format["%1: %2\n",_name,(player getVariable [format["vn_mf_%1",_name],0])]);
	}
} forEach ("true" configClasses (missionConfigFile >> "gamemode" >> "stats"));
hintSilent (_texts joinString "");
