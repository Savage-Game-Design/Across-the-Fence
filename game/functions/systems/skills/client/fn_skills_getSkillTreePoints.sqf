/*
	File: fn_skills_getTreeSkillPoints.sqf
	Author: Savage Game Design
	Date: 2023-05-13
	Last Update: 2023-05-13
	Public: No

	Description:
		No description added yet.

	Parameter(s):
		_tree - The tree to get the skill points from. [STRING]

	Returns:
		Number of skills points spent in tree. [Number]

	Example(s):
		[_tree] call vgm_c_fnc_skills_getSkillTreePoints;
 */

params ["_tree"];

private _skillPointsSpent = (player getVariable "vgm_g_skillsData") get "skillPointsSpent";
private _result = _skillPointsSpent getOrDefault [_tree, 0];
_result
