/*
    File: fn_rto_preInit.sqf
    Author: Savage Game Design
    Date: 2026-01-04
    Last Update: 2026-01-25
    Public: No

    Description:
        Pre-init for RTO system
*/

/*

Netmap with:
- One netmap for player
  - Available assets hashmap (not a netmap?) by asset type?
    - Key: Asset type
    - Properties:
      - Status: One of "STANDBY", "ON_STATION", "EN_ROUTE", "EXPENDED"
      - Base arrival time seconds
      - Requested at: serverTime
      - Base on station time seconds
      - On Station At: serverTime
      - Strikes: Netmap of strike type to quantity

Modifiers are handled on the client for arrival times - server doesn't need to know, and would require the server to be running some kind of loop.
*/

vgm_s_rto_availableAircraft = ["rto_availableAircraft"] call para_s_fnc_netmap_createNamedNetmap;

["vgm_mission_playerRemoved", {
    _this#0 params ["_playerId", "_missionId", "_playerUnit"];

    [_playerId] call vgm_s_fnc_rto_clearAvailableAircraft;
}] call para_g_fnc_event_subscribeServer;
