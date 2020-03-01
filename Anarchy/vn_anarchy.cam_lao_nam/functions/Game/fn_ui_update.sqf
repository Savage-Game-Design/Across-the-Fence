/*
  Author: Aaron Clark

  Description:
	update stat progress bar ui

  Example Usage:
		[player] call vn_an_fnc_unit_next_rank

  Returns:
	NOTHING

  Parameter(s):
*/
params
[
	"_name",  	// 0: STRING - stat name
	"_value" 	// 1: STRING - value
];
private _ctrl = uiNamespace getVariable [format["vn_an_%1_ctrl",_name],controlNull];
if !(isNull _ctrl) then
{
	_ctrl progressSetPosition (player getVariable [_name, 1]);
};
