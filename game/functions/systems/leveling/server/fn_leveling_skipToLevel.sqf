/*
    File: fn_leveling_skipToLevel.sqf
    Author: Savage Game Design
    Date: 2025-02-10
    Last Update: 2025-02-13
    Public: Yes

    Description:
        Immediately advances the player to the given level, if they're currently less than that level.

    Parameter(s):
        _player - Player to level up [OBJECT]
        _level - Level to advance them to. [NUMBER]

    Returns:
        XP added [NUMBER]

    Example(s):
        [player, 5] call vgm_s_fnc_leveling_skipToLevel
 */

params ["_player", ["_level", nil, [0]]];

if !(_level in vgm_g_leveling_levelsHashMap) exitWith {};

(format ["Skipping player %1 (%2) to level %3", name _player, getPlayerUID _player, _level]) call vgm_g_fnc_logInfo;

private _levelingData = _player call vgm_s_fnc_leveling_dataGetCached;

private _currentLevel = _levelingData get "level";
if (_level <= _currentLevel) exitWith {};

private _experienceThreshold = vgm_g_leveling_levelsHashMap get (_level - 1) get "experienceThreshold";
private _currentExperience = _levelingData get "experience";
private _toAdd = _experienceThreshold - _currentExperience;

[_player, _toAdd] call vgm_s_fnc_leveling_addExperience;

_toAdd
