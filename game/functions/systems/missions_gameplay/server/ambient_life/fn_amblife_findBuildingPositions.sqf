/*
    File: fn_amblife_findBuildingPositions.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Finds building positions within the target box.

    Parameter(s):
        _boxCenter   - Center of the target box [ARRAY]
        _boxApothems - [halfWidth, halfHeight] of the target box [ARRAY]

    Returns:
        Array of building positions [ARRAY of Position3D]

    Example(s):
        [_center, _apothems] call vgm_s_fnc_amblife_findBuildingPositions;
 */

params ["_boxCenter", "_boxApothems"];

private _searchRadius = (_boxApothems # 0) max (_boxApothems # 1);
private _buildings = nearestObjects [_boxCenter, ["House"], _searchRadius];

// Filter buildings to those within the box bounds
private _minX = (_boxCenter # 0) - (_boxApothems # 0);
private _maxX = (_boxCenter # 0) + (_boxApothems # 0);
private _minY = (_boxCenter # 1) - (_boxApothems # 1);
private _maxY = (_boxCenter # 1) + (_boxApothems # 1);

private _buildingPositions = [];
{
    private _pos = getPos _x;
    if ((_pos # 0) >= _minX && (_pos # 0) <= _maxX &&
        (_pos # 1) >= _minY && (_pos # 1) <= _maxY) then {
        _buildingPositions pushBack _pos;
    };
} forEach _buildings;

_buildingPositions
