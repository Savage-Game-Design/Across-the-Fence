/*
    File: fn_skills_handle_skillLearnRequest.sqf
    Author: Savage Game Design
    Date: 2023-01-27
    Last Update: 2025-06-28
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
    (format ["Respec request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

(format ["Handling respec request for %1 (%2)", name _player, getPlayerUID _player]) call vgm_g_fnc_logInfo;

private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPoints = _skillsData get "skillPoints";
private _skillPointsSpent = _skillsData get "skillPointsSpent";

private _level = [_player] call vgm_s_fnc_leveling_dataGetCached get "level";

_skillsData set ["skillPoints", _skillPoints + _skillPointsSpent];
_skillsData set ["skillPointsSpent", 0];

[_player, +(_skillsData get "skillPaths")] call vgm_s_fnc_skills_forgetSkills;

// inform the player that respec succeded
[] remoteExecCall ["vgm_c_fnc_skills_receiveSkillRespec", _player];
