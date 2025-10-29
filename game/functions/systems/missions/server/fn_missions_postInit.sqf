/*
    File: fn_missions_postInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2025-10-29
    Public: No

    Description:
        Server Post init for mission system.
 */

if (!isServer) exitWith {};

vgm_s_max_team_size = ["missions_maxTeamSize", 6] call BIS_fnc_getParamValue;
