/*
    File: fn_artillery_addActions.sqf
    Author: Savage Game Design and Ethan Johnson
    Date: 2024-11-09
    Last Update: 2024-11-09
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

private _callArtilleryCondition = "count (missionNamespace getVariable ['vn_artillery_config_array',[]]) > 0 && {call vn_fnc_artillery_radio}";

private _callArtilleryId = player addAction
[
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

private _respawnHandler = player getVariable ["vgm_c_artillery_respawnHandlerId", -1];
if (_respawnHandler <= -1) then
{
    private _newRespawnHandler = player addEventHandler ["Respawn",
    {
        params ["_unit", "_corpse"];
        [_corpse] call vgm_c_fnc_artillery_removeActions;
        [] call vgm_c_fnc_artillery_addActions;
    }];
    player setVariable ["vgm_c_artillery_respawnHandlerId", _newRespawnHandler];
};

private _killedHandler = player getVariable ["vgm_c_artillery_killedHandlerId",-1];
if (_killedHandler <= -1) then
{
    // Force close the display when the player dies.
    private _newKilledHandler = player addEventHandler ["Killed",
    {
        (uiNamespace getVariable ["vn_artillery_display",displayNull]) closeDisplay 0;
    }];
    player setVariable ["vgm_c_artillery_killedHandlerId",_newKilledHandler];
};
