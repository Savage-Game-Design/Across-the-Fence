/*
    File: fn_missions_endMission.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2024-11-16
    Public: No

    Description:
        Handles the end of the mission on the client.

    Parameter(s):
        _endType - Mission ending type [STRING]
        _levelingDataCopy - Copy of the player leveling data [HASHMAP]
        _milestones - Mission milestones array [ARRAY]

    Returns:
        Nothing

    Example(s):
        _levelingDataCopy = +(player getVariable "vgm_g_levelingData");
        _milestones = [["mission", 250]];
        ["SUCCESS", _levelingDataCopy, _milestones] call vgm_c_fnc_missions_endMission;

        // Should be triggered by ending the mission on the server.
        [] call vgm_s_fnc_missions_endMission;
 */

params ["_endType", "_levelingDataCopy", "_milestones"];

vgm_mission_onMission = false;

private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
["vgm_mission_end_local", _currentMission] call para_g_fnc_event_triggerLocal;

// Removes player-specific tracker module handlers.
// TODO: Remove when switching to full AI system.
player removeEventHandler ["Fired", player getVariable "vgm_c_trackerFiredHandler"];
["ItemRemove", ["vn_tracksLoop"]] call BIS_fnc_loop;

moveOut player;
player setVelocity [0,0,0];
([] call vgm_g_fnc_missions_getHubSpawnPos) params ["_newPos", "_newDir"];
player setDir _newDir;
player setVehiclePosition [_newPos, [], 0, "NONE"];
[] call vgm_c_fnc_sharedHub_enableHub;

player call vgm_c_fnc_medical_fullHeal;

terminate (missionNamespace getVariable ["vgm_missions_zoomOnMapScript", scriptNull]);
[] call vgm_c_fnc_missions_coverMap;

// Show end of mission screen
private _dialog = createDialog ["VGM_DisplayEndOfMission", true];
["updateEndStatus", [_dialog, _endType]] call vgm_c_fnc_displayEndOfMission;
["renderProgress", [_dialog, [_levelingDataCopy, _milestones]]] call vgm_c_fnc_displayEndOfMission;
