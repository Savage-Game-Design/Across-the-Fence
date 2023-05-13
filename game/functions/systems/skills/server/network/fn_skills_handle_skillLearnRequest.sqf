/*
    File: fn_skills_handle_skillLearnRequest.sqf
    Author: Savage Game Design
    Date: 2023-01-27
    Last Update: 2023-05-13
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
    ["ERROR", format ["VGM: Learn request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]] call para_g_fnc_log;
};

private _skill = _skillPath call vgm_g_fnc_skills_getByPath;
private _canLearn = [_player, _skill] call vgm_g_fnc_skills_canLearn;

if (!_canLearn) exitWith {
    ["WARNING", format ["VGM: Discarding learn request for %1 (%2), %3", name _player, getPlayerUID _player, _skillPath]] call para_g_fnc_log;

    // inform the player that he failed to learn the skill
    [_canLearn, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];
};


["INFO", format ["VGM: Handling learn request for %1 (%2), %3", name _player, getPlayerUID _player, _skillPath]] call para_g_fnc_log;

private _skill = _skillPath call vgm_g_fnc_skills_getByPath;
private _skillCost = _skill get "cost";

private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPoints = _skillsData get "skillPoints";
private _skillPointsSpent = _skillsData get "skillPointsSpent";

private _skillTreeName = _skillPath select ((count _skillPath) - 1);
private _skillTreePointsSpent = _skillPointsSpent getOrDefault [_skillTreeName, 0, true];
private _totalSkillPointsSpent = _skillPointsSpent get "totalPointsSpent";

_skillPointsSpent set [_skillTreeName, _skillTreePointsSpent + _skillCost];
_skillPointsSpent set ["totalPointsSpent", _totalSkillPointsSpent + _skillCost];

_skillsData set ["skillPoints", _skillPoints - _skillCost];
_skillsData set ["skillPointsSpent", _skillPointsSpent];

[_player, _skillPath] call vgm_s_fnc_skills_teachSkill;

// inform the player that he succeded to learn the skill
[_canLearn, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];
