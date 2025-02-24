/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2022-11-13
    Last Update: 2025-02-24
    Public: No

    Description:
        Core component global preInit script.
 */

vgm_version = localize "STR_VGM_MISSION_VERSION";

// init WUAE system
call {
    #define REMOVE_ITEM vgm_core_waitUntilAndExecute_array deleteAt _forEachIndex;

    vgm_core_waitUntilAndExecute_eh = -1;
    vgm_core_waitUntilAndExecute_array = [];

    vgm_core_waitUntilAndExecute_eh = addMissionEventHandler ["EachFrame", {
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
    }];
};
