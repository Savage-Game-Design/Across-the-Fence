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
		[_tree] call vgm_g_fnc_skills_getSkillTreePoints;
 */

params ["_skillTree"];

private _skillPoints = 0;

{
    private _skillTier = _x;

    {
        if (_x call vgm_g_fnc_skills_isKnown) then
        {
            _skillPoints = _skillPoints + (_x get "cost");
        };
    } forEach _skillTier;
} forEach (_skillTree get "skills");

_skillPoints // return
