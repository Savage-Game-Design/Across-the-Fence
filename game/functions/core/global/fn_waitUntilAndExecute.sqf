/*
    File: fn_waitUntilAndExecute.sqf
    Author: Savage Game Design
    Date: 2025-02-02
    Last Update: 2025-02-03
    Public: Yes

    Description:
        Executes provided code unscheduled once the condition is true, optionally can have a timeout and code executed upon the timeout.

    Parameter(s):
        _condition - Callback to call for condition check [CODE]
        _code - Callback to execute once condition is true [CODE]
        _args - Arguments to pass to all callbacks [ANY]
        _timeoutDelay - How long to wait for the timeout [NUMBER]
        _timeoutCode - Callback to call on timeout [CODE]

    Returns:
        Nothing

    Example(s):
        [
            {speed (_this#0) < 1},
            {systemChat "standing still"},
            [player],
            5,
            {systemChat "please stand still!"}
        ] call vgm_g_fnc_waitUntilAndExecute;
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

nil
