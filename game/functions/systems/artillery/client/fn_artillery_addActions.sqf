/*
    File: fn_artillery_addActions.sqf
    Author: Savage Game Design and Ethan Johnson
    Date: 2024-11-09
    Last Update: 2025-01-17
    Public: No

    Description:
        Adds artillery call-in actions to the player.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_artillery_addActions;
 */

if ((player getVariable ["vgm_c_artillery_actionId", -1]) > -1) exitWith {};
[] call vgm_c_fnc_artillery_removeActions;

private _callArtilleryCondition = "count (missionNamespace getVariable ['vn_artillery_config_array',[]]) > 0 && {call vn_fnc_artillery_radio}";

private _callArtilleryId = player addAction [
    localize "STR_VN_ARTILLERY_ACTION_NAME",
    {
        [] spawn
        {
            sleep 0.1;
            ["init"] call vgm_c_fnc_artillery_menu;
        };
    },
    nil,
    -99,
    false,
    true,
    "",
    _callArtilleryCondition
];
player setVariable ["vgm_c_artillery_actionId", _callArtilleryId];

private _newRespawnHandler = player addEventHandler ["Respawn", {
    params ["_unit", "_corpse"];
    [] call vgm_c_fnc_artillery_addActions;
}];
player setVariable ["vgm_c_artillery_respawnHandlerId", _newRespawnHandler];

// Force close the display when the player dies.
private _newKilledHandler = player addEventHandler ["Killed", {
    (uiNamespace getVariable ["vn_artillery_display",displayNull]) closeDisplay 0;

    player removeAction (player getVariable ["vgm_c_artillery_actionId", -1]);
    player setVariable ["vgm_c_artillery_actionId", -1];
}];
player setVariable ["vgm_c_artillery_killedHandlerId",_newKilledHandler];
