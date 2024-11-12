/*
    File: fn_sites_hints_glintJob.sqf
    Author: Savage Game Design
    Date: 2024-10-28
    Last Update: 2024-11-12
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

#define RADIUS 200
#define OBJECTS_MAX 50

["Playing glint animation"] call vgm_g_fnc_logDebug;

private _fnc_getNearbyHints = {
    private _objects = (vgm_sites_hints_objectsList inAreaArray [player, RADIUS, RADIUS]) select [0, OBJECTS_MAX];

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
