/*
    File: fn_amblife_findRoadNearPlayer.sqf
    Author: AtlasActual
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Finds a road position near a random player, between spawn and despawn
        range (500-650m), suitable for spawning a new road vehicle that will
        appear just outside immediate view.

    Parameter(s):
        None

    Returns:
        Road position [ARRAY], or [] if none found

    Example(s):
        [] call vgm_s_fnc_amblife_findRoadNearPlayer;
 */

private _players = allPlayers select {alive _x && !isNull _x};
if (count _players == 0) exitWith { [] };

// Try up to 3 random players
for "_attempt" from 1 to 3 do {
    private _player = selectRandom _players;
    private _playerPos = getPosATL _player;

    // Find roads 500-650m from player (just inside spawn range, not visible)
    private _nearRoads = _playerPos nearRoads 650;
    private _validRoads = _nearRoads select {
        (getPos _x) distance2D _playerPos >= 450
    };

    if (count _validRoads > 0) exitWith {
        getPos (selectRandom _validRoads)
    };
};

// Fallback: no suitable road found
[]
