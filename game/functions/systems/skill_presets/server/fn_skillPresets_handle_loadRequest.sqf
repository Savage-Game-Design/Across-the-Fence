/*
    File: fn_skillPresets_handle_loadRequest.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Handle client request to load a preset.
        Performs a full respec, then teaches all skills from the preset
        in tier order to satisfy unlock requirements.

    Parameter(s):
        _player - Requesting player [OBJECT]
        _slotIndex - Slot index 0-4 [NUMBER]

    Returns:
        Nothing
*/

params ["_player", "_slotIndex"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Preset load request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

if (_slotIndex < 0 || _slotIndex > 4) exitWith {
    (format ["Invalid preset slot index %1 from %2", _slotIndex, name _player]) call vgm_g_fnc_logError;
};

private _uid = getPlayerUID _player;
private _presets = _uid call vgm_s_fnc_skillPresets_dbGet;
private _presetData = _presets getOrDefault [str _slotIndex, nil];

if (isNil "_presetData") exitWith {
    (format ["Preset load request from %1 but slot %2 is empty", name _player, _slotIndex]) call vgm_g_fnc_logWarning;
};

private _presetSkillPaths = _presetData get "skillPaths";
private _presetName = _presetData get "name";

(format ["Loading preset '%1' (slot %2) for %3 — %4 skills", _presetName, _slotIndex, name _player, count _presetSkillPaths]) call vgm_g_fnc_logInfo;

// Step 1: Full respec — refund all SP and forget all skills
private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPoints = _skillsData get "skillPoints";
private _skillPointsSpent = _skillsData get "skillPointsSpent";

_skillsData set ["skillPoints", _skillPoints + _skillPointsSpent];
_skillsData set ["skillPointsSpent", 0];

[_player, +(_skillsData get "skillPaths")] call vgm_s_fnc_skills_forgetSkills;

// Step 2: Sort preset skills by tier (lower tiers first) to satisfy unlock requirements
private _skillsWithTier = [];
{
    private _skill = _x call vgm_g_fnc_skills_getByPath;
    if (!isNil "_skill") then {
        _skillsWithTier pushBack [_skill getOrDefault ["tier", 0], _x, _skill];
    };
} forEach _presetSkillPaths;

// Sort ascending by tier
_skillsWithTier sort true;

// Step 3: Teach each skill in order
private _learned = 0;
private _failed = 0;
private _totalCost = 0;

{
    _x params ["_tier", "_skillPath", "_skill"];

    private _canLearn = [_player, _skill] call vgm_g_fnc_skills_canLearn;
    if (_canLearn) then {
        private _cost = [_skill, _player] call vgm_g_fnc_skills_getEffectiveCost;

        // Deduct SP
        private _curSP = _skillsData get "skillPoints";
        private _curSpent = _skillsData get "skillPointsSpent";
        _skillsData set ["skillPoints", _curSP - _cost];
        _skillsData set ["skillPointsSpent", _curSpent + _cost];

        // Teach the skill (this also saves to DB and syncs to client)
        [_player, _skillPath] call vgm_s_fnc_skills_teachSkill;

        _learned = _learned + 1;
        _totalCost = _totalCost + _cost;
    } else {
        _failed = _failed + 1;
        (format ["Could not teach skill %1 from preset for %2", _skillPath, name _player]) call vgm_g_fnc_logWarning;
    };
} forEach _skillsWithTier;

// Step 4: Send notification to client
private _msg = if (_failed == 0) then {
    format [localize "STR_VGM_SKILL_PRESETS_LOADED", _learned, _totalCost]
} else {
    format [localize "STR_VGM_SKILL_PRESETS_LOADED_PARTIAL", _learned, count _presetSkillPaths, _failed]
};
[createHashMapFromArray [["title", localize "STR_VGM_SKILL_PRESETS_TITLE"], ["body", _msg]]] remoteExecCall ["vgm_c_fnc_postNotification", _player];

(format ["Preset load complete for %1: %2 learned, %3 failed, %4 SP spent", name _player, _learned, _failed, _totalCost]) call vgm_g_fnc_logInfo;
