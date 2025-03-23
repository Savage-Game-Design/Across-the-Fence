/*
    File: fn_nearestPointOnLine.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2024-12-06
    Public: Yes

    Description:
        Returns the point on the line closest to the given position, or an empty array if no valid point on the line could be found.

        Works with vector 3D or vector 2D.

        Must use ASL for the maths to work correctly.

    Parameter(s):
        _queryPosition - Position to find the nearest point to [PosASL]
        _lineStart - Start position of the line [PosASL]
        _lineVector - Vector for the line. This should *not* be a unit vector, its magnitude should be the length of the line. [Vector]
        _isInfinite - If the line should be considered as infinitely long (in both directions) [BOOL]

    Returns:
        Nearest point on the line in PosASL, or [] [ARRAY]

    Example(s):
        // An over-engineered way of finding the player's Y coordinate.
        // Finds the nearest point on a 20km long line along the Y axis, starting at the origin.
        [getPosASL player, [0,0,0], [0, 20000, 0]] call vgm_g_fnc_nearestPointOnLine
 */

params ["_queryPosition", "_lineStart", "_lineVector", ["_isInfinite", false]];

private _lineLengthSqr = vectorMagnitudeSqr _lineVector;
private _queryVector = _queryPosition vectorDiff _lineStart;
private _unitVector = vectorNormalized _lineVector;
private _delta = _queryVector vectorDotProduct _unitVector;

if (_isInfinite or (_delta > 0 and (_delta * _delta) < _lineLengthSqr)) exitWith {
    _lineStart vectorAdd (_unitVector vectorMultiply _delta)
};

[]
