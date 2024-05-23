/*
    File: fn_missions_gameplay_extraction_addAction.sqf
    Author: Savage Game Design
    Date: 2024-05-23
    Last Update: 2024-05-23
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

    private _nearRadio = (_target nearEntities ["All", 50]) findIf {
        if (_x isKindOf "CAManBase") then {
            backpack _x in vgm_missions_gameplay_extraction_radioClasses // return
        } else {
            typeOf _x in vgm_missions_gameplay_extraction_radioClasses // return
        };
    } != -1;

    if (!_nearRadio) exitWith {
        hint "Not near radio!";
    };

    hint "Near radio";
};

private _actionId = [
    _player,
    localize "STR_VGM_MISSIONS_EXTRACTION_REQUEST_ACTION",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa",
    "vgm_mission_onMission",
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

_player setVariable ["vgm_mission_gameplay_extraction_actionExtract", _actionId];

_actionId // return
