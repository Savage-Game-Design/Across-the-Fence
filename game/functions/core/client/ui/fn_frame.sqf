/*
    File: fn_frame.sqf
    Author: Terra
    Date: 2023-02-07
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
#include "..\displays\macros.inc"
params ["_ctrlFrameGroup", "_cfgFrameGroup"];
private _display = ctrlParent _ctrlFrameGroup;
private _color = getArray (_cfgFrameGroup >> "frameColor");
private _bw = getNumber (_cfgFrameGroup >> "frameWidth");
private _bh = getNumber (_cfgFrameGroup >> "frameHeight");
private _idc = getNumber (_cfgFrameGroup >> "frameIDC");
// Move the controls group so that it does not cover the framing controls
private _ctrlFramed = if (_idc > 0) then {
    private _ctrlParentFrameGroup = ctrlParentControlsGroup _ctrlFrameGroup;
    if (!isNull _ctrlParentFrameGroup) then {
        // Frame group is part of a controls group
        _ctrlParentFrameGroup controlsGroupCtrl _idc
    } else {
        // Frame group is direct child of display
        _display displayCtrl _idc
    };
} else {
    _ctrlFrameGroup
};
if (isNull _ctrlFramed) exitWith {
    ["No control (idc:%1) found for frame!", _idc] call BIS_fnc_error;
};
ctrlPosition _ctrlFramed params ["_cx", "_cy", "_cw", "_ch"];
private _borderCtrls = [];
private _createParams = ["VGM_ctrlBackground", -1];
private _ctrlParent = ctrlParentControlsGroup _ctrlFramed;
if (!isNull _ctrlParent) then {
    _createParams pushBack _ctrlParent;
};
for "_i" from 0 to 3 do {
    _borderCtrls pushBack (_display ctrlCreate _createParams);
};
_borderCtrls params ["_ctrlT", "_ctrlL", "_ctrlR", "_ctrlB"];
_ctrlT ctrlSetPosition [_cx - _bw, _cy - _bh, _cw + 2 * _bw, _bh];
_ctrlL ctrlSetPosition [_cx - _bw, _cy, _bw, _ch];
_ctrlR ctrlSetPosition [_cx + _cw, _cy, _bw, _ch];
_ctrlB ctrlSetPosition [_cx - _bw, _cy + _ch, _cw + 2 * _bw, _bh];
_borderCtrls apply {
    _x ctrlCommit 0;
    _x ctrlSetBackgroundColor _color;
};
ctrlDelete _ctrlFrameGroup; // not needed anymore

