#include "script_component.inc"
/*
    File: fn_sites_hints_glintJob.sqf
    Author: Savage Game Design
    Date: 2024-10-28
    Last Update: 2026-01-04
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

// How long it takes for a full glint animatio to run its course (roughly).
#define GLINT_DURATION 8
#define RADIUS 200
#define OBJECTS_MAX 50

private _radius = RADIUS;

// https://community.bistudio.com/wikidata/images/a/ac/safezone.jpg
private _fnc_isOnScreenCenter = {
    private _objectPos = worldToScreen getPosATL _this;
    _objectPos params [["_x", -1], ["_y", -1]];

    (_x >= 0 && _x <= 1) && (_y >= 0 && _y <= 1)
};

private _fnc_getNearestHint = {
    private _objects = (vgm_sites_hints_objectsList inAreaArray [focusOn, _radius, _radius]) select [0, OBJECTS_MAX];
    private _potentiallyValidObjects = _objects select {
        _x call _fnc_isOnScreenCenter
        && !(_x getVariable ["vgm_sites_hints_inspected", false])
    };

    private _sorted = _potentiallyValidObjects apply {[_x distance focusOn, _x]};
    private _hintIndex = _sorted findIf {
        private _obj = _x # 1;
        [focusOn, "FIRE", _obj] checkVisibility [eyePos focusOn, getPosWorld _obj] > 0
    };

    if (_hintIndex < 0) exitWith { nil };
    _sorted # _hintIndex # 1;
};

private _glintObject = call _fnc_getNearestHint;
if (isNil "_glintObject") exitWith {
    ["No glint objects around"] call vgm_g_fnc_logDebug;
};

private _glintObjectDistance = focusOn distance _glintObject;
private _intervalMax = linearConversion [0, 75, _glintObjectDistance, GLINT_JOB_NEARBY_INTERVAL_MAX, GLINT_JOB_INTERVAL_MAX];
private _intervalMin = linearConversion [0, 75, _glintObjectDistance, GLINT_JOB_NEARBY_INTERVAL_MIN, GLINT_JOB_INTERVAL_MIN];
private _interval = linearConversion [0, 1, vgm_c_skill_investigate_intensity, _intervalMax, _intervalMin];

// Must be at least GLINT_DURATION to avoid playing several glints at once.
_interval = (_interval * ([focusOn, "glintFrequency"] call vgm_c_fnc_coefficient_get)) max GLINT_DURATION;

if ((time - vgm_c_sites_hints_lastGlint) < _interval) exitWith {};

vgm_c_sites_hints_lastGlint = time;

["Playing glint animation"] call vgm_g_fnc_logDebug;
[_glintObject, 3] call vgm_c_fnc_sites_hints_glint;
