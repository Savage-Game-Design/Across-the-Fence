/*
	File: fn_openVoteMenu.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Opens the multi-vote menu

	Parameter(s): none
	
	Returns: nothing
	
	Example(s): none
*/

private _data = missionNamespace getVariable '#para_c_VoteData';
if (isNil "_data") exitWith {};
createDialog "para_VotingMenu";