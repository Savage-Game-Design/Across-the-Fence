/*
    File: fn_respawn_addHoldAction.sqf
    Author: Savage Game Design
    Date: 2025-03-01
    Last Update: 2025-03-05
    Public: No

    Description:
        Adds the respawn hold action to the player.

    Parameter(s):
        _player - Player to add it to, defaults to `player` [UNIT]

    Returns:
        Action ID added

    Example(s):
        [] call vgm_c_fnc_respawn_addHoldAction;
 */

#define HOLD_ACTION_VAR "vgm_c_respawn_holdActionId"

params [["_player", player]];

private _existingActionId = _player getVariable [HOLD_ACTION_VAR, -1];
if (_existingActionId > -1) then {
    [_player, _existingActionId] call BIS_fnc_holdActionRemove;
};

// Call vgm_g_fnc_respawn_remainingRespawns only if needed, as it's computed dynamically.
private _condition = toString {[_target] call vgm_g_fnc_medical_isUnconscious && { [_target] call vgm_g_fnc_respawn_remainingRespawns > 0 }};

private _holdActionId = [
    _player,
    localize "STR_VGM_RESPAWN_ACTION",
    "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_unbind_ca.paa",
    "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_unbind_ca.paa",
    // Condition to show
    _condition,
    // Condition to progress
    _condition,
    // On start
    {},
    // On progress
    {},
    // On completed
    {
        params ["_target"];
        format ["Player has triggered a respawn"] call vgm_g_fnc_logInfo;
        forceRespawn _target;
    },
    // On interrupted
    {},
    ["_arguments",[],[[]]],
    // Duration
    3,
    // Priority
    9999,
    // Remove when completed - we do this manually, to be sure it triggered correctly.
    false,
    // Show when unconscious
    true,
    // Show in window
    true
] call vn_fnc_holdActionAdd;


_player setVariable [HOLD_ACTION_VAR, _holdActionId];

_holdActionId
