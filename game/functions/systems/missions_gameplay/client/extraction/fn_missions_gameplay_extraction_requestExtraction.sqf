/*
    File: fn_missions_gameplay_extraction_requestExtraction.sqf
    Author: Savage Game Design
    Date: 2024-05-23
    Last Update: 2024-11-07
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [player] call vgm_c_fnc_missions_gameplay_extraction_requestExtraction;
 */

params ["_player", ["_radio", objNull]];

[call vgm_c_fnc_missions_getCurrentMission get "id"] remoteExecCall ["vgm_s_fnc_missions_gameplay_extraction_startExtract", 2];

// dialog
[_player, _radio] spawn {
    params ["_player", "_radio"];
    [_player, ["vgm_extraction_request", 100, 1, true]] remoteExec ["say3D", group _player];
    sleep 4;
    [_radio, ["vgm_extraction_response", 100, 1, true]] remoteExec ["say3D", group _player];
};
