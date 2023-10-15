/*
    File: fn_missions_endMission.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-10-15
    Public: No

    Description:
        Handles the end of the mission on the client.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        _levelingDataCopy = +(player getVariable "vgm_g_levelingData");
        _milestones = [["mission", 250]];
        [_levelingDataCopy, _milestones] call vgm_c_fnc_missions_endMission;

        // Should be triggered by ending the mission on the server.
        [] call vgm_s_fnc_missions_endMission;
 */

params ["_levelingDataCopy", "_milestones"];

// Removes player-specific tracker module handlers.
// TODO: Remove when switching to full AI system.
player removeEventHandler ["Fired", player getVariable "vgm_c_trackerFiredHandler"];
["ItemRemove", ["vn_tracksLoop"]] call BIS_fnc_loop;

player setPos ([] call vgm_g_fnc_missions_getHubSpawnPos);

// Show end of mission screen
private _dialog = createDialog ["VGM_DisplayEndOfMission", true];

["renderProgress", [_dialog, [_levelingDataCopy, _milestones]]] call vgm_c_fnc_displayEndOfMission;
