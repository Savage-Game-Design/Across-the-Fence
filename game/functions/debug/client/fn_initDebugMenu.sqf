#include "\a3\ui_f\hpp\defineCommonGrids.inc"
/*
    File: fn_initDebugMenu.sqf
    Author: Savage Game Design
    Date: 2023-09-07
    Last Update: 2024-09-21
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

// internal functions
// should be only executed in the context of debug menu tab handlers
vgm_c_debugMenu_addSection = {
    params ["_title", "_fnc_addData"];
    if (isNil "_sections") then {_sections = 0};

    private _ctrlLabel = _display ctrlCreate ["RscText", -1, _ctrlContainer];
    _ctrlLabel ctrlSetText format ["%1:", _title];
    _ctrlLabel ctrlSetPosition [0, _sections * _sectionH, _w, GUI_GRID_H];
    _ctrlLabel ctrlCommit 0;

    private _ctrlList = _display ctrlCreate ["RscListNBox", -1, _ctrlContainer];
    _ctrlList ctrlSetPosition [0, _sections * _sectionH + GUI_GRID_H, _w, _sectionH - GUI_GRID_H];
    _ctrlList ctrlCommit 0;

    _ctrlList lnbSetColumnsPos [0.1, 0.5];

    _ctrlList call _fnc_addData;
    _sections = _sections + 1;
};

vgm_c_debugMenu_receiveMissionData = {
    params ["_missions"];
    private _ctrlTree = uiNamespace getVariable ["vgm_debugMenu_ctrlMissionTree", controlNull];

    private _pServer = _ctrlTree getVariable ["vgm_pServer", []];
    for "_i" from (_ctrlTree tvCount _pServer) to 1 step -1 do {
        _ctrlTree tvDelete (_pServer + [_i-1]);
    };

    {
        [_pServer, _x, _y] call vgm_c_debugMenu_missionTvAdd;
    } forEach _missions;

    _ctrlTree tvSortAll [_pServer];
};

vgm_c_debugMenu_missionTvAdd = {
    params ["_index", "_key", "_val"];
    if (_key isEqualTo "_netmap") exitWith {};
    _key = format ["%1", _key];

    if (_val isEqualType []) exitWith {
        private _pItem = [_ctrlTree tvAdd [_index, _key]];
        {
            [_index + _pItem, _forEachIndex, _x] call vgm_c_debugMenu_missionTvAdd;
        } forEach _val;
    };

    if (_val isEqualType createHashMap) exitWith {
        private _pItem = [_ctrlTree tvAdd [_index, _key]];
        {
            [_index + _pItem, _x, _y] call vgm_c_debugMenu_missionTvAdd;
        } forEach _val;
    };

    _ctrlTree tvAdd [_index, format ["%1 - %2", _key, _val]];
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

    {ctrlDelete _x} forEach (_display getVariable ["vgm_debugControls", []]);
    _display setVariable ["vgm_debugControls", [_ctrlBg, _ctrlTabs]];

    //----- add tabs logic
    private _fnc_tabPlayer = {
        params ["_display", "_ctrlContainer", "_containerPosition"];
        _containerPosition params ["", "", "_w", "_h"];
        private _unit = player;

        private _sectionH = _h/3;
        private _sections = 0;

        ["Status effects", {
            {
                private _status = _x;
                private _state = [_unit, _status] call vgm_c_fnc_statusEffect_get;

                private _row = _this lnbAddRow [
                    _status,
                    str _state
                ];

                private _reasons = _unit getVariable "vgm_c_statusEffect_currentEffects" get _status;
                _this lnbSetTooltip [[_row, 0], _reasons joinString endl];
            } forEach vgm_c_statusEffect_allEffects;
        }] call vgm_c_debugMenu_addSection;

        ["Coefficients", {
            _this lnbSetColumnsPos [0.1, 0.5, 0.65];
            {
                private _coefficient = _x;
                private _baseValue = _y get "baseValue";
                private _value = [_unit, _coefficient] call vgm_c_fnc_coefficient_get;

                private _row = _this lnbAddRow [
                    _coefficient,
                    str _value,
                    str _baseValue
                ];

                private _reasons = _unit getVariable "vgm_c_coefficient_currentCoefficients" get _coefficient apply {
                    [_x, _y#0, ["", "persistent"] select _y#1] joinString " "
                };
                private _overrides = _unit getVariable "vgm_c_coefficient_currentCoefficientsOverrides" get _coefficient apply {
                    ["override", _x] joinString " "
                };
                _this lnbSetTooltip [[_row, 0], trim ([_reasons joinString endl, _overrides joinString endl] joinString endl)];
            } forEach vgm_c_coefficient_allCoefficients;
        }] call vgm_c_debugMenu_addSection;

        ["Variables", {
            {
                private _variable = _x;
                private _value = _unit getVariable [_x, "nil"];

                private _row = _this lnbAddRow [
                    _variable,
                    str _value
                ];
            } forEach [
                "vgm_stamina",
                "vgm_stamina_exhausted"
            ];
        }] call vgm_c_debugMenu_addSection;
    };

    private _fnc_tabPersistence = {
        params ["_display", "_ctrlContainer", "_containerPosition"];
        _containerPosition params ["", "", "_w", "_h"];
        private _unit = player;

        private _sectionH = _h/4;
        private _sections = 0;

        // leveling data
        ["Leveling", {
            private _levelingData = _unit getVariable "vgm_g_levelingData";
            private _level = _levelingData get "level";
            _this lnbAddRow ["level", str _level];
            _this lnbAddRow ["xp", str (_levelingData get "experience")];
            _this lnbAddRow ["next level xp", [
                str (vgm_g_leveling_levelsHashMap get _level get "experienceThreshold"),
                "max"
            ] select (_level >= vgm_g_leveling_maxLvl)];
        }] call vgm_c_debugMenu_addSection;

        // skills data
        ["Skills", {
            private _skillsData = _unit getVariable "vgm_g_skillsData";
            _this lnbAddRow ["skill points", str ([] call vgm_c_fnc_skills_getSkillPoints)];
            _this lnbAddRow ["spent skill points", str (_skillsData get "skillPointsSpent")];
        }] call vgm_c_debugMenu_addSection;
    };

    private _fnc_tabMedical = {
        params ["_display", "_ctrlContainer", "_containerPosition"];
        _containerPosition params ["", "", "_w", "_h"];
        private _unit = player;

        private _sectionH = _h/3;
        private _sections = 0;

        // medical data
        ["Medical", {
            _ctrlList lnbAddRow ["dmg modifiers", str count vgm_c_medical_damageModifiers];
            _ctrlList lnbAddRow ["dmg structural", str damage _unit];
            _ctrlList lnbAddRow ["visual bleed", str getBleedingRemaining _unit];
        }] call vgm_c_debugMenu_addSection;

        // wounds
        ["Wounds", {
            private _woundVarPrefix = "vgm_g_medical_wound";
            {
                private _bodyPart = _x select [count _woundVarPrefix + 1];
                _this lnbAddRow [_bodyPart, str (_unit getVariable [_x, -1])];
            } forEach (allVariables _unit select {_x find _woundVarPrefix == 0});
        }] call vgm_c_debugMenu_addSection;
    };

    private _fnc_tabMission = {
        params ["_display", "_ctrlContainer", "_containerPosition"];
        _containerPosition params ["", "", "_w", "_h"];
        private _hSearch = 1 * GUI_GRID_H;

        private _ctrlSearch = _display ctrlCreate ["RscEdit", getNumber (configFile >> "RscTreeSearch" >> "idcSearch"), _ctrlContainer];
        _ctrlSearch ctrlSetPosition [0, 0, _w, _hSearch];
        _ctrlSearch ctrlCommit 0;

        private _ctrlTree =_display ctrlCreate ["RscTreeSearch", -1, _ctrlContainer];
        _ctrlTree ctrlSetPosition [0, _hSearch, _w, _h - _hSearch];
        _ctrlTree ctrlCommit 0;
        uiNamespace setVariable ["vgm_debugMenu_ctrlMissionTree", _ctrlTree];

        private _pPublic = [_ctrlTree tvAdd [[], "Client"]];
        {
            [_pPublic, _x, _y] call vgm_c_debugMenu_missionTvAdd;
        } forEach ([] call VGM_C_fnc_missions_getCurrentMission);

        private _pServer = [_ctrlTree tvAdd [[], "Server"]];
        _ctrlTree tvAdd [_pServer, "Loading..."];

        // Load all missions data from server on demand
        _ctrlTree setVariable ["vgm_pServer", _pServer];
        _ctrlTree ctrlAddEventHandler ["TreeExpanded", {
            params ["_ctrlTree", "_selectionPath"];
            if (count _selectionPath > 1) exitWith {};
            if ((_ctrlTree tvText _selectionPath) != "Server") exitWith {};

            // clear all current entries
            for "_i" from (_ctrlTree tvCount _selectionPath) to 1 step -1 do {
                _ctrlTree tvDelete (_selectionPath + [_i-1]);
            };
            _ctrlTree tvAdd [_selectionPath, "Loading..."];
            // request missions data from server
            [{
                private _missions = localNamespace getVariable "vgm_missions";

                [_missions] remoteExecCall ["vgm_c_debugMenu_receiveMissionData", remoteExecutedOwner];
            }] remoteExec ["call", 2];
        }];

        _ctrlTree tvExpand _pPublic;
        _ctrlTree tvSortAll [_pPublic];
    };

    //----- add tabs
    private _tabs = [
        ["Player state", _fnc_tabPlayer],
        ["Persistence", _fnc_tabPersistence],
        ["Medical state", _fnc_tabMedical],
        ["Mission", _fnc_tabMission]
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
        _ctrlButton setVariable ["vgm_index", _forEachIndex];

        private _fnc_buttonHandler = {
            params ["_ctrlButton"];
            private _display = ctrlParent _ctrlButton;
            private _position = _ctrlButton getVariable "vgm_position";
            private _fnc_handler = _ctrlButton getVariable "vgm_handler";
            private _menuIndex = _ctrlButton getVariable "vgm_index";

            ctrlDelete (_display getVariable ["vgm_currentTab", controlNull]);
            private _ctrlContainer = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
            _ctrlContainer ctrlSetPosition _position;
            _ctrlContainer ctrlCommit 0;
            _display setVariable ["vgm_currentTab", _ctrlContainer];
            uiNamespace setVariable ["vgm_debugMenu_lastIndex", _menuIndex];

            [_display, _ctrlContainer, _position] call _fnc_handler;
        };

        _ctrlButton ctrlAddEventHandler ["ButtonClick", _fnc_buttonHandler];
        if (_forEachIndex == (uiNamespace getVariable ["vgm_debugMenu_lastIndex", 0])) then {_ctrlButton call _fnc_buttonHandler};
    } forEach _tabs;
}] call BIS_fnc_addScriptedEventHandler;
