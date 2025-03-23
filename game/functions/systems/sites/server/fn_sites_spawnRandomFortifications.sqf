/*
    File: sites_spawnRandomFortifications.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-05-25
    Public: Yes

    Description:
        Spawns X amount of fortifications near the site.

    Parameter(s):
        _site - Site to create fortifications for [STRING]
        _quantity - How many to spawn [NUMBER]

    Returns:
        Array of sites (spawned fortifications) [NUMBER]

    Example(s):
        [_site] call vgm_s_fnc_site_selectRandomValidFortification;
 */

params ["_site", "_quantity"];

private _siteType = _site get "type";
private _fortifications = _siteType get "fortifications";

private _candidates = [];
private _weights = [];

{
    _candidates pushBack _x;
    _weights pushBack (_x get "weight");
} forEach _fortifications;

private _selected = [];

for "_i" from 1 to _quantity do {
    _selected pushBack (_candidates selectRandomWeighted _weights);
};

_selected apply {
    private _distance = random (_x get "radius");
    private _dir = random 360;
    private _spawnPos = _site get "pos" getPos [_distance, _dir];

    private _fortificationSite = [_x get "typeId", _spawnPos] call vgm_s_fnc_sites_spawn;
    _site get "ownedSites" pushBack _fortificationSite;
    _fortificationSite
}
