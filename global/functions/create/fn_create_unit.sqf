/*
	File: fn_create_unit.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Wrapper around scripting command 'createUnit'.

	Parameter(s):
		// Same as 'createUnit'
	
	Returns:
		Unit created [Object]
	
	Example(s):
		[createGroup east, myClass", [0,0,0], [], 10, "NONE"] call para_g_fnc_create_unit;
*/

params ["_group", "_class", "_position", "_markers", "_placement", "_special"];

private _unit = _group createUnit [_class, _position, _markers, _placement, _special];

_unit setVariable ["sideAtCreation", side _group, true];

//Configure unit skills. These are tuned for infantry jungle-fighting, and may not work as well on vehicle crews.
_unit setSkill 1;
_unit setSkill ["general", 1];
//Prevent the AI turning around to the player in an instant.
_unit setSkill ["aimingSpeed", 0.75];
_unit setSkill ["aimingShake", 0.9];
_unit setSkill ["commanding", 1];
_unit setSkill ["courage", 1];
_unit setSkill ["reloadSpeed", 1];
//Compensated for by camouflage, in theory
_unit setSkill ["spotDistance", 1];
//Any less and the AI feels sluggish
_unit setSkill ["spotTime", 1];
_unit setSkill ["aimingAccuracy", 0.10];

_unit addEventHandler ["Killed", {
	params ["_unit"];
	[_unit] call para_s_fnc_cleanup_add_items;
}];

_unit