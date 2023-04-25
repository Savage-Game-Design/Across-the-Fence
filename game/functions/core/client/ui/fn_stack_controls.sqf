/*
    File: fn_stack_controls.sqf
    Author: Terra
    Date: 2023-02-04
    Public: No

    Description:
        Stacks all controls of a CT_CONTROLS_GROUP on top of each other.
        Controls that have the attribute `stackDisable` are skipped. If a
        control has the attribute `stackFill` it will take the remaining space
        of the controls group. This will only work for one control of the stack.
        The gap between controls is given by the attribute `stackMargin` in the
        config class of the controls group.

    Parameter(s):
        _ctrlGroup - The controls group [CONTROL]
        _cfgCtrlGroup - Config of the controls group [CONFIG]

    Returns:
        Nothing

    Example(s):
        [findDisplay 1234 displayCtrl 987, missionConfigFile >> "VGM_DisplayExample" >> "Controls" >> "MyGroup"] call vgm_c_fnc_stack_controls
*/
#include "..\displays\macros.inc"
params ["_ctrlGroup", "_cfgCtrlGroup"];
private _margin = getNumber (_cfgCtrlGroup >> "stackMargin");
private _posY = _margin;
private _ctrlFill = controlNull;
private _stack = allControls _ctrlGroup select {
    // Filter valid controls
    private _cfgX = _cfgCtrlGroup >> "Controls" >> ctrlClassName _x;
    ctrlParentControlsGroup _x == _ctrlGroup && // Only directchildren of this group
    !isNull _cfgX && // Controls in a group that is part of the given group are also counter, filter those
    getNumber (_cfgX >> "stackDisable") == 0 // config attribute to disable handling as stacked control
};

{
    private _cfgX = _cfgCtrlGroup >> "Controls" >> ctrlClassName _x;
    _x ctrlSetPositionY _posY;
    if (getNumber (_cfgX >> "stackFill") == 1) then {
        // This control fills the remaining space
        // _hFill = Height of controls group - y position of the control - bottom margin
        private _hFill = (ctrlPosition _ctrlGroup select 3) - _posY - _margin;
        _stack select [_forEachIndex+1, count _stack] apply {
            // Collect the height with margin of the following controls
            _hFill = _hFill - (ctrlPosition _x select 3) - _margin
        };
        _x ctrlSetPositionH _hFill;
    };
    _x ctrlCommit 0;
    _posY = _posY + (ctrlPosition _x select 3) + _margin;
} forEach _stack;

