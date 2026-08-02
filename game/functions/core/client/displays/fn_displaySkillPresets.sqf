#include "macros.inc"

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad": {
        params ["_display"];

        uiNamespace setVariable ["vgm_displaySkillPresets", _display];

        // Populate list with 5 slots
        ["refreshUI", [_display]] call vgm_c_fnc_displaySkillPresets;
    };

    case "onUnload": {
        uiNamespace setVariable ["vgm_displaySkillPresets", displayNull];
    };

    case "refreshUI": {
        params ["_display"];

        private _ctrlList = _display displayCtrl VGM_IDC_DISPLAYSKILLPRESETS_PRESETLIST;
        private _prevSel = lbCurSel _ctrlList;

        lbClear _ctrlList;

        private _presets = missionNamespace getVariable ["vgm_c_skillPresets_data", createHashMap];

        for "_i" from 0 to 4 do {
            private _presetData = _presets getOrDefault [str _i, nil];
            private _label = if (isNil "_presetData") then {
                format ["%1. %2", _i + 1, localize "STR_VGM_SKILL_PRESETS_EMPTY"]
            } else {
                format ["%1. %2", _i + 1, _presetData get "name"]
            };
            _ctrlList lbAdd _label;
        };

        // Restore selection or default to first
        if (_prevSel < 0 || _prevSel > 4) then { _prevSel = 0; };
        _ctrlList lbSetCurSel _prevSel;
    };

    case "selectPreset": {
        params ["_ctrlList", "_index"];

        if (_index < 0) exitWith {};

        private _display = ctrlParent _ctrlList;
        private _ctrlSummary = _display displayCtrl VGM_IDC_DISPLAYSKILLPRESETS_SUMMARY;
        private _ctrlName = _display displayCtrl VGM_IDC_DISPLAYSKILLPRESETS_NAMEINPUT;

        private _presets = missionNamespace getVariable ["vgm_c_skillPresets_data", createHashMap];
        private _presetData = _presets getOrDefault [str _index, nil];

        if (isNil "_presetData") then {
            _ctrlSummary ctrlSetStructuredText parseText (localize "STR_VGM_SKILL_PRESETS_NO_PRESET");
            _ctrlName ctrlSetText "";
        } else {
            private _name = _presetData get "name";
            private _skillPaths = _presetData get "skillPaths";

            _ctrlName ctrlSetText _name;

            // Build summary: group by tree
            private _treeMap = createHashMap;
            private _totalSP = 0;
            {
                private _treeName = _x select 0;
                private _skill = _x call vgm_g_fnc_skills_getByPath;

                if (!isNil "_skill") then {
                    private _cost = _skill getOrDefault ["cost", 0];
                    _totalSP = _totalSP + _cost;

                    private _treeEntry = _treeMap getOrDefault [_treeName, [0, 0], true];
                    _treeEntry set [0, (_treeEntry select 0) + 1];
                    _treeEntry set [1, (_treeEntry select 1) + _cost];
                };
            } forEach _skillPaths;

            // Format summary text
            private _lines = [format ["<t size='1.2'>%1</t>", format [localize "STR_VGM_SKILL_PRESETS_SUMMARY_HEADER", _name]]];
            _lines pushBack "";

            {
                private _treeName = _x;
                private _treeEntry = _y;
                _treeEntry params ["_count", "_sp"];

                // Get display name from skill tree config
                private _treeData = [_treeName] call vgm_g_fnc_skills_getByPath;
                private _displayName = if (!isNil "_treeData") then {
                    _treeData getOrDefault ["displayName", _treeName]
                } else {
                    _treeName
                };

                _lines pushBack format [localize "STR_VGM_SKILL_PRESETS_SUMMARY_TREE", _displayName, _count, _sp];
            } forEach _treeMap;

            _lines pushBack "";
            _lines pushBack format ["<t color='#D09B43'>%1</t>", format [localize "STR_VGM_SKILL_PRESETS_SUMMARY_TOTAL", count _skillPaths, _totalSP]];

            _ctrlSummary ctrlSetStructuredText parseText (_lines joinString "<br/>");
        };
    };

    case "save": {
        params ["_ctrlBtn"];

        private _display = ctrlParent _ctrlBtn;
        private _ctrlList = _display displayCtrl VGM_IDC_DISPLAYSKILLPRESETS_PRESETLIST;
        private _ctrlName = _display displayCtrl VGM_IDC_DISPLAYSKILLPRESETS_NAMEINPUT;
        private _index = lbCurSel _ctrlList;

        if (_index < 0) exitWith {};

        private _name = ctrlText _ctrlName;
        if (_name isEqualTo "") exitWith {
            hint localize "STR_VGM_SKILL_PRESETS_NAME_REQUIRED";
        };

        // Check player has skills
        private _skillsData = player getVariable ["vgm_g_skillsData", createHashMap];
        private _skillPaths = _skillsData getOrDefault ["skillPaths", []];
        if (count _skillPaths == 0) exitWith {
            hint localize "STR_VGM_SKILL_PRESETS_NO_SKILLS";
        };

        [_index, _name] call vgm_c_fnc_skillPresets_requestSave;
    };

    case "load": {
        params ["_ctrlBtn"];

        private _display = ctrlParent _ctrlBtn;
        private _ctrlList = _display displayCtrl VGM_IDC_DISPLAYSKILLPRESETS_PRESETLIST;
        private _index = lbCurSel _ctrlList;

        if (_index < 0) exitWith {};

        // Check slot is not empty
        private _presets = missionNamespace getVariable ["vgm_c_skillPresets_data", createHashMap];
        private _presetData = _presets getOrDefault [str _index, nil];
        if (isNil "_presetData") exitWith {
            hint localize "STR_VGM_SKILL_PRESETS_NO_PRESET";
        };

        // Close dialog and send load request
        _display closeDisplay IDC_OK;
        [_index] call vgm_c_fnc_skillPresets_requestLoad;
    };

    case "delete": {
        params ["_ctrlBtn"];

        private _display = ctrlParent _ctrlBtn;
        private _ctrlList = _display displayCtrl VGM_IDC_DISPLAYSKILLPRESETS_PRESETLIST;
        private _index = lbCurSel _ctrlList;

        if (_index < 0) exitWith {};

        // Check slot is not empty
        private _presets = missionNamespace getVariable ["vgm_c_skillPresets_data", createHashMap];
        private _presetData = _presets getOrDefault [str _index, nil];
        if (isNil "_presetData") exitWith {};

        [_index] call vgm_c_fnc_skillPresets_requestDelete;
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
