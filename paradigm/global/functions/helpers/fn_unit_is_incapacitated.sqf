/*
	File: fn_unit_is_incapacitated.sqf
	Author:  Savage Game Design
	
	Description:
		Returns whether the unit is in the incapacitated state
	
	Parameter(s):
		_unit - Unit to check against [OBJECT]
	
	Returns: boolean
	
	Example(s):
		Call para_g_fnc_unit_is_incapacitated;
*/

params ["_unit"];

private _healthState = lifeState _unit;
// we read the vn_revive_incapacitated variable because it's read out in some mike_force code, but we default to false so there's no dependency on mike_force
private _incapacitated = alive _unit && (_unit getVariable ["vn_revive_incapacitated", false] || _healthState == "INCAPACITATED");

_incapacitated