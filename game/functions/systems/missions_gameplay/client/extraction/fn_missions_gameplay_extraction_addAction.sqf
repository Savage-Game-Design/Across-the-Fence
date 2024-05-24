/*
    File: fn_missions_gameplay_extraction_addAction.sqf
    Author: Savage Game Design
    Date: 2024-05-23
    Last Update: 2024-05-24
    Public: No

    Description:
        Add action to request early extraction.

    Parameter(s):
        _player - Player to add the action to [OBJECT]

    Returns:
        Action ID [Number]

    Example(s):
        [player] call vgm_c_fnc_missions_gameplay_extraction_addAction
 */

params ["_player"];

private _fnc_callExtraction = {
    params ["_target"];

    private _nearbyObjects = _target nearEntities ["All", 50];
    private _nearRadioIdx = _nearbyObjects findIf {
        if (_x isKindOf "CAManBase") then {
            backpack _x in vgm_missions_gameplay_extraction_radioClasses // return
        } else {
            typeOf _x in vgm_missions_gameplay_extraction_radioClasses // return
        };
    };

    if (_nearRadioIdx == -1) exitWith {
        hint localize "STR_VGM_MISSIONS_EXTRACTION_REQUEST_NO_RADIO";
        playSoundUI ["3DEN_notificationWarning", 0.5];
    };
    private _nearRadio = _nearbyObjects select _nearRadioIdx;

    [_target, _nearRadio] call vgm_c_fnc_missions_gameplay_extraction_requestExtraction;
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
    false
] call BIS_fnc_holdActionAdd;

_player setVariable ["vgm_missions_gameplay_extraction_actionExtract", _actionId];

_actionId // return
