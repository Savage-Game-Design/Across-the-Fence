/*
    File: fn_radioJamming_isPlayerJammed.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: Yes

    Description:
        Client-side helper that checks whether the local player is inside
        any active radio jammer's radius.

    Parameter(s):
        None (uses player context)

    Returns:
        Distance to nearest jammer in meters, or -1 if not jammed [NUMBER]

    Example(s):
        private _jamDist = call vgm_c_fnc_radioJamming_isPlayerJammed;
        if (_jamDist >= 0) then { hint "Jammed!" };
*/

private _jammers = missionNamespace getVariable ["vgm_s_radioJammer_sites", []];
private _nearestDist = -1;

{
    private _jammerObj = _x get "object";
    if (!isNull _jammerObj && {alive _jammerObj}) then {
        private _dist = player distance2D (_x get "pos");
        if (_dist < (_x get "radius")) then {
            if (_nearestDist < 0 || {_dist < _nearestDist}) then {
                _nearestDist = _dist;
            };
        };
    };
} forEach _jammers;

_nearestDist
