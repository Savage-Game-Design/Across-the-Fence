/*
    File: fn_skills_reapply.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-21
    Public: No

    Description:
        Reapplies skills of a type to a player.

    Parameter(s):
        _player [OBJECT] - Player to reapply skills to.

        _type [STRING] - "passive" (default)
                         "primary"
                         "ultimate"

    Returns:
        Nothing

    Example(s):
        [_player] call vgm_s_fnc_skills_reapply;
        [_player, "primary"] call vgm_s_fnc_skills_reapply;
 */

params ["_player", ["_type", "passive"]];

private _skillType = switch (_type) do {
	case "primary": {1};
	case "ultimate": {2};
	default {0};
};

private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skills = _skillsData get "skillPaths";

{
    private _skill = _x call vgm_g_fnc_skills_getByPath;

    if (_skill get "skillType" == _skillType) then {
        _player call (_skill get "codeApply");
    };
} forEach _skills;
