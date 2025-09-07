/*
    File: fn_vgm_c_fnc_missions_gameplay_extraction_addAction_requestExtract.sqf
    Author: Savage Game Design
    Date: 2024-05-23
    Last Update: 2024-06-09
    Public: No

    Description:
        Add action to request extraction.

    Parameter(s):
        _player - Player to add the action to [OBJECT]

    Returns:
        Action ID [Number]

    Example(s):
        [player] call vgm_c_fnc_missions_gameplay_extraction_addAction_requestExtract
 */

params ["_player"];

private _fnc_callExtraction = {
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
        if (["Are you sure?", "Confirm", true, true] call BIS_fnc_guiMessage) then {
            _this call vgm_c_fnc_missions_gameplay_extraction_requestExtraction;
        };
    };
};

private _actionId = [
    _player,
    localize "STR_VGM_MISSIONS_EXTRACTION_REQUEST_ACTION",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa",
    toString {
        vgm_mission_onMission
        && leader _target == _target
        && {group _target getVariable ["vgm_missions_extraction_canRequest", true]}
    },
    "true",
    {},
    {},
    _fnc_callExtraction,
    {},
    nil,
    1,
    100,
    false,
    false,
    false
] call BIS_fnc_holdActionAdd;

_player setVariable ["vgm_missions_gameplay_extraction_actionExtract", _actionId];

_actionId // return
