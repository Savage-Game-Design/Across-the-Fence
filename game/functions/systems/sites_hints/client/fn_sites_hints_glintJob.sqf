#include "script_component.inc"
/*
    File: fn_sites_hints_glintJob.sqf
    Author: Savage Game Design
    Date: 2024-10-28
    Last Update: 2024-11-29
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

private _intensity = missionNamespace getVariable ["vgm_c_skill_investigate_intensity", 0];
private _interval = linearConversion [0, 1, _intensity, GLINT_JOB_INT_MAX, GLINT_JOB_INT_MIN];
private _radius = RADIUS;

_interval = _interval * ([focusOn, "glintFrequency"] call vgm_c_fnc_coefficient_get);

if ((time - vgm_c_sites_hints_lastGlint) < _interval) exitWith {};
vgm_c_sites_hints_lastGlint = time;

["Playing glint animation"] call vgm_g_fnc_logDebug;

private _fnc_getNearbyHints = {
    private _objects = (vgm_sites_hints_objectsList inAreaArray [focusOn, _radius, _radius]) select [0, OBJECTS_MAX];

    _objects select {
        worldToScreen getPosATL _x isNotEqualTo []
        && {[focusOn, "FIRE", _x] checkVisibility [eyePos focusOn, getPosWorld _x] > 0}
    };
};

private _glintObject = selectRandom call _fnc_getNearbyHints;
if (isNil "_glintObject") exitWith {
    ["No glint objects around"] call vgm_g_fnc_logDebug;
};

[_glintObject, 2] call vgm_c_fnc_sites_hints_glint;
