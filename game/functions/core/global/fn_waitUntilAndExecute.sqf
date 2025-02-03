/*
    File: fn_waitUntilAndExecute.sqf
    Author: Savage Game Design
    Date: 2025-02-02
    Last Update: 2025-02-03
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

#define REMOVE_ITEM vgm_core_waitUntilAndExecute_array deleteAt _forEachIndex;

params [
    ["_condition", {true}, [{}]],
    ["_code", {}, [{}]],
    ["_args", []],
    ["_timeoutDelay", nil, [0]],
    ["_timeoutCode", {}, [{}]]
];

if (vgm_core_waitUntilAndExecute_eh == -1) then {
    private _eh = addMissionEventHandler ["EachFrame", {
        {
            _x params ["_condition", "_code", "_args", "_timeoutTime", "_timeoutCode"];
            // if _timeoutDelay is nil this will be not be executed due to how SQF operators work
            if (time > _timeoutTime) then {
                _args call _timeoutCode;

                REMOVE_ITEM;
                continue;
            };

            if (_args call _condition) then {
                _args call _code;

                REMOVE_ITEM;
                continue;
            };
        } forEachReversed vgm_core_waitUntilAndExecute_array;

        if (vgm_core_waitUntilAndExecute_array isEqualTo []) then {
            // we could consider having the EachFrame run all the time to prevent constant increments of the EH ids
            removeMissionEventHandler ["EachFrame", _thisEventHandler];
            vgm_core_waitUntilAndExecute_eh = -1;
        };
    }];

    vgm_core_waitUntilAndExecute_eh = _eh;
};

vgm_core_waitUntilAndExecute_array pushBack [_condition, _code, _args, time + _timeoutDelay, _timeoutCode];
