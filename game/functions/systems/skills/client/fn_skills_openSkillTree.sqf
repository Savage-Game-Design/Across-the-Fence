#include "\a3\ui_f\hpp\defineCommonGrids.inc"
/*
    File: fn_openSkillTree.sqf
    Author:
    Date: 2022-12-16
    Last Update: 2022-12-20
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
_ctrlGrpMain ctrlSetPosition SIZE_DIALOG;
_ctrlGrpMain ctrlCommit 0;

vgm_skills_ui_currentTabGrp = controlNull;

private _fnc_draw = {
    params ["_display", "_skillTree","_index"];

    private _ctrlTab = _display ctrlCreate ["RscButton", -1, _ctrlGrpMain];
    _ctrlTab ctrlSetText (_skillTree get "displayName");
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

    if (_index == 0) then {
        vgm_skills_ui_currentTabGrp = _ctrlGrpTree;
        _ctrlGrpTree ctrlShow true;
    };

    [_ctrlGrpTree, _skillTree] call _fnc_drawSkillTree;
};

private _fnc_drawSkillTree = {
    params ["_ctrlGrp", "_skillTree", ["_prevTrees", []]];
    private _display = ctrlParent _ctrlGrp;

    {
        ctrlDelete _x;
    } forEach allControls _ctrlGrp;

    if (count _prevTrees > 0) then {
        private _ctrlPrevTreeBtn = _display ctrlCreate ["RscButton", -1, _ctrlGrp];
        _ctrlPrevTreeBtn ctrlSetText (_prevTrees#0 get "displayName");
        _ctrlPrevTreeBtn ctrlSetPosition [
            (GUI_GRID_W_FULL - GUI_GRID_W * 4) / 2, GUI_GRID_H * 1,
            GUI_GRID_W * 4, GUI_GRID_H * 2
        ];
        _ctrlPrevTreeBtn ctrlCommit 0;

        _ctrlPrevTreeBtn setVariable ["vgm_params", [_prevTrees]];
        _ctrlPrevTreeBtn ctrlAddEventHandler ["ButtonClick", {
            params ["_ctrlBtn"];
            (_ctrlBtn getVariable "vgm_params") params ["_prevTrees"];
            private _ctrlGrp = ctrlParentControlsGroup _ctrlBtn;

            private _prevTree = _prevTrees#0;
            [vgm_fnc_drawSkillTree, [_ctrlGrp, _prevTree, _prevTrees - [_prevTree]]] call vgm_g_fnc_execNextFrame;
        }];
    };

    private _lastCtrlSkillGrp = controlNull;
    {
        #define SKILL_TREE_W (GUI_GRID_W_FULL / 2)
        #define SKILL_TREE_ROW_H (GUI_GRID_H * 4)
        #define SKILL_TREE_COL_W (SKILL_TREE_W /2)

        #define SKILL_ICON_W (GUI_GRID_H * 2.5)
        #define SKILL_ICON_H SKILL_ICON_W
        #define SKILL_ICON_LABEL_H (GUI_GRID_H * 1.5)

        private _skillTier = _x;
        private _rowIdx = _forEachIndex;
        {
            private _skill = _x;
            private _colIdx = _forEachIndex;

            private _ctrlSkillGrp = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1, _ctrlGrp];
            _ctrlSkillGrp ctrlSetPosition [
                (GUI_GRID_W_FULL - SKILL_TREE_W) / 2 + SKILL_TREE_COL_W * (_colIdx mod 2),
                (GUI_GRID_H * 3) + (SKILL_TREE_ROW_H * _rowIdx),
                SKILL_TREE_COL_W, SKILL_TREE_ROW_H
            ];
            _ctrlSkillGrp ctrlCommit 0;
            _lastCtrlSkillGrp = _ctrlSkillGrp;

            private _ctrlSkillIcon = _display ctrlCreate ["RscActivePictureKeepAspect", -1, _ctrlSkillGrp];
            _ctrlSkillIcon ctrlSetText (_skill get "icon");
            _ctrlSkillIcon ctrlSetPosition [(SKILL_TREE_COL_W - SKILL_ICON_W) / 2, 0, SKILL_ICON_W, SKILL_ICON_H];
            _ctrlSkillIcon ctrlCommit 0;

            private _ctrlSkillLabel = _display ctrlCreate ["RscStructuredText", -1, _ctrlSkillGrp];
            _ctrlSkillLabel ctrlSetStructuredText parseText format ["<t align='center'>%1</t>", _skill get "displayName"];
            _ctrlSkillLabel ctrlSetPosition [0, SKILL_ICON_H, SKILL_TREE_COL_W, SKILL_ICON_LABEL_H];
            _ctrlSkillLabel ctrlCommit 0;

            #ifdef DEBUG_PAINT_TREE_LAYOUT
                private _ctrlDebug = _display ctrlCreate ["RscText", -1, _ctrlSkillGrp];
                _ctrlDebug ctrlSetText format ["%1-%2", _rowIdx, _colIdx];
                _ctrlDebug ctrlSetBackgroundColor [0, _colIdx mod 2 ,_rowIdx mod 2 , 0.3];
                _ctrlDebug ctrlSetPosition [0, 0, SKILL_TREE_COL_W, SKILL_TREE_ROW_H];
                _ctrlDebug ctrlCommit 0;
            #endif
        } forEach _skillTier;
    } forEach (_skillTree get "skills");

    // position the bottom buttons relative to last skills row
    ctrlPosition _lastCtrlSkillGrp params ["", "_y", "", "_h"];
    private _btnBaseY = _y + _h;

    {
        private _colIdx = _forEachIndex;

        private _ctrlSubtreeBtn = _display ctrlCreate ["RscButton", -1, _ctrlGrp];
        _ctrlSubtreeBtn ctrlSetText (_y get "displayName");
        _ctrlSubTreeBtn ctrlSetPosition [
            [
                (GUI_GRID_W_FULL - GUI_GRID_W_FULL / 4) / 2, // left col
                GUI_GRID_W_FULL - ((GUI_GRID_W_FULL - GUI_GRID_W_FULL / 4) / 2) - GUI_GRID_W * 4 // righ col
            ] select (_colIdx mod 2),
            _btnBaseY,
            GUI_GRID_W * 4, GUI_GRID_H * 2
        ];
        _ctrlSubtreeBtn ctrlCommit 0;

        _ctrlSubtreeBtn setVariable ["vgm_params", [_y, [_skillTree] + _prevTrees]];
        _ctrlSubtreeBtn ctrlAddEventHandler ["ButtonClick", {
            params ["_ctrlBtn"];
            (_ctrlBtn getVariable "vgm_params") params ["_skillTree", "_prevTrees"];
            private _ctrlGrp = ctrlParentControlsGroup _ctrlBtn;

            [vgm_fnc_drawSkillTree, [_ctrlGrp, _skillTree, _prevTrees]] call vgm_g_fnc_execNextFrame;
        }];
    } forEach (_skillTree get "subtrees");
};
vgm_fnc_drawSkillTree = _fnc_drawSkillTree;

// ensure that we display tabs in config order, hashmaps are unordered
private _skillTreeClasses = "true" configClasses (missionConfigFile >> "vgm_skillTrees") apply {configName _x};

{
    [_display, vgm_skills_treesHash get _x, _forEachIndex] call _fnc_draw;
} forEach _skillTreeClasses;
