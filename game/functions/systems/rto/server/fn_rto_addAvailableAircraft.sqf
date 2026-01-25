/*
    File: fn_rto_addAvailableAircraft.sqf
    Author: Savage Game Design
    Date: 2026-01-08
    Last Update: 2026-01-25
    Public: No

    Description:
        Makes one or more aircraft available for the player to call in.

    Parameter(s):
        _playerId - ID oi the player doing the calling [STRING]
        _aircraftIds - IDs of the aircraft to make available. Duplicates aren't permitted. [ARRAY]

    Returns:
        Nothing

    Example(s):
        [getPlayerID (allPlayers # 0), ["f4c_cas_testing", "f4c_pat"]] call vgm_s_fnc_rto_addAvailableAircraft;
 */

params ["_playerId", "_aircraftTypeIds"];

private _playerAvailableAircraft = vgm_s_rto_availableAircraft get _playerId;

if (isNil "_playerAvailableAircraft") then {
    _playerAvailableAircraft = [] call para_s_fnc_netmap_createNetmap;
    [_playerAvailableAircraft, vgm_s_rto_availableAircraft] call para_s_fnc_netmap_setOwningNetmap;
    [vgm_s_rto_availableAircraft, _playerId, _playerAvailableAircraft] call para_s_fnc_netmap_set;
};

{
    private _aircraftTypeId = _x;
    if (_aircraftTypeId in _playerAvailableAircraft || !(_aircraftTypeId in vgm_g_rto_aircraftTypes)) then { continue; };

    private _aircraftType = vgm_g_rto_aircraftTypes get _aircraftTypeId;

    private _strikes = createHashMap;
    {
        _strikes set [_x, _y get "uses"];
    } forEach (_aircraftType get "strikes");

    // Set up an individual instance of the aircraft.
    private _id = _aircraftTypeId;
    private _aircraft = [[
        // ID of this individual aircraft
        ["id", _id],
        // ID of the aircraft's type
        ["typeId", _aircraftTypeId],
        // When the aircraft was requested
        ["requestedAt", 1e99],
        // When the aircraft will/did arrive on station
        ["onStationAt", 1e99],
        // When the aircraft will depart/departed from the AO
        ["departAt", 1e99],
        // When the aircraft's current attack run / last attack run was completed
        ["runCompleteAt", -1],
        // Strikes isn't a netmap as it's pretty small, and at the end of the mission every aircraft netmap is terminated.
        // Avoiding adding more netmaps keeps the performance cost of that end-of-mission spike a little lower (for all players still on missions).
        ["strikes", _strikes]
    ]] call para_s_fnc_netmap_createNetmapFromArray;
    [_aircraft, _playerAvailableAircraft] call para_s_fnc_netmap_setOwningNetmap;
    [_playerAvailableAircraft, _id, _aircraft] call para_s_fnc_netmap_set;
} forEach _aircraftTypeIds;
