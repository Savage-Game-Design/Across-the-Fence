/*
    File: fn_skills_handle_skillLearnRequest.sqf
    Author: Savage Game Design
    Date: 2023-01-27
    Last Update: 2023-05-13
    Public: No

    Description:
        Handle client skill respec request. Clears all known skills and refunds the skill points

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

params ["_player"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    ["ERROR", format ["VGM: Respec request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]] call para_g_fnc_log;
};

["INFO", format ["VGM: Handling respec request for %1 (%2)", name _player, getPlayerUID _player]] call para_g_fnc_log;

private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPoints = _skillsData get "skillPoints";
private _skillPointsSpent = _skillsData get "skillPointsSpent";

private _totalSkillPointsSpent = _skillPointsSpent get "totalPointsSpent";
private _newPointHashMap = createHashMap;
_newPointHashMap set ["totalPointsSpent", 0, true];

_skillsData set ["skillPoints", _skillPoints + _totalSkillPointsSpent];
_skillsData set ["skillPointsSpent", _newPointHashMap];

[_player, +(_skillsData get "skillPaths")] call vgm_s_fnc_skills_forgetSkills;

// inform the player that respec succeded
[] remoteExecCall ["vgm_c_fnc_skills_receiveSkillRespec", _player];
