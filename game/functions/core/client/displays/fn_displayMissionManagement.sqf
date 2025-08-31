#include "macros.inc"

/*
    File: fn_displayMissionManagement.sqf
    Author: Savage Game Design
    Date: 2023-09-22
    Last Update: 2025-08-31
    Public: No

    Description:
        UI script for the End Of Mission UI.

    Parameter(s):
        _mode - One of the switch-cases [STRING]
        _params - Parameters from the event [ARRAY]

    Returns:
        Nothing [NIL]

    Example(s):
        ["onLoad", _display] call vgm_c_fnc_displayMissionManagement;
*/

#define SELF vgm_c_fnc_displayMissionManagement

params ["_mode", "_this"];
switch _mode do {
    case "onLoad": {
        params ["_display"];

        uiNamespace setVariable ["VGM_DisplayMissionManagement", _display];

        ["refreshMissionList", _display] call SELF;
    };
    case "onUnload": {
        params ["_display", "_exitCode"];
    };
    case "refreshMissionList": {
        params ["_display"];

        private _lbMissions = _display displayCtrl VGM_IDC_DISPLAYMISSIONMANAGEMENT_LIST;

        private _missions = ([] call vgm_c_fnc_missions_getMissions) call para_g_fnc_netmap_values;
        private _joinableMissions = _missions select {
            ((_x get "preventJoining") call para_g_fnc_netmap_count) == 0
        };

        {
            private _mission = _x;
            private _missionId = _mission get "id";
            private _leader = leader (_mission get "group");
            private _leaderName = [name _leader, "[No leader]"] select (isNull _leader);

            _lbMissions lbAdd format ["Mission %1 - Lead by %2", _missionId, _leaderName];
        } forEach _joinableMissions;
    };
};
nil
