#include "\a3\ui_f\hpp\defineCommonGrids.inc"
/*
    File: fn_initDebugMenu.sqf
    Author: Savage Game Design
    Date: 2023-09-07
    Last Update: 2023-09-08
    Public: No

    Description:
        Initialize debug menu.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_initDebugMenu
 */

if (!isNil "vgm_c_debugMenuEH") then {
    // makes development easier
    [true, "OnGameInterrupt", vgm_c_debugMenuEH] call BIS_fnc_removeScriptedEventHandler;
};

vgm_c_debugMenuEH = [true, "OnGameInterrupt", {
    params ["_display"];

    // hide pause icon
    (_display displayCtrl 1000) ctrlShow false;
    (_display displayCtrl 1001) ctrlShow false;

    private _wTotal = GUI_GRID_W * 22;
    private _hTabs = GUI_GRID_H * 2;
    private _hContent = GUI_GRID_H * 38;
    private _xBase = (safezoneX + safezoneW) - _wTotal - GUI_GRID_H;
    private _yBase = safezoneY + GUI_GRID_H;

    private _ctrlBg = _display ctrlCreate ["RscText", -1];
    _ctrlBg ctrlSetBackgroundColor [0,0,0,0.6];
    _ctrlBg ctrlSetPosition [_xBase, _yBase, _wTotal, _hTabs + _hContent];
    _ctrlBg ctrlCommit 0;

    private _ctrlTabs = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
    _ctrlTabs ctrlSetPosition [_xBase, _yBase, _wTotal, _hTabs];
    _ctrlTabs ctrlCommit 0;

    //----- add tabs logic
    private _fnc_tabPlayer = {
        params ["_display", "_ctrlContainer", "_containerPosition"];
        _containerPosition params ["", "", "_w", "_h"];
        private _unit = player;

        #define LIST_H (_h/3)
        private _ctrlStatusLabel = _display ctrlCreate ["RscText", -1, _ctrlContainer];
        _ctrlStatusLabel ctrlSetText "Status effects:";
        _ctrlStatusLabel ctrlSetPosition [0, 0, _w, GUI_GRID_H];
        _ctrlStatusLabel ctrlCommit 0;

        private _ctrlStatusList = _display ctrlCreate ["RscListNBox", -1, _ctrlContainer];
        _ctrlStatusList ctrlSetPosition [0, GUI_GRID_H, _w, LIST_H - GUI_GRID_H];
        _ctrlStatusList ctrlCommit 0;

        private _ctrlCoefLabel = _display ctrlCreate ["RscText", -1, _ctrlContainer];
        _ctrlCoefLabel ctrlSetText "Coefficients:";
        _ctrlCoefLabel ctrlSetPosition [0, LIST_H, _w, GUI_GRID_H];
        _ctrlCoefLabel ctrlCommit 0;

        private _ctrlCoefList = _display ctrlCreate ["RscListNBox", -1, _ctrlContainer];
        _ctrlCoefList ctrlSetPosition [0, LIST_H + GUI_GRID_H, _w, LIST_H - GUI_GRID_H];
        _ctrlCoefList ctrlCommit 0;

        private _ctrlVarLabel = _display ctrlCreate ["RscText", -1, _ctrlContainer];
        _ctrlVarLabel ctrlSetText "Variables:";
        _ctrlVarLabel ctrlSetPosition [0, LIST_H * 2, _w, GUI_GRID_H];
        _ctrlVarLabel ctrlCommit 0;

        private _ctrlVarList = _display ctrlCreate ["RscListNBox", -1, _ctrlContainer];
        _ctrlVarList ctrlSetPosition [0, LIST_H * 2 + GUI_GRID_H, _w, LIST_H - GUI_GRID_H];
        _ctrlVarList ctrlCommit 0;

        _ctrlStatusList lnbSetColumnsPos [0.1, 0.5];
        _ctrlCoefList lnbSetColumnsPos [0.1, 0.5, 0.7];
        _ctrlVarList lnbSetColumnsPos [0.1, 0.5];

        // status effects
        {
            private _status = _x;
            private _state = [_unit, _status] call vgm_c_fnc_statusEffect_get;

            private _row = _ctrlStatusList lnbAddRow [
                _status,
                str _state
            ];

            private _reasons = _unit getVariable "vgm_c_statusEffect_currentEffects" get _status;
            _ctrlStatusList lnbSetTooltip [[_row, 0], _reasons joinString endl];
        } forEach vgm_c_statusEffect_allEffects;

        // coefficients
        {
            private _coefficient = _x;
            private _baseValue = _y get "baseValue";
            private _value = [_unit, _coefficient] call vgm_c_fnc_coefficient_get;

            private _row = _ctrlCoefList lnbAddRow [
                _coefficient,
                str _value,
                str _baseValue
            ];

            private _reasons = _unit getVariable "vgm_c_coefficient_currentCoefficients" get _coefficient apply {
                [_x, _y#0, ["", "persistent"] select _y#1] joinString " "
            };
            _ctrlCoefList lnbSetTooltip [[_row, 0], _reasons joinString endl];
        } forEach vgm_c_coefficient_allCoefficients;

        // variables
        {
            private _variable = _x;
            private _value = _unit getVariable [_x, "nil"];

            private _row = _ctrlVarList lnbAddRow [
                _variable,
                str _value
            ];
        } forEach [
            "vgm_stamina",
            "vgm_stamina_exhausted"
        ];
    };

    private _fnc_tabPersistence = {
        params ["_display", "_ctrlContainer", "_containerPosition"];
        _containerPosition params ["", "", "_w", "_h"];
        private _unit = player;

        #define LIST_H (_h/4)
        private _sections = 0;

        // leveling data
        call {
            private _ctrlLabel = _display ctrlCreate ["RscText", -1, _ctrlContainer];
            _ctrlLabel ctrlSetText "Leveling:";
            _ctrlLabel ctrlSetPosition [0, _sections * LIST_H, _w, GUI_GRID_H];
            _ctrlLabel ctrlCommit 0;

            private _ctrlList = _display ctrlCreate ["RscListNBox", -1, _ctrlContainer];
            _ctrlList ctrlSetPosition [0, _sections * LIST_H + GUI_GRID_H, _w, LIST_H - GUI_GRID_H];
            _ctrlList ctrlCommit 0;

            _ctrlList lnbSetColumnsPos [0.1, 0.5];

            private _levelingData = _unit getVariable "vgm_g_levelingData";
            private _level = _levelingData get "level";
            _ctrlList lnbAddRow ["level", str _level];
            _ctrlList lnbAddRow ["xp", str (_levelingData get "experience")];
            _ctrlList lnbAddRow ["next level xp", str (vgm_g_leveling_levelsHashMap get _level get "experienceThreshold")];
        };
        _sections = _sections + 1;

        // skills data
        call {
            private _ctrlLabel = _display ctrlCreate ["RscText", -1, _ctrlContainer];
            _ctrlLabel ctrlSetText "Skills:";
            _ctrlLabel ctrlSetPosition [0, _sections * LIST_H, _w, GUI_GRID_H];
            _ctrlLabel ctrlCommit 0;

            private _ctrlList = _display ctrlCreate ["RscListNBox", -1, _ctrlContainer];
            _ctrlList ctrlSetPosition [0, _sections * LIST_H + GUI_GRID_H, _w, LIST_H - GUI_GRID_H];
            _ctrlList ctrlCommit 0;

            _ctrlList lnbSetColumnsPos [0.1, 0.5];

            private _skillsData = _unit getVariable "vgm_g_skillsData";
            _ctrlList lnbAddRow ["skill points", str ([] call vgm_c_fnc_skills_getSkillPoints)];
            _ctrlList lnbAddRow ["spent skill points", str (_skillsData get "skillPointsSpent")];
        };
        _sections = _sections + 1;
    };

    //----- add tabs
    private _tabs = [
        ["Player state", _fnc_tabPlayer],
        ["Persistence", _fnc_tabPersistence]
    ];

    {
        private _text = _x#0;
        private _fnc_handler = _x#1;

        private _ctrlButton = _display ctrlCreate ["RscButton", -1, _ctrlTabs];
        _ctrlButton ctrlSetText _text;
        private _w = _wTotal / count _tabs;
        private _h = _hTabs;
        _ctrlButton ctrlSetPosition [_forEachIndex * _w, 0, _w, _h];
        _ctrlButton ctrlCommit 0;

        _ctrlButton setVariable ["vgm_position", [_xBase, _yBase + _hTabs, _wTotal, _hContent]];
        _ctrlButton setVariable ["vgm_handler", _fnc_handler];

        private _fnc_buttonHandler = {
            params ["_ctrlButton"];
            private _display = ctrlParent _ctrlButton;
            private _position = _ctrlButton getVariable "vgm_position";
            private _fnc_handler = _ctrlButton getVariable "vgm_handler";

            ctrlDelete (_display getVariable ["vgm_currentTab", controlNull]);
            private _ctrlContainer = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
            _ctrlContainer ctrlSetPosition _position;
            _ctrlContainer ctrlCommit 0;
            _display setVariable ["vgm_currentTab", _ctrlContainer];

            [_display, _ctrlContainer, _position] call _fnc_handler;
        };

        _ctrlButton ctrlAddEventHandler ["ButtonClick", _fnc_buttonHandler];
        if (_forEachIndex == 0) then {_ctrlButton call _fnc_buttonHandler};
    } forEach _tabs;
}] call BIS_fnc_addScriptedEventHandler;
