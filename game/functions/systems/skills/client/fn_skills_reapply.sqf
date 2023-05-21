/*
    File: fn_skills_reapply.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-21
    Public: No

    Description:
        Reapplies skills of a type to a player.

    Parameter(s):
        _type [STRING] - "passive" (default)
                         "primary"
                         "ultimate"

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_skills_reapply;
        "primary" call vgm_c_fnc_skills_reapply;
 */

params [["_type", "passive"]];

private _skillType = switch (_type) do {
	case "primary": {1};
	case "ultimate": {2};
	default {0};
};

private _skillsData = player getVariable ["vgm_g_skillsData", []];
private _skills = _skillsData get "skillPaths";

{
    private _skill = _x call vgm_g_fnc_skills_getByPath;

    if (_skill get "skillType" == _skillType) then {
        player call (_skill get "codeApply");
    };
} forEach _skills;
