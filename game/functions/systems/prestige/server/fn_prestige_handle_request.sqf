/*
    File: fn_prestige_handle_request.sqf
    Author: Atlas
    Date: 2026-03-05
    Public: No

    Description:
        Handle client prestige request. Verifies player is at max level,
        increments prestige counter, resets level to 0 (will be bumped to 1),
        resets all skills. Arsenal cosmetics are untouched.

    Parameter(s):
        _player - Player requesting prestige [OBJECT]

    Returns:
        Nothing

    Example(s):
        [player] remoteExecCall ["vgm_s_fnc_prestige_handle_request", 2]
 */

params ["_player"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Prestige request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

// Validate: player must be at max level
private _levelingData = _player call vgm_s_fnc_leveling_dataGetCached;
private _currentLevel = _levelingData get "level";

if (_currentLevel < vgm_g_leveling_maxLvl) exitWith {
    (format ["Prestige denied for %1 — level %2 < %3", name _player, _currentLevel, vgm_g_leveling_maxLvl]) call vgm_g_fnc_logWarning;
};

// Increment prestige
private _prestige = _levelingData getOrDefault ["prestige", 0];
_prestige = _prestige + 1;
_levelingData set ["prestige", _prestige];

(format ["Prestige %3 granted to %1 (%2)", name _player, getPlayerUID _player, _prestige]) call vgm_g_fnc_logInfo;

// Reset level and experience to 0 (addExperience with 0 will bump to level 1)
_levelingData set ["level", 0];
_levelingData set ["experience", 0];

// Save leveling data
[_player] call vgm_s_fnc_leveling_dbSave;

// Reset skills: set SP to 0 first, then forget all skills (forgetSkills saves + broadcasts)
// Level-up from 0->1 will grant initial SP via the leveling event
private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
_skillsData set ["skillPoints", 0];
_skillsData set ["skillPointsSpent", 0];
[_player, +(_skillsData get "skillPaths")] call vgm_s_fnc_skills_forgetSkills;

// Trigger level-up from 0 to 1 (awards initial 3 SP, broadcasts data)
[_player, 0] call vgm_s_fnc_leveling_addExperience;

// Notify client: dismiss waiting dialog and restore cosmetic loadout
[] remoteExecCall ["vgm_c_fnc_prestige_receivePrestige", _player];
