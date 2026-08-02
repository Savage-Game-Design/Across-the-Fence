/*
    File: fn_hideTerrainObjects.sqf
    Author: Savage Game Design
    Date: 2024-10-30
    Last Update: 2024-10-30
    Public: Yes

    Description:
        Unhides previously hidden terrain objects.

    Parameter(s):
        _hideObjectResult - Result from calling vgm_s_fnc_hideTerrainObjects [HashMap]

    Returns:
        Nothing

    Example(s):
        private _hideResult = [getPosATL player, 50, ["MISC"]] call vgm_s_fnc_hideTerrainObjects;
        [_hideResult] call vgm_s_fnc_unhideTerrainObjects;
 */

params ["_hideObjectResult"];

private _objects = if (_hideObjectResult isEqualType []) then {
    _hideObjectResult
} else {
    _hideObjectResult getOrDefault ["objects", []]
};

{
    _x hideObjectGlobal false;
} forEach _objects;

