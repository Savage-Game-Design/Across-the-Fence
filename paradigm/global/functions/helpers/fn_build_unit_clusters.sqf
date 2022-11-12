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

private _clusters = [];

while {!(_units isEqualTo [])} do {
    private _cluster = [selectRandom _units];
    {
        private _newUnits = (_units inAreaArray [getPos _x, _distance, _distance, 0]) - _cluster;
        _cluster append _newUnits;
    } forEach _cluster;

    _units = _units - _cluster;
    _clusters pushBack _cluster;
};

_clusters
