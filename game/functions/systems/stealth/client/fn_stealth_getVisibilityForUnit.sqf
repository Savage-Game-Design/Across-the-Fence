#include "script_component.inc"
/*
    File: fn_stealth_getVisibilityForUnit.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-01-20
    Public: Yes

    Description:
        Checks the visibility of the player's unit from another unit.
        Roughly represents the fraction of the player's entire body the unit can see.

        Main points on the body checked should be:
            - Head, torso, right hand, groin, left shin, right shin.

        Left hand isn't checked because it's usually on the gun - it skews the results.


    Parameter(s):
        _unit - Other unit [UNIT]

    Returns:
        A 2 item array: [ARRAY]
            Visibility between 0 (not visible) and 1 (fully visible) [NUMBER]
            Angle between the unit's line of sight and the player [NUMBER]

    Example(s):
        [allUnits # 0] call vgm_c_fnc_stealth_checkVisibility;
 */

params ["_unit"];

// Returns an absolute angle (i.e positive) between the unit's eye direction and position of the player.
private _angleFromEyeline = acos ((getPosASL _unit vectorFromTo getPosASL player) vectorCos eyeDirection _unit);

// Player isn't in the unit's cone of vision
if !(_angleFromEyeline < VISION_CONE_ANGLE) exitWith {[0, _angleFromEyeline]};

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

[_visibility, _angleFromEyeline]

