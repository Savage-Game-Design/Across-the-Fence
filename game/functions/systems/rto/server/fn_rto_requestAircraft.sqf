/*
    File: fn_rto_requestAircraft.sqf
    Author: Savage Game Design
    Date: 2026-01-08
    Last Update: 2026-01-08
    Public: No

    Description:
        Requests an aircraft that's currently on standby arrive on-station.

    Parameter(s):
        _rtoId - ID of the RTO requesting the asset [STRING]
        _assetType - Type of asset to call [STRING]

    Returns:
        Nothing

    Example(s):
        [getPlayerId allPlayers # 0, "f100"] call vgm_s_fnc_rto_callAircraft;
 */

params ["_rtoId", "_assetType"];


