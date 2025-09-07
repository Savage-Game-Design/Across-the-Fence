/*
    File: fn_carry_tryMoveIn.sqf
    Author: Savage Game Design
    Date: 2025-08-21
    Last Update: 2025-08-22
    Public: No

    Description:
        Tries to move a unit into a vehicle, excluding driver seat.

    Parameter(s):
        _unit - Unit being moved in [OBJECT]
        _vehicle - Vehicle to move into [OBJECT]

    Returns:
        Nothing

    Example(s):
        [player, cursorTarget] call vgm_c_fnc_carry_tryMoveIn
 */

params ["_unit", "_vehicle"];

format ["Moving unit into vehicle: %1, %2", _unit, _vehicle] call vgm_g_fnc_logInfo;

call {
    if (_vehicle emptyPositions "cargo" > 0) exitWith {
        _unit moveInCargo _vehicle;
    };

    private _turrets = fullCrew [_vehicle, "turret", true];
    private _index = _turrets findIf {isNull (_x#0)};
    if (_index >= 0) exitWith {
        _unit moveInTurret [_vehicle, _turrets#_index#3];
        _slotsOpen = true;
    };

    if (_vehicle emptyPositions "commander" > 0) exitWith {
        _unit moveInCommander _vehicle;
    };

    if (_vehicle emptyPositions "gunner" > 0) exitWith {
        _unit moveInCommander _vehicle;
    };

    format ["Failed to move unit into vehicle: %1, %2", _unit, _vehicle] call vgm_g_fnc_logError;
};

if (_unit in _vehicle && {_unit call vgm_g_fnc_medical_isUnconscious}) then {
    // use function from SOGPF revive to switch to "terminal"/death animation of the vehicle position
    [_unit] call vn_fnc_revive_terminal_animation;
};

nil
