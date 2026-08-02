/*
    File: fn_skills_receiveSkillUnlearn.sqf
    Author: Atlas
    Date: 2026-03-04
    Public: No

    Description:
        Handle receiving skill unlearn response from the server.

    Parameter(s):
        _result          - Was the unlearn successful [BOOL]
        _skillPath       - Path of the skill that was requested to unlearn [ARRAY]
        _removedSkills   - All skill paths that were removed (includes cascaded) [ARRAY]

    Returns:
        Nothing

    Example(s):
        [true, ["combat", "someSkill"], [["combat", "someSkill"]]] remoteExecCall ["vgm_c_fnc_skills_receiveSkillUnlearn", _player];
*/

params ["_result", "_skillPath", "_removedSkills"];

["DEBUG", format ["Received skills unlearn for %1 with result %2, removed %3 skills", _skillPath, _result, count _removedSkills]] call vgm_g_fnc_log;

// Close the popup
uiNamespace setVariable ["BIS_fnc_guiMessage_status", _result];

if (!_result) exitWith {
    hint "Failed to unlearn skill";
};

private _count = count _removedSkills;
if (_count > 1) then {
    hint format ["Unlearned %1 skills (tier cascade)", _count];
} else {
    hint "Skill unlearned";
};
