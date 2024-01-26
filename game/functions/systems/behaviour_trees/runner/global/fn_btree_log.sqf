/*
    File: fn_btree_log.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: No

    Description:
        Logger for the behaviour tree system.

        Keeps logs separate to the main VGM log.

    Parameter(s):
        _message - Message to send [STRING]

    Variables defined in environment:
        _group - Current group in the behaviour tree [GROUP]

    Returns:
        None

    Example(s):
        ["Something"] call vgm_g_fnc_btree_log;
 */

params ["_message"];

_group getVariable "vgm_l_btree_log" pushBack _message;
