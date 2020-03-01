/*
  Author: Aaron Clark

  Description:
	Changes groups rank points

  Example Usage:
	[_player,10] call vn_an_fnc_player_rank;

*/
params [
	["_target",grpNull],	// 0 : OBJECT - group or player object
	["_change",0,[123]]						// 1 : NUMBER - rank change ammount
];

// make sure target is not null
if !(isNull _target) then
{
	// check if target is a group
	if (_target isEqualType grpNull) then
	{
		// set rank for every player in the group
		{
			[_x,"rank",_change] call vn_an_fnc_change_player_stat;
		} forEach ((units _target) select {isPlayer _x});
	}
	else
	{
		// check if target is an object and is a player
		if (_target isEqualType objNull && {isPlayer _target}) then
		{
			// set rank for just the targeted player
			[_target,"rank",_change] call vn_an_fnc_change_player_stat;
		};
	};
};
