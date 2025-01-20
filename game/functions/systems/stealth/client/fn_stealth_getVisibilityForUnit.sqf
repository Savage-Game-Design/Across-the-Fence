/*
    File: fn_stealth_getVisibilityForUnit.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-01-20
    Public: Yes

    Description:
        Checks the visibility of the player's unit from another unit.

    Parameter(s):
        _unit - Other unit [UNIT]

    Returns:
        Visibility between 0 (not visible) and 1 (fully visible) [NUMBER]

    Example(s):
        [allUnits # 0] call vgm_c_fnc_stealth_checkVisibility;
 */

// Human cone of vision is roughly 135 degrees - the values below match that.
#define VISION_CONE_ANGLE 45

params ["_unit"];

// Returns an absolute angle (i.e positive) between the unit's eye direction and position of the player.
private _angleFromEyeline = acos ((getPosASL _unit vectorFromTo getPosASL player) vectorCos eyeDirection _unit);

// Player isn't in the unit's cone of vision
if !(_angleFromEyeline < VISION_CONE_ANGLE) exitWith {0};

// These selections seem to give a good balance when in bushes, peeking behind trees, etc.
private _selections = ["righthand", "pelvis", "leftlegroll", "rightlegroll"];
private _positions = [aimPos player, eyePos player] + (_selections apply {player modelToWorldWorld (player selectionPosition _x)});
// Track hidden points - a line intersection means that something was hit *before* the player was.
private _totalHiddenPoints = 0;
{
	_totalHiddenPoints = _totalHiddenPoints + count (lineIntersectsSurfaces [eyePos _unit, _x, _unit, player, true, 1, "VIEW"]);
} forEach _positions;

// Take the average (efficiently).
// Convert hidden positions to visible positions for the calculation.
private _visibility = (count _positions - _totalHiddenPoints) / count _positions;

private _peripheralAdjustmentFactor = linearConversion [0, VISION_CONE_ANGLE, _angleFromEyeline, 1, 0.5, true];

// Adjust for the player being prone / crouched, and therefore having a smaller cross section.
_visibility * (vgm_c_stealth_stanceMultipliers get stance player) * _peripheralAdjustmentFactor;
