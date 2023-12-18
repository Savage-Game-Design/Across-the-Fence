/*
    File: fn_btree_panic.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        Abort behaviour tree execution

    Parameter(s):
        N/A

    Variables defined in environment:
        _btreeState - Current state of the behaviour tree.

    Returns:
        [[], {}] -

    Example(s):
        ["Cannot continue - invalid situation"] call vgm_g_fnc_btree_panic;
 */

#include "..\behaviour_trees.inc"

params ["_message"];

private _formattedMessage = format ["BEHAVIOUR TREE PANIC: %1", _message];

[_formattedMessage] call vgm_g_fnc_logError;
[_formattedMessage] call vgm_g_fnc_btree_log;

// Reset the stack to make the behaviour tree start executing from the beginning.
_btreeState set ["stack", []];

NO_NEXT_ACTION
