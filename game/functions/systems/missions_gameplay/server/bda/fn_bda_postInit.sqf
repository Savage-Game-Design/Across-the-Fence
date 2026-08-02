/*
	File: fn_bda_postInit.sqf
	Author: Atlas
	Date: 2026-03-05
	Last Update: 2026-03-05
	Public: No

	Description:
		Server post-init for the BDA ambient encounter system.
		Cleanup is handled here; spawning is triggered from the ambient
		life spawner which passes road data.
 */

if (!isServer) exitWith {};

// Clean up BDA field when a mission ends
["vgm_mission_ended", {
	(_this#0) params ["_missionId"];
	[_missionId] call vgm_s_fnc_bda_cleanupForMission;
}] call para_g_fnc_event_subscribeServer;
