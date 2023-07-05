/*
    File: fnc_statusEffect_create.sqf
    Author: Savage Game Design
    Date: 2023-07-02
    Last Update: 2023-07-05
    Public: Yes

    Description:
        Create status effect.
        The effect callback will be applied once first reason is added or last reason is removed.

    Parameter(s):
        _name - Name of the status effect [STRING]
        _fnc_onChange - Function to be called when status effect state changes [CODE]

    Returns:
        Nothing

    Example(s):
        ["forceWalk", {
            params ["_unit", "_inEffect"];
            _unit forceWalk _inEffect;
        }] call vgm_c_fnc_statusEffect_create;
 */

params [
    ["_name", nil, [""]],
    ["_fnc_onChange", nil, [{}]]
];

vgm_c_statusEffect_map set [_name, _fnc_onChange];

nil
