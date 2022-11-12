/*
	File: fn_ai_group_report_combat.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Called by the the behaviour subsystem to (safely) report that a group has entered combat.
	
	Parameter(s):
		_group - Group that has entered combat
		_enemyPos - Position of the enemy at the time of the report
	
	Returns:
		None
	
	Example(s):
		["group_report_combat", [_group]] call para_c_fnc_call_on_server;
*/


params [["_group", nil, [grpNull]], ["_enemyPos", nil, [[]], [3]]];

//Keep combat reports for 30 seconds. This gives time for AI to read the values and cache it locally if it's relevant.
private _combatReports = missionNamespace getVariable ["para_g_behaviour_groupCombatReports", []] select {_x # 0 > serverTime - 30};
_combatReports pushBack [serverTime, getPos leader _group, _group, _enemyPos];
missionNamespace setVariable ["para_g_behaviour_groupCombatReports", _combatReports, true];