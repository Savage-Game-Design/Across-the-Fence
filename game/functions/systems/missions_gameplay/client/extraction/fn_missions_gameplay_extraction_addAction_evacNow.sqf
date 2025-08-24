/*
    File: fn_missions_gameplay_extraction_addAction_evacNow.sqf
    Author: Savage Game Design
    Date: 2024-05-23
    Last Update: 2025-08-24
    Public: No

    Description:
        Add action to request early extraction -- abandoning any players left on the ground.

    Parameter(s):
        _player - Player to add the action to [OBJECT]

    Returns:
        Action ID [Number]

    Example(s):
        [player] call vgm_c_fnc_missions_gameplay_extraction_addAction_evacNow
 */

params ["_player"];


private _fnc_forceLeave = {
    params ["_target"];

    private _helicopter = (group _target) getVariable ["vgm_missions_extraction_helicopter", objNull];
    private _radio = _target call vgm_c_fnc_missions_gameplay_extraction_getNearbyRadio;
    private _inHelicopter = objectParent _target isEqualTo _helicopter;

    if (!_inHelicopter && isNull _radio) exitWith {
        hintSilent localize "STR_VGM_MISSIONS_EXTRACT_NOW_NO_RADIO";
        playSoundUI ["3DEN_notificationWarning", 0.5];
    };

    // hide action menu
    showCommandingMenu "RscGroupRootMenu"; showCommandingMenu "";

    [_target, _helicopter] spawn {
        params ["_target", "_helicopter"];
        sleep 0.5;
        if ([localize "STR_VGM_MISSIONS_EXTRACTION_CONFIRM_IMMEDIATE_EXTRACTION", "Confirm", true, true] call BIS_fnc_guiMessage) then {
            // Forces the extract check to pass immediately.
            _helicopter setVariable ["vgm_missions_extraction_evacNow", true, true];
            ["VGM_ExtractionEvacNow", []] remoteExec ["BIS_fnc_showNotification", units (group _target)];
        };
    };
};

private _actionId = [
    _player,
    localize "STR_VGM_MISSIONS_EXTRACTION_EVACNOW_ACTION",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa",
    toString {
        vgm_mission_onMission
        // is group leader
        && {leader _target == _target}
        && {
            private _helicopter = (group _target) getVariable ["vgm_missions_extraction_helicopter", objNull];
            // extraction helicopter exists
            !isNull _helicopter
            // helicopter landed
            && _helicopter getVariable ["vgm_missions_extractionLanded", false]
            // forced extract action not run yet
            && {!(_helicopter getVariable ["vgm_missions_extraction_evacNow", false])}
        }
        // should not be possible to request extraction
        // see: fn_missions_gameplay_extraction_startExtract.sqf
        && {!((group _target) getVariable ["vgm_missions_extraction_canRequest", true])}
    },
    "true",
    {},
    {},
    _fnc_forceLeave,
    {},
    nil,
    1,
    100,
    false,
    false,
    false
] call BIS_fnc_holdActionAdd;

_player setVariable ["vgm_missions_gameplay_extraction_action_evacNowStart", _actionId];

_actionId // return
