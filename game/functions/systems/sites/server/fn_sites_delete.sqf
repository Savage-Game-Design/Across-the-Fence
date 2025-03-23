/*
    File: sites_delete.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-10-30
    Public: Yes

    Description:
        Deletes an existing site that was previously created with vgm_s_fnc_sites_spawn;

    Parameter(s):
        _site - Data structure returned from spawn

    Returns:
        Nothing

    Example(s):
        private _myBunker = ["vgm_bunker", [100, 100]] call vgm_s_fnc_sites_spawn;
        [_myBunker] call vgm_s_fnc_sites_delete;
 */

params ["_site"];

[_site] call (_site get "type" getOrDefault ["cleanupFunction", {}]);

{
    [_x] call vgm_s_fnc_sites_delete;
} forEach (_site get "ownedSites");

{
    deleteVehicle _x;
} forEach (_site get "objects");

private _hiddenTerrain = _site get "hiddenTerrain";
if (!isNil "_hiddenTerrain") then {
    [_hiddenTerrain] call vgm_s_fnc_unhideTerrainObjects;
};
