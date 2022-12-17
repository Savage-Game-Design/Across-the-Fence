#include "\a3\ui_f\hpp\defineCommonGrids.inc"
/*
    File: fn_openSkillTree.sqf
    Author:
    Date: 2022-12-16
    Last Update: 2022-12-17
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [] call vgm_c_fnc_skills_openSkillTree.sqf
 */

#define GUI_GRID_W_FULL (GUI_GRID_W * 40)
#define GUI_GRID_H_FULL (GUI_GRID_H * 25)

#define SIZE_DIALOG [GUI_GRID_CENTER_X, GUI_GRID_CENTER_Y, GUI_GRID_W_FULL, GUI_GRID_H_FULL]

private _display = findDisplay 46 createDisplay "RscDisplayEmpty";

private _ctrlBg = _display ctrlCreate ["RscText", -1];
_ctrlBg ctrlSetPosition SIZE_DIALOG;
_ctrlBg ctrlSetBackgroundColor [0, 0, 0, 0.3];
_ctrlBg ctrlCommit 0;

private _ctrlGrpMain = _display ctrlCreate ["RscControlsGroup", -1];
_ctrlGrpMain ctrlSetPosition SIZE_DIALOG;
_ctrlGrpMain ctrlCommit 0;

vgm_skills_ui_currentTabGrp = controlNull;

{
    private _ctrlTab = _display ctrlCreate ["RscButton", -1, _ctrlGrpMain];
    _ctrlTab ctrlSetText (_y get "displayName");
    _ctrlTab ctrlSetPosition [(GUI_GRID_W_FULL / 3) * _forEachIndex, 0, GUI_GRID_W_FULL / 3, GUI_GRID_H * 2];
    _ctrlTab ctrlCommit 0;

    private _ctrlGrpTree = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrpMain];
    _ctrlGrpTree ctrlSetPosition [0, GUI_GRID_H * 2, GUI_GRID_W_FULL, GUI_GRID_H * 23];
    _ctrlGrpTree ctrlCommit 0;
    _ctrlGrpTree ctrlShow false;

    _ctrlTab setVariable ["vgm_ctrlGrpTree", _ctrlGrpTree];
    _ctrlTab ctrlAddEventHandler ["ButtonClick", {
        params ["_ctrlButton"];
        // hide currently shown tab content
        vgm_skills_ui_currentTabGrp ctrlShow false;

        // show clicked tab content
        private _ctrlGrpTree = _ctrlButton getVariable "vgm_ctrlGrpTree";
        vgm_skills_ui_currentTabGrp = _ctrlGrpTree;
        _ctrlGrpTree ctrlShow true;
    }];

    private _ctrlTab = _display ctrlCreate ["RscButton", -1, _ctrlGrpTree];
    _ctrlTab ctrlSetText (_y get "displayName");
    _ctrlTab ctrlSetPosition [0, GUI_GRID_H, GUI_GRID_W_FULL, GUI_GRID_H * 22];
    _ctrlTab ctrlCommit 0;

    if (_forEachIndex == 0) then {
        vgm_skills_ui_currentTabGrp = _ctrlGrpTree;
        _ctrlGrpTree ctrlShow true;
    };

} forEach vgm_skills_treesHash;
