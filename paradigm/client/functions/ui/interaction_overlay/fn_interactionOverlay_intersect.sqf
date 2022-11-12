/*
 *   File: fn_interactionOverlay_intersect.sqf
 *   Function: 
 *   Created: Heyoxe (https://github.com/Heyoxe/), 08.10.2020
 *   Updated: Heyoxe (https://github.com/Heyoxe/), 08.10.2020
 *   Public: No
 *   
 *   Description:
 *   	No description added yet.
 *   
 *   Environment: Unscheduled
 *   Parameters:
 *      0 - _variableName: <TYPE> (default: 0) Parameter description.
 *   
 *   Returns:
 *      <TYPE> Return description.
 *   
 *   Examples: none
 */

// private _end = screenToWorld [0.5,0.5];
private _range = 4;
private _end = if (cameraView isEqualTo "Internal") then {
	positionCameraToWorld [0, 0, _range];
} else {
	positionCameraToWorld [0, 0, _range + 2.5];
};

private _surfaces = lineIntersectsSurfaces [
	eyePos player,
	AGLtoASL _end,
	player,
	objNull,
	true,
	1,
	"GEOM",
	"VIEW",
	true
];
if ((count _surfaces) isEqualTo 0) exitWith { objNull };
private _return = _surfaces#0#3;
_return;