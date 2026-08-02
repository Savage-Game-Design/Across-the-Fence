/*
	File: fn_bda_cleanupForMission.sqf
	Author: Atlas
	Date: 2026-03-05
	Last Update: 2026-03-05
	Public: No

	Description:
		Cleans up the BDA field for a given mission. Deletes all scene objects,
		restores hidden terrain objects, and deletes spawned groups.

	Parameter(s):
		_missionId - Id of the mission [NUMBER]

	Returns:
		Nothing

	Example(s):
		[0] call vgm_s_fnc_bda_cleanupForMission;
 */

params ["_missionId"];

private _data = vgm_s_bda_missionData getOrDefault [_missionId, createHashMap];
if (_data isEqualTo createHashMap) exitWith {};

// Delete all scene objects
private _sceneObjects = _data getOrDefault ["sceneObjects", []];
{
	if (!isNull _x) then {
		deleteVehicle _x;
	};
} forEach _sceneObjects;

// Restore hidden terrain objects
private _hiddenTerrain = _data getOrDefault ["hiddenTerrain", []];
{
	if (!isNull _x) then {
		_x hideObjectGlobal false;
	};
} forEach _hiddenTerrain;

// Delete spawned groups
private _groups = _data getOrDefault ["groups", []];
{
	if (!isNull _x) then {
		{deleteVehicle _x} forEach (units _x);
		deleteGroup _x;
	};
} forEach _groups;

// Remove from tracking
vgm_s_bda_missionData deleteAt _missionId;

format ["[BDA] Cleaned up BDA field for mission %1", _missionId] call vgm_g_fnc_logInfo;
