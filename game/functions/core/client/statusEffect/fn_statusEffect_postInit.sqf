/*
    File: fn_statusEffect_preInit.sqf
    Author: Savage Game Design
    Date: 2024-12-07
    Last Update: 2025-11-29
    Public: No

    Description:
        Status effect client postInit.
 */

if (!hasInterface) exitWith {};

private _fnc_setCoreStatusEffects = {
    [player, "explosiveSpecialist", "core"] call vgm_c_fnc_statusEffect_set;
};

call _fnc_setCoreStatusEffects;
player addEventHandler ["Respawn", _fnc_setCoreStatusEffects];

vgm_c_statusEffect_eachFrameEH = addMissionEventHandler ["EachFrame", {
    // Queue of end times for status effect reasons, sorted by end time.
    private _endTimesQueue = player getVariable ["vgm_c_statusEffect_endTimesQueue", []];
    if (_endTimesQueue isEqualTo []) exitWith {};

    // First item in the queue will always be the soonest.
    _endTimesQueue # 0 params ["_nextEndTime", "_effectDetails"];

    if (time < _nextEndTime) exitWith {};

    _endTimesQueue deleteAt 0;
    _effectDetails params ["_effect", "_reason"];

    private _endTimes = player getVariable "vgm_c_statusEffect_endTimes";
    private _reasonEndTime = _endTimes getOrDefault [_effect, createHashmap] getOrDefault [_reason, -1];

    // Sanity check - if a new status effect duration has been set, the old queue entry will be invalid.
    // As endTimes tracks the latest end time set - we can use that to see if it has changed.
    if (_reasonEndTime isNotEqualTo _nextEndTime) exitWith {};

    [player, _effect, _reason] call vgm_c_fnc_statusEffect_remove;
}];
