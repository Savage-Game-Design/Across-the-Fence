/*
	File: fn_behaviour_report_combat.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Reports that a squad has made contact, so that the information can be used by other squads.
	
	Parameter(s):
		_group - Group that has made contact with opposition
	
	Returns:
		None
	
	Example(s):
		_group call para_g_fnc_behaviour_report_combat
*/

params ["_group"];

private _nearestEnemy = leader _group findNearestEnemy leader _group;

if !([_group, _nearestEnemy] call para_g_fnc_behaviour_is_valid_target) exitWith {};

["group_report_combat", [_group, getPos _nearestEnemy]] call para_c_fnc_call_on_server;