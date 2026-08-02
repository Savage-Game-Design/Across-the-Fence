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

// How long it takes for a full glint animation to run its course (roughly).
#define GLINT_DURATION 8
#define RADIUS 200
#define CANDIDATES_MAX 15

// Glints only appear when player is actively focusing (key T), unless they have the ground_sign trait
if (!vgm_c_skill_investigate_isFocusing && {!(player getUnitTrait "vgm_skill_alwaysSeeGlints")}) exitWith {};

private _radius = RADIUS;

// https://community.bistudio.com/wikidata/images/a/ac/safezone.jpg
private _fnc_isOnScreenCenter = {
    private _objectPos = worldToScreen getPosATL _this;
    _objectPos params [["_x", -1], ["_y", -1]];

    (_x >= 0 && _x <= 1) && (_y >= 0 && _y <= 1)
};

// Get nearby uninspected objects, sorted by distance (cheapest checks first)
private _candidates = (vgm_sites_hints_objectsList inAreaArray [focusOn, _radius, _radius])
    select {!(_x getVariable ["vgm_sites_hints_inspected", false])};
_candidates = _candidates apply {[_x distance focusOn, _x]};
_candidates sort true;
_candidates = _candidates select [0, CANDIDATES_MAX];

// Find the nearest on-screen, visible object (expensive checkVisibility only as needed)
private _glintObject = objNull;
private _eyePos = eyePos focusOn;
{
    private _obj = _x # 1;
    if (_obj call _fnc_isOnScreenCenter
        && {[focusOn, "FIRE", _obj] checkVisibility [_eyePos, getPosWorld _obj] > 0}) exitWith {
        _glintObject = _obj;
    };
} forEach _candidates;

if (isNull _glintObject) exitWith {};

private _glintObjectDistance = focusOn distance _glintObject;
private _intervalMax = linearConversion [0, 75, _glintObjectDistance, GLINT_JOB_NEARBY_INTERVAL_MAX, GLINT_JOB_INTERVAL_MAX];
private _intervalMin = linearConversion [0, 75, _glintObjectDistance, GLINT_JOB_NEARBY_INTERVAL_MIN, GLINT_JOB_INTERVAL_MIN];
private _interval = linearConversion [0, 1, vgm_c_skill_investigate_intensity, _intervalMax, _intervalMin];

// Must be at least GLINT_DURATION to avoid playing several glints at once.
_interval = (_interval * ([focusOn, "glintFrequency"] call vgm_c_fnc_coefficient_get)) max GLINT_DURATION;

if ((time - vgm_c_sites_hints_lastGlint) < _interval) exitWith {};

vgm_c_sites_hints_lastGlint = time;

private _color = _glintObject getVariable ["vgm_sites_hints_glintColor", [1, 1, 1, 0.5]];
private _dist = _glintObject distance focusOn;
private _iters = if (_dist < 15) then {5} else {if (_dist < 50) then {3} else {2}};
[_glintObject, _iters, _color] call vgm_c_fnc_sites_hints_glint;
