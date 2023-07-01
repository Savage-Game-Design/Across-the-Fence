/*
    File: fn_terrainIndex_generator_flatEmpty.sqf
    Author:
    Date: 2023-06-30
    Last Update: 2023-06-30
    Public: Yes

    Description:
        Generates an array of points in the given area.
        Only points with enough empty space and on flat enough terrain will be included.

    Parameter(s):
        _x - X coordinate of the bottom left of the area [NUMBER]
        _y - Y coordinate of the bottom left of the area [NUMBER]
        _size - Size of the square area to generator for [NUMBER]
        _params - Parameters accepted by the generator. See code. [HashMap]


    Returns:
        Points that match the given criteria [Array]

    Example(s):
        [1000, 1200, 100, createHashMap] call vgm_s_fnc_terrainIndex_generator_isFlatEmpty;
 */

params ["_x", "_y", "_size", ["_params", createHashMap]];

// Parameters
private _searchGridCellSize = _params getOrDefault ["searchGridCellSize", 5];
private _minimumSpace = _params getOrDefault ["minimumSpace", 4];
private _freeAreaSearchDistance = _params getOrDefault ["freeAreaSearchDistance", 2];
private _maxGradient = _params getOrDefault ["maxGradient", 0.3];
private _gradientArea = _params getOrDefault ["gradientArea", 5];

private _results = [];

private _gridSizeInCells = _size / _searchGridCellSize;

for "_xOffset" from 0 to (_gridSizeInCells - 1) do {
	for "_yOffset" from 0 to (_gridSizeInCells - 1) do {
		private _pos = [_x + (_xOffset * _searchGridCellSize), _y + _yOffset * _searchGridCellSize];

		private _emptyPos = _pos findEmptyPosition [_minimumSpace, _freeAreaSearchDistance];

		if (
			_emptyPos isEqualTo [] ||
			{ _emptyPos isFlatEmpty [-1, -1, _maxGradient, _gradientArea] isEqualTo [] }
		) then { continue; };

		_results pushBack _emptyPos;
	};
};

_results
