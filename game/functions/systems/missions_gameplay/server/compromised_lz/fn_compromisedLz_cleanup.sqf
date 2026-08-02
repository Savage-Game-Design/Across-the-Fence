/*
    File: fn_compromisedLz_cleanup.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Cleans up all Compromised LZ virtual squads for a given mission.
        Deletes bushes and virtual squads, removes entries from the tracking hashmap.

    Parameter(s):
        _missionId - ID of the mission [STRING/NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_compromisedLz_cleanup;
*/

params ["_missionId"];

private _keysToDelete = [];
private _totalCleaned = 0;

{
    private _key = _x;
    private _squad = _y;

    // Match by missionId — _y is the virtual squad hashmap
    if (_squad get "missionId" isEqualTo _missionId) then {
        // Clean up bushes from defender data stored in the occupiedLzs tracking
        private _defenderKey = format ["%1_%2", _missionId, hashValue (_squad get "lzPosition")];
        private _defenderData = vgm_s_compromisedLz_occupiedLzs getOrDefault [_defenderKey, createHashMap];
        if (!(_defenderData isEqualTo createHashMap) && {"bushes" in _defenderData}) then {
            {deleteVehicle _x} forEach (_defenderData getOrDefault ["bushes", []]);
        };

        // Delete the virtual squad (handles unit/group deletion)
        [_squad] call vgm_s_fnc_virtsquad_delete;

        _keysToDelete pushBack _key;
        _totalCleaned = _totalCleaned + 1;
    };
} forEach vgm_s_compromisedLz_occupiedLzs;

// Remove entries from hashmap
{
    vgm_s_compromisedLz_occupiedLzs deleteAt _x;
} forEach _keysToDelete;

if (_totalCleaned > 0) then {
    format ["Compromised LZ: Cleaned up %1 squads for mission %2",
        _totalCleaned, _missionId] call vgm_g_fnc_logInfo;
};
