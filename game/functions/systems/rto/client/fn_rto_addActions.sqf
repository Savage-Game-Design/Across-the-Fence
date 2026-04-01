/*
    File: fn_rto_addActions.sqf
    Author: Savage Game Design and Ethan Johnson
    Date: 2024-11-09
    Last Update: 2026-03-08
    Public: No

    Description:
        Adds RTO call-in actions to the player.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_rto_addActions;
 */

if ((player getVariable ["vgm_c_rto_actionId", -1]) > -1) exitWith {};
[] call vgm_c_fnc_rto_removeActions;

private _callRtoCondition = "call vgm_g_fnc_rto_getUsableRadioType isNotEqualTo ''";

private _callRtoId = player addAction [
    localize "STR_VN_ARTILLERY_ACTION_NAME",
    {
        [] spawn
        {
            sleep 0.1;
            ["init"] call vgm_c_fnc_displayRadioOperator;
        };
    },
    nil,
    -99,
    false,
    true,
    "",
    _callrtoCondition
];
player setVariable ["vgm_c_rto_actionId", _callRtoId];

private _newRespawnHandler = player addEventHandler ["Respawn", {
    params ["_unit", "_corpse"];
    [] call vgm_c_fnc_rto_addActions;
}];
player setVariable ["vgm_c_rto_respawnHandlerId", _newRespawnHandler];

// Force close the display when the player dies.
private _newKilledHandler = player addEventHandler ["Killed", {
    (uiNamespace getVariable ["VGM_DisplayRadioOperator", displayNull]) closeDisplay 0;

    player removeAction (player getVariable ["vgm_c_rto_actionId", -1]);
    player setVariable ["vgm_c_rto_actionId", -1];
}];
player setVariable ["vgm_c_rto_killedHandlerId",_newKilledHandler];
