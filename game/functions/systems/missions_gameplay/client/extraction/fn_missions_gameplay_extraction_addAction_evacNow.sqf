/*
    File: fn_missions_gameplay_extraction_addAction_evacNow.sqf
    Author: Savage Game Design
    Date: 2024-05-23
    Last Update: 2024-06-09
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

    private _radio = _target call vgm_c_fnc_missions_gameplay_extraction_getNearbyRadio;

    if (isNull _radio) exitWith {
        hint localize "STR_VGM_MISSIONS_EXTRACTION_REQUEST_NO_RADIO";
        playSoundUI ["3DEN_notificationWarning", 0.5];
    };

    // hide action menu
    showCommandingMenu "RscGroupRootMenu"; showCommandingMenu "";

    [_target, _radio] spawn {
        sleep 0.5;
        if (["Start Extraction Now? Remaining team members will be abandoned.", "Confirm", true, true] call BIS_fnc_guiMessage) then {
            // setting variable on helicopter breaks out of the spawn checking for all group members boarded
            (objectParent (_this select 0)) setVariable ["vgm_missions_extraction_evacNow", true, true];
            ["VGM_ExtractionEvacNow", []] remoteExec ["BIS_fnc_showNotification", units (group (_this select 0))];

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
        && leader _target == _target
        // should not be possible to request extraction
        && {!((group _target) getVariable ["vgm_missions_extraction_canRequest", true])}
        // group leader is in vehicle
        && {!isNull (objectParent _target)}
        // see: fn_missions_gameplay_extraction_startExtract.sqf
        // group leader in extraction helo
        && {(objectParent _target) == ((group _target) getVariable ["vgm_missions_extraction_helicopter", objNull])}
        // forced extract action not run yet
        && {!((objectParent _target) getVariable ["vgm_missions_extraction_evacNow", false])}
        // forced timer extract action not run
        && {((objectParent _target) getVariable ["vgm_missions_extraction_evacAt", -1]) isEqualTo -1}
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
