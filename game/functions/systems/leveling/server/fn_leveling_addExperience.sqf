/*
    File: fn_leveling_addExperience.sqf
    Author: Savage Game Design
    Date: 2023-06-01
    Last Update: 2024-02-10
    Public: No

    Description:
        Give experiene to the player and publish the leveling data.

    Parameter(s):
        _player - Player to give the XP to [OBJECT]
        _experience - Amount of XP to be gained, use 0 to broadcast leveling data [NUMBER]

    Returns:
        XP was added [BOOL]

    Example(s):
        [player, 300] call vgm_s_fnc_leveling_addExperience
 */

params ["_player", "_experience"];

(format ["Adding %3 XP to %1 (%2)", name _player, getPlayerUID _player, _experience]) call vgm_g_fnc_logInfo;

private _levelingData = _player call vgm_s_fnc_leveling_dataGetCached;
private _currentLevel = _levelingData get "level";
// early exit if already at max level (ignore if adding 0 xp as that's used for data broadcast)
if (_currentLevel >= vgm_g_leveling_maxLvl && {_experience > 0}) exitWith {
    (format ["Player at max level %1 (%2)", name _player, getPlayerUID _player, _experience]) call vgm_g_fnc_logInfo;
    false
};

private _currentExperience = _levelingData get "experience";

// award the gained XP
_currentExperience = _currentExperience + _experience;
// clamp XP to the amount needed to reach max level
_currentExperience = _currentExperience min vgm_g_leveling_maxExperience;

_levelingData set ["experience", _currentExperience];

private _currentLevelData = vgm_g_leveling_levelsHashMap get _currentLevel;

while {_currentExperience >= (_currentLevelData get "experienceThreshold")} do {
    // advance to next level
    _currentLevel = _currentLevel + 1;
    (format ["Level %3 gained by %1 (%2)", name _player, getPlayerUID _player, _currentLevel]) call vgm_g_fnc_logInfo;

    _currentLevelData = vgm_g_leveling_levelsHashMap get _currentLevel;
    _levelingData set ["level", _currentLevel];

    ["vgm_leveling_levelGained", [_player, _currentLevelData]] call para_g_fnc_event_triggerGlobal;
};

[_player, _levelingData] call vgm_s_fnc_leveling_dbSave;

["vgm_leveling_updateData", _levelingData, _player] call para_g_fnc_event_triggerTargets;

true
