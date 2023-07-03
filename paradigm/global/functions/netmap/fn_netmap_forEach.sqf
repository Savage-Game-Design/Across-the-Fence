/*
    File: fn_netmap_keys.sqf
    Author: Savage Game Design
    Date: 2023-06-23
    Last Update: 2023-06-26
    Public: Yes

    Description:
        Iterates through all the members of a netmap, and calls _code for each.

        Equivalent to `{ } forEach _hashmap`.

        Needed as the `_netmap` metadata key is iterated using normal `forEach`.

    Parameter(s):
        _netmap - Netmap to iterate [HashMap]

    Returns:
        The last result from the forEach (same as a normal forEach) [ANY]

    Example(s):
        private _myNetmap = ["myNetmap"] call para_g_fnc_netmap_get;

        [
            { diag_log format ["%1 - %2", _x, _y] },
            _myNetmap
        ] call para_g_fnc_netmap_forEach;
 */

params ["_code", "_netmap"];

{
    if (_x isEqualTo "_netmap") then { continue };
    call _code;

} forEach _netmap
