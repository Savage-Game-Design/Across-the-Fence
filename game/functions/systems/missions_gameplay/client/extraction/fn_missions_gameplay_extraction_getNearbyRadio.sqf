/*
    File: fn_missions_gameplay_extrction_getNearbyRadio.sqf
    Author: Savage Game Design
    Date: 2024-06-09
    Last Update: 2024-06-09
    Public: No

    Description:
        Get object with radio capability close to given unit.

    Parameter(s):
        _unit - Unit used to search for nearby radios [OBJECT]

    Returns:
        Radio object [OBJECT]

    Example(s):
        [player] call vgm_c_fnc_missions_gameplay_extraction_getNearbyRadio
 */

params ["_unit"];

private _rtos = units _unit select {_unit distance2D _x < 30 && backpack _x in vgm_missions_gameplay_extraction_radioBackpacks};
private _rto = _rtos param [0, objNull];

if (!isNull _rto) exitWith {_rto}; // return

if (_unit getSlotItemName 611 != "") exitWith {_unit}; // return

private _nearbyRadios = _unit nearEntities [vgm_missions_gameplay_extraction_radioObjects, 30];
private _nearbyRadio = _nearbyRadios param [0, objNull];

_nearbyRadio // return
