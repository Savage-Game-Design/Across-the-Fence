/*
    File: fn_missions_getPlayers.sqf
    Author: Savage Game Design
    Date: 2025-10-22
    Last Update: 2025-10-22
    Public: Yes

    Description:
        Retrieves player units for all players currently on the mission.

        Try to re-use this value where possible, as the performance isn't good enough to consider it "free".

    Parameter(s):
        _mission - Mission to get data from [HASHMAP]

    Returns:
        Array of players [ARRAY]

    Example(s):
        [["32"] call vgm_s_fnc_missions_getById] call vgm_s_fnc_missions_getPlayers;
 */

params ["_mission"];

keys (_mission get "machineIds") apply { getUserInfo _x # 10 }
