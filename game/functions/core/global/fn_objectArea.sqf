/*
    File: fn_objectArea.sqf
    Author: Savage Game Design
    Date: 2024-11-15
    Last Update: 2024-11-15
    Public: Yes

    Description:
        Get area array of an object.

    Parameter(s):
        _object - Object to get the area of [OBJECT]

    Returns:
        Area [ARRAY]

    Example(s):
        vgm_sharedHub_hq_1 call vgm_g_fnc_objectArea
 */

params ["_object"];

private _bb = 0 boundingBoxReal _object;

_bb#0 params ["_a0", "_b0"];
_bb#1 params ["_a1", "_b1"];

[_object, (_a1 - _a0)/2, (_b1 - _b0)/2, getDir _object, true] // return
