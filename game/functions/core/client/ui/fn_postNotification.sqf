/*
    File: fn_postNotification.sqf
    Author: Savage Game Design
    Date: 2025-11-13
    Last Update: 2025-11-13
    Public: Yes

    Description:
        Posts a notification on the client using Paradigm's notification system, with VGM's defaults

    Parameter(s):
        _notification - Notification details [HASHMAP]

    Returns:
        Notification id [NUMBER]

    Example(s):
        createHashMapFromArray [
            ["title", "Hello"],
            ["body", "Hello again!"]
        ] call vgm_c_fnc_postNotification;
 */

params ["_notification"];

[_notification] call para_c_fnc_postNotification;

