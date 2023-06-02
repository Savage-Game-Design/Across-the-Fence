/*
    File: fn_leveling_addExperience.sqf
    Author: Savage Game Design
    Date: 2023-06-01
    Last Update: 2023-06-02
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [player, 300] call vgm_s_fnc_leveling_addExperience
 */

params ["_player", "_experience"];

(format ["Adding %3 XP to %1 (%2)", name _player, getPlayerUID _player, _experience]) call vgm_g_fnc_logInfo;

private _levelingData = _player call vgm_s_fnc_leveling_dataGetCached;
private _currentLevel = _levelingData get "level";
private _currentExperience = _levelingData get "experience";

_currentExperience = _currentExperience + _experience;
_levelingData set ["experience", _currentExperience];

private _currentLevelData = vgm_g_leveling_levelsHashMap get _currentLevel;

while {_currentExperience >= (_currentLevelData get "experience")} do {
    // advance to next level
    _currentLevel = _currentLevel + 1;
    (format ["Level %3 gained by %1 (%2)", name _player, getPlayerUID _player, _currentLevel]) call vgm_g_fnc_logInfo;

    _currentLevelData = vgm_g_leveling_levelsHashMap get _currentLevel;
    _levelingData set ["level", _currentLevel];

    ["vgm_leveling_levelGained", [_player, _currentLevelData]] call para_g_fnc_event_triggerLocal;
};

[_player, _levelingData] call vgm_s_fnc_leveling_dbSave;

["vgm_leveling_updateData", _levelingData, _player] call para_g_fnc_event_triggerTargets;
