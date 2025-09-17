/*
    File: fn_build_unit_clusters.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Builds clusters of units according to a given distance between them.
        Expensive right now (a few ms), TODO: Optimise.

    Parameter(s):
        _units - Units to cluster [Array]
        _distance - Distance between units in the same cluster [Number]

    Returns:
        Array of arrays of units - Each cluster [Array]

    Example(s): none
*/

//TODO - Optimise, make less crap (a long line of units can count as a cluster right now, which is obviously dumb)
params ["_units", "_distance"];

private _unitHashes = _units apply {hashValue _x};

private _allUnits = _unitHashes createHashMapFromArray _units;
private _clusters = [];

while {count _allUnits > 0} do {
    // TODO - check if `keys` or `values` is faster
    private _unit = selectRandom values _allUnits;
    _allUnits deleteAt hashValue _unit;
    private _cluster = [_unit];
    private _toSearch = [_unit];
    while {count _toSearch > 0} do {
        private _searchUnit = _toSearch deleteAt 0;
        private _nearbyUnits = values _allUnits inAreaArray [_searchUnit, _distance, _distance];
        {
            _cluster pushBack _x;
            // This ensures they aren't found again by the unit search, preventing loops.
            _allUnits deleteAt hashValue _x;
            _toSearch pushBack _x;
        } forEach _nearbyUnits;
    };
    _clusters pushBack _cluster;
};

_clusters
