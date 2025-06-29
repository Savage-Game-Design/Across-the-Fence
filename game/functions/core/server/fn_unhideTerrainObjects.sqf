/*
    File: fn_hideTerrainObjects.sqf
    Author: Savage Game Design
    Date: 2024-10-30
    Last Update: 2025-06-29
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

params [["_hideObjectResult", [], [createHashMap]]];

if (_hideObjectResult isEqualType [] or {!("objects" in _hideObjectResult)}) exitWith {
    ["Invalid parameter passed to unhideTerrainObjects"] call vgm_g_fnc_logError;
    ["ERROR"] call vgm_g_fnc_logStackTrace;
};

{
    _x hideObjectGlobal false;
} forEach (_hideObjectResult get "objects");

