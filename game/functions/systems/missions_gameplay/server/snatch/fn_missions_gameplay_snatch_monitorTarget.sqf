/*
    File: fn_missions_gameplay_snatch_monitorTarget.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Server-side monitoring script for the Prisoner Snatch target officer.
        Tracks state transitions: alive -> unconscious -> carried -> extracted.
        Updates tasks and fires voice line events accordingly.

    Parameter(s):
        _missionId   - Mission ID [NUMBER]
        _officer     - The PAVN officer unit [OBJECT]
        _playerGroup - The player group [GROUP]

    Returns:
        Nothing

    Example(s):
        [_missionId, _officer, _playerGroup] spawn vgm_s_fnc_missions_gameplay_snatch_monitorTarget;
 */

params ["_missionId", "_officer", "_playerGroup"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

private _snatchNetmap = [_missionId, "snatch"] call vgm_s_fnc_missions_getSystemNetmap;
private _parentTaskId = format ["vgm_snatch_%1", _missionId];

private _knockedOut = false;
private _carried = false;

while {true} do {
    sleep 1.5;

    // Check if mission still active
    private _missionCheck = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_missionCheck") exitWith {};
    if ((_missionCheck get "public" get "status") != "IN PROGRESS") exitWith {};

    // Officer killed — mission objective failed
    if (!alive _officer) exitWith {
        [_snatchNetmap, "targetStatus", "dead"] call para_s_fnc_netmap_set;
        [format ["%1_locate", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        [format ["%1_capture", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        [format ["%1_extract", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        [_parentTaskId, "FAILED"] call BIS_fnc_taskSetState;

        format ["Snatch: Officer KIA for mission %1", _missionId] call vgm_g_fnc_logInfo;
    };

    // Officer knocked unconscious
    if (!_knockedOut && {_officer getVariable ["vgm_snatch_unconscious", false]}) then {
        _knockedOut = true;
        [_snatchNetmap, "targetStatus", "unconscious"] call para_s_fnc_netmap_set;
        [_snatchNetmap, "targetCaptured", true] call para_s_fnc_netmap_set;

        [format ["%1_locate", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
        [format ["%1_capture", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
        [format ["%1_extract", _parentTaskId], "ASSIGNED"] call BIS_fnc_taskSetState;

        ["vgm_voice_snatch_targetDown", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

        format ["Snatch: Officer knocked out for mission %1", _missionId] call vgm_g_fnc_logInfo;
    };

    // Officer being carried
    if (_knockedOut && !_carried) then {
        private _carriedBy = _officer getVariable ["vgm_carry_carriedBy", objNull];
        if (!isNull _carriedBy) then {
            _carried = true;
            format ["Snatch: Officer being carried by %1 for mission %2", name _carriedBy, _missionId] call vgm_g_fnc_logInfo;
        };
    };

    // Officer in extraction helicopter or hooked to STABO rig
    if (_knockedOut) then {
        private _extractHeli = _playerGroup getVariable ["vgm_missions_extraction_helicopter", objNull];
        private _inHeli = !isNull _extractHeli && {_officer in _extractHeli};
        private _onStabo = _officer getVariable ["vgm_snatch_stabo_hooked", false];
        if (_inHeli || _onStabo) then {
            [_snatchNetmap, "targetExtracted", true] call para_s_fnc_netmap_set;
            [format ["%1_extract", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
            [_parentTaskId, "SUCCEEDED"] call BIS_fnc_taskSetState;

            ["vgm_voice_snatch_extracting", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

            format ["Snatch: Officer extracted for mission %1", _missionId] call vgm_g_fnc_logInfo;
            breakOut "monitorLoop";
        };
    };
};
