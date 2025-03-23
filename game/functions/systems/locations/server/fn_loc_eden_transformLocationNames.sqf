/*
    File: fn_loc_eden_transformLocationNames.sqf
    Author: Savage Game Design
    Date: 2024-11-01
    Last Update: 2024-11-01
    Public: No

    Description:
        Applies a transformation to all location names.

    Parameter(s):
        _entities - 3DEN Entities to apply the transform to, defaults to all locations [ARRAY]
        _transformer - Function that transforms the name [CODE]

    Returns:
        Nothing

    Example(s):
        [nil, {
            params ["_name"];
            toLower _name
        }] call vgm_s_fnc_loc_eden_transformLocationNames.
 */

private _identity = { _this # 0 };

params ["_entities", ["_transformer", _identity]];

if (isNil "_entities") then {
    _entities = [] call vgm_s_fnc_loc_eden_allLocationEntities;
};

{
    private _currentName = _x get3DENAttribute "Name" select 0;
    _x set3DENAttribute ["Name", [_currentName] call _transformer];
} forEach _entities;
