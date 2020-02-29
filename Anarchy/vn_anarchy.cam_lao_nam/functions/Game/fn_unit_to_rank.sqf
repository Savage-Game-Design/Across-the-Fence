/*
  Author: Aaron Clark

  Description:
	converts rank to icon

  Example Usage:
		[player] call vn_mf_fnc_unit_to_rank

  Returns:
	0 : ARRAY -	0 : STRING - path to rank icon
	1 : STRING - rank text name

  Parameter(s):
*/
params
[
	["_unit",objNull,[objNull]] 	// 0: OBJECT - player unit object
];

private _data = [];
{
	//code
	_x params [["_rank_data",["","",0]]];
	_rank_data params ["", "", "_pointsneeded"];
	if (_unit getVariable ["vn_mf_rank",0] >= _pointsneeded) then
	{
		_data = _rank_data;
	};
} forEach getArray(missionConfigFile >> "gamemode" >> "rank" >> "ranks");
_data
