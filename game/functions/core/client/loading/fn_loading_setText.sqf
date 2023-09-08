/*
    File: fn_loading_setText.sqf
    Author: Savage Game Design
    Date: 2023-09-09
    Last Update: 2023-09-09
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        ["Preparing napalm..."] call vgm_c_fnc_loading_setText
 */

private _idc = 5050;

params [
    ["_text", "", ["", parseText ""]]
];

private _display = uiNameSpace getVariable ["vgm_displayLoading", displayNull];

if (isNull _display) exitWith {};

private _ctrlText = _display displayCtrl _idc;
if (_text isEqualType "") exitWith {
    _ctrlText ctrlSetText _text;
};

_ctrlText ctrlSetStructuredText _text;
