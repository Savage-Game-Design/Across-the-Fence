/*
    File: fn_overlay_controls_group.sqf
    Author: Terra
    Date: 2023-02-05
    Public: No

    Description:
        Show or hides a controls group that covers the rest of the UI.

    Parameter(s):
        _ctrlGroup - Controls group [CONTROL]
        _enable - Show or hide the group [BOOL]

    Returns:
        Nothing

    Example(s):
        [_ctrlExampleGroup, true] call vgm_c_fnc_toggle_controls_group_overlay;
        [_ctrlExampleGroup, false] call vgm_c_fnc_toggle_controls_group_overlay;
*/
params ["_ctrlGroup", "_enable"];
private _fnc_isPartOfGroup = {
    private _parent = _this;
    while {!isNull _parent} do {
        if (_parent == _ctrlGroup) exitWith {true};
        _parent = ctrlParentControlsGroup _parent;
        false;
    };
};

if (_enable) then {
    // Block all other controls but keep track of current state
    private _enabledControls = allControls _display select {
        ctrlEnabled _x && !(_x call _fnc_isPartOfGroup)
    };
    _ctrlGroup setVariable ["_enabledControls", _enabledControls];
    _enabledControls apply {_x ctrlEnable false};
    ctrlSetFocus _ctrlGroup;
} else {
    private _controlsToEnable = _ctrlGroup getVariable ["_enabledControls", []];
    _controlsToEnable apply {_x ctrlEnable true};
    _ctrlGroup spawn {
        ctrlDelete _this;
    };
};

