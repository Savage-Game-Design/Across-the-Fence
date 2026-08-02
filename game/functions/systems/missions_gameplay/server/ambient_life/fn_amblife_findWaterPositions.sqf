/*
    File: fn_amblife_findWaterPositions.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Grid-scans the target box at 100m intervals to find water positions.

    Parameter(s):
        _boxCenter   - Center of the target box [ARRAY]
        _boxApothems - [halfWidth, halfHeight] of the target box [ARRAY]

    Returns:
        Array of water positions [ARRAY of Position3D]

    Example(s):
        [_center, _apothems] call vgm_s_fnc_amblife_findWaterPositions;
 */

params ["_boxCenter", "_boxApothems"];

private _waterPositions = [];
private _spacing = 100;

private _startX = (_boxCenter # 0) - (_boxApothems # 0);
private _startY = (_boxCenter # 1) - (_boxApothems # 1);
private _endX = (_boxCenter # 0) + (_boxApothems # 0);
private _endY = (_boxCenter # 1) + (_boxApothems # 1);

private _x = _startX;
while {_x <= _endX} do {
    private _y = _startY;
    while {_y <= _endY} do {
        private _pos = [_x, _y, 0];
        if (surfaceIsWater _pos) then {
            _waterPositions pushBack _pos;
        };
        _y = _y + _spacing;
    };
    _x = _x + _spacing;
};

_waterPositions
