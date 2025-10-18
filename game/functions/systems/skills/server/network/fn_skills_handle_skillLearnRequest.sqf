/*
    File: fn_skills_handle_skillLearnRequest.sqf
    Author: Savage Game Design
    Date: 2023-01-27
    Last Update: 2025-10-18
    Public: No

    Description:
        Handle client skill learn request.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

params ["_player", "_skillPath"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Learn request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

private _skill = _skillPath call vgm_g_fnc_skills_getByPath;
([_player, _skill] call vgm_g_fnc_skills_canLearnWithReason) params ["_canLearn", "_canNotLearnReason"];

if (!_canLearn) exitWith {
    (format ["Discarding learn request for %1 (%2), %3, %4", name _player, getPlayerUID _player, _skillPath, _canNotLearnReason]) call vgm_g_fnc_logWarning;

    // inform the player that he failed to learn the skill
    [_canLearn, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];
};


(format ["Handling learn request for %1 (%2), %3", name _player, getPlayerUID _player, _skillPath]) call vgm_g_fnc_logInfo;

private _skill = _skillPath call vgm_g_fnc_skills_getByPath;
private _skillCost = _skill get "cost";


private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPoints = _skillsData get "skillPoints";
private _skillPointsSpent = _skillsData get "skillPointsSpent";

_skillsData set ["skillPoints", _skillPoints - _skillCost];
_skillsData set ["skillPointsSpent", _skillPointsSpent + _skillCost];

[_player, _skillPath] call vgm_s_fnc_skills_teachSkill;

// inform the player that he succeded to learn the skill
[_canLearn, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];
