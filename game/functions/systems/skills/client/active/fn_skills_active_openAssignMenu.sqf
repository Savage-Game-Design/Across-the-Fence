#include "\a3\ui_f\hpp\defineCommonGrids.inc"
/*
    File: fn_skills_active_openAssignMenu.sqf
    Author: veteran29
    Date: 2023-01-30
    Last Update: 2023-01-31
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

// #define DEBUG_PAINT_TREE_LAYOUT

#define GUI_GRID_W_FULL (GUI_GRID_W * 40)
#define GUI_GRID_H_FULL (GUI_GRID_H * 25)

#define SIZE_DIALOG [GUI_GRID_CENTER_X, GUI_GRID_CENTER_Y, GUI_GRID_W_FULL, GUI_GRID_H_FULL]

private _display = findDisplay 46 createDisplay "RscDisplayEmpty";

private _ctrlBg = _display ctrlCreate ["RscText", -1];
_ctrlBg ctrlSetPosition SIZE_DIALOG;
_ctrlBg ctrlSetBackgroundColor [0, 0, 0, 0.3];
_ctrlBg ctrlCommit 0;

private _ctrlGrpMain = _display ctrlCreate ["RscControlsGroup", -1];
_ctrlGrpMain ctrlSetPosition [GUI_GRID_CENTER_X, GUI_GRID_CENTER_Y, GUI_GRID_W_FULL / 2, GUI_GRID_H_FULL];
_ctrlGrpMain ctrlCommit 0;

private _ctrlPrimarySkillList = _display ctrlCreate ["vgm_RscListBoxDraggable", 2001, _ctrlGrpMain];
_ctrlPrimarySkillList ctrlSetPosition [0, 0, GUI_GRID_W_FULL / 2, GUI_GRID_H_FULL / 3 * 2];
_ctrlPrimarySkillList ctrlSetBackgroundColor [0.2, 0.1, 0.1, 0.5];
_ctrlPrimarySkillList ctrlCommit 0;

private _ctrlUltimateSkillList = _display ctrlCreate ["vgm_RscListBoxDraggable", 2002, _ctrlGrpMain];
_ctrlUltimateSkillList ctrlSetPosition [0, GUI_GRID_H_FULL / 3 * 2, GUI_GRID_W_FULL / 2, GUI_GRID_H_FULL / 3 * 1];
_ctrlUltimateSkillList ctrlSetBackgroundColor [0.2, 0.2, 0.1, 0.5];
_ctrlUltimateSkillList ctrlCommit 0;

// draw list of primary skills
{
    private _idx = _ctrlPrimarySkillList lbAdd (_x get "displayName");
    _ctrlPrimarySkillList lbSetData [_idx, str (_x get "path")];
} forEach (values vgm_c_skills_active_list select {!(_x get "isUltimate")});

// draw list of ultimate skills
{
    private _idx = _ctrlUltimateSkillList lbAdd (_x get "displayName");
    _ctrlUltimateSkillList lbSetData [_idx, str (_x get "path")];
} forEach (values vgm_c_skills_active_list select {_x get "isUltimate"});

private _fnc_drawSlot = {
    params ["_ctrlContainer", "_slot", "_index"];
    ctrlPosition _ctrlContainer params ["", "", "_w", "_h"];
    private _display = ctrlParent _ctrlContainer;

    _ctrlContainer ctrlAddEventHandler ["LBDrop", {
        params ["_ctrlContainer", "", "", "", "_listboxInfo"];
        (_listboxInfo select 0) params ["_lbText", "_lbValue", "_lbData"];

        private _slot = _ctrlContainer getVariable "vgm_skills_slot";
        private _skill = parseSimpleArray _lbData call vgm_g_fnc_skills_getByPath;
        if (_slot == "ultimate" && {!(_skill get "isUltimate")}) exitWith {
            hint "Can't put ultimate skill in primary skill slot!";
        };

        vgm_c_skills_active_slots get _slot set ["skill", _skill];
    }];

    #define SKILL_ICON_W (GUI_GRID_H * 2.5)
    #define SKILL_ICON_H SKILL_ICON_W
    #define SKILL_ICON_LABEL_H (GUI_GRID_H * 1.5)

    private _skill = vgm_c_skills_active_slots get _slot get "skill";

    private _ctrlSkillIcon = _display ctrlCreate ["RscActivePictureKeepAspect", -1, _ctrlContainer];
    _ctrlSkillIcon ctrlSetTextColor [1,1,1,1];
    _ctrlSkillIcon ctrlSetText (_skill getOrDefault ["icon", "\vn\ui_f_vietnam\ui\wheelmenu\img\ui_icon_e_ca.paa"]);
    _ctrlSkillIcon ctrlSetPosition [_w/2.5, GUI_GRID_H, SKILL_ICON_W, SKILL_ICON_H];
    _ctrlSkillIcon ctrlCommit 0;

    private _ctrlLabel = _display ctrlCreate ["RscStructuredText", -1, _ctrlContainer];
    _ctrlLabel ctrlSetPosition [0, GUI_GRID_H, _w/2, _h - GUI_GRID_H];
    _ctrlLabel ctrlSetText (_skill getOrDefault ["displayName", "Drag & Drop skill to assign"]);
    _ctrlLabel ctrlCommit 0;

    #ifdef DEBUG_PAINT_TREE_LAYOUT
        private _ctrlBg = _display ctrlCreate ["RscText", -1, _ctrlContainer];
        ctrlPosition _ctrlContainer params ["", "", "_w", "_h"];
        _ctrlBg ctrlSetBackgroundColor [
            [0,1] select (_index == 0),
            [0,1] select (_index == 1),
            [0,1] select (_index == 2),
            1
        ];
        _ctrlBg ctrlSetPosition [0, 0, _w, _h];
        _ctrlBg ctrlCommit 0;
    #endif
};

// draw skill slots
{
    private _ctrlContainer = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
    _ctrlContainer ctrlSetPosition [
        GUI_GRID_CENTER_X + (GUI_GRID_W_FULL / 2),
        GUI_GRID_CENTER_Y + (GUI_GRID_H_FULL / 3 * _forEachIndex),
        GUI_GRID_W_FULL / 2,
        GUI_GRID_H_FULL / 3
    ];
    _ctrlContainer ctrlCommit 0;

    _ctrlContainer setVariable ["vgm_skills_slot", _x];
    [_ctrlContainer, _x, _forEachIndex] call _fnc_drawSlot;
} forEach [
    "ability1",
    "ability2",
    "ultimate"
];
