/*
    File: fn_sites_hints_addInspectAction.sqf
    Author: Savage Game Design
    Date: 2025-01-09
    Last Update: 2025-08-18
    Public: No

    Description:
        Add hint object inspect action to player.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_sites_hints_inspectInit
 */

#define DETECT_RADIUS 1.7

vgm_sites_hints_actionCheckTime = 0;

private _fnc_inspect = {
    private _nearHints = [getPosATL player, DETECT_RADIUS] call vgm_c_fnc_sites_hints_getHintsInRange;
    private _object = _nearHints select -1;
    if (isNil "_object") exitWith {};

    [_object] call vgm_c_fnc_sites_hints_inspect;
};

// checks for hints near the player and renders 3d icon for them
private _fnc_checkForHints = {
    if (time < vgm_sites_hints_actionCheckTime) exitWith {false};
    vgm_sites_hints_actionCheckTime = time + 1.5;

    private _nearHints = [getPosATL player, DETECT_RADIUS] call vgm_c_fnc_sites_hints_getHintsInRange;
    {
        // force to run the code each frame until no hint objects around
        vgm_sites_hints_actionCheckTime = -1;
        private _pos = ASLToAGL getPosASL _x;
        drawIcon3D [
            "\a3\ui_f\data\IGUI\Cfg\Cursors\selectOver_ca.paa",
            [1,1,1,0.45],
            _pos,
            0.8,
            0.8,
            0
        ];

        private _objectPos = worldToScreen _pos;
        _objectPos params [["_x", -1], ["_y", -1]];

        // 0.5, 0.5 is center
        (_x >= 0.3 && _x <= 0.7) && (_y >= 0.3 && _y <= 0.7) // return
    } count _nearHints > 0 // return, shows the action if any object near
};

private _actionId = player addAction [
    localize "STR_VGM_SITES_HINTS_INSPECT_ACTION",
    _fnc_inspect,
    nil,
    1e38,
    true,
    true,
    "",
    toString _fnc_checkForHints,
    0.1
];
player setVariable ["vgm_sites_hints_inspectActionId", _actionId];
