/*
    File: fn_squad_ui_drawPlayersOnMapEventHandler.sqf
    Author: Savage Game Design
    Date: 2024-11-06
    Last Update: 2024-11-30
    Public: No

    Description:
        Attach this to a map control's `Draw` event to enable drawing players on the map.

    Parameter(s):
        _ctrlMap - Map control to draw on [CONTROL]

    Returns:
        Nothing

    Example(s):
        _ctrlMap addEventHandler ["Draw", vgm_c_fnc_squad_ui_drawPlayersOnMapEventHander];
 */

#define FONT_SIZE 0.042

params ["_ctrlMap"];

private _leader = leader player;
private _units = if (vgm_squad_ui_mapDrawEveryone) then {units player} else {[_leader]};

{
    _ctrlMap drawIcon [
        ["iconMan", "iconManLeader"] select (_x isEqualTo _leader),
        vgm_squad_ui_playerColor,
        getPosASLVisual _x,
        24,
        24,
        getDirVisual _x,
        name _x,
        1, // shadow
        [FONT_SIZE, 0] select (ctrlMapScale _ctrlMap > 0.01)
    ];
} forEach _units;

