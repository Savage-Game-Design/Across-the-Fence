#include "script_component.inc"
/*
    File: fn_sites_hints_glintJob.sqf
    Author: Savage Game Design
    Date: 2024-10-28
    Last Update: 2024-12-16
    Public: No

    Description:
        Periodically checks for nearby hint objects to play glint animation on them.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_sites_hints_glintJob;
 */

#define RADIUS 200
#define OBJECTS_MAX 50

private _interval = linearConversion [0, 1, vgm_c_skill_investigate_intensity, GLINT_JOB_INT_MAX, GLINT_JOB_INT_MIN];
private _radius = RADIUS;

_interval = _interval * ([focusOn, "glintFrequency"] call vgm_c_fnc_coefficient_get);

if ((time - vgm_c_sites_hints_lastGlint) < _interval) exitWith {};
vgm_c_sites_hints_lastGlint = time;

["Playing glint animation"] call vgm_g_fnc_logDebug;

// https://community.bistudio.com/wikidata/images/a/ac/safezone.jpg
private _fnc_isOnScreenCenter = {
    private _objectPos = worldToScreen getPosATL _this;
    _objectPos params [["_x", -1], ["_y", -1]];

    (_x >= 0 && _x <= 1) && (_y >= 0 && _y <= 1)
};

private _fnc_getNearbyHints = {
    private _objects = (vgm_sites_hints_objectsList inAreaArray [focusOn, _radius, _radius]) select [0, OBJECTS_MAX];

    _objects select {
        _x call _fnc_isOnScreenCenter
        && {[focusOn, "FIRE", _x] checkVisibility [eyePos focusOn, getPosWorld _x] > 0}
    };
};

// sort by nearest object
private _nearbyHints = call _fnc_getNearbyHints apply {[_x distance focusOn, _x]};
_nearbyHints sort true;

private _glintObject = _nearbyHints select 0 select 1;
if (isNil "_glintObject") exitWith {
    ["No glint objects around"] call vgm_g_fnc_logDebug;
};

[_glintObject, 3] call vgm_c_fnc_sites_hints_glint;
