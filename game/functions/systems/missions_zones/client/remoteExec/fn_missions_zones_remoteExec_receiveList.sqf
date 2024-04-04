/*
    File: fn_missions_zones_remoteExec_receiveList.sqf
    Author: Savage Game Design
    Date: 2024-04-04
    Last Update: 2024-04-04
    Public: No

    Description:
        Receive missions zone data and open missions display.

    Parameter(s):
        _timeToMissionsChange - Time after which new missions will be available [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_seedChangeIn, vgm_missions_zones_targetBoxesModifiers] remoteExecCall ["vgm_c_fnc_missions_zones_remoteExec_receiveList", remoteExecutedOwner];
 */

params ["_timeToMissionsChange", "_targetBoxesModifiers"];

// player aborted while display was loading
if (isNull (uiNamespace getVariable ["RscDisplayCommonMessage_display", displayNull])) exitWith {};

// close the popup
private _result = true;
uiNamespace setVariable ["BIS_fnc_guiMessage_status", _result];

// TODO mission display implementation
hint str _this;
