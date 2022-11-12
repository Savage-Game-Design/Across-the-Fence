/*
	File: fn_submitVote.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Vote for an option.

	Parameter(s):
		_selected - Selected option (starting from 0) [Number]
	
	Returns: nothing
	
	Example(s):
		3 call para_c_fnc_submitVote;
*/

params ["_selected"];

private _data = missionNamespace getVariable '#para_c_VoteData';
if (isNil "_data") exitWith {};
[
	[
		localize "STR_vn_mf_voteMenu_casted",
		format ["%2 ""%1""", _data get "options" select _selected, localize "STR_vn_mf_voteMenu_votedFor"]
	]
] call para_c_fnc_postNotification;
_selected call _callback;
[0.3] spawn para_c_fnc_endVote;