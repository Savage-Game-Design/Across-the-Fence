#include "macros.inc"

params ["_mode", "_params"];
switch _mode do {
    case "onLoad":{
        _params params ["_display"];
        private _ctrlSkills = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SKILLS;
        _ctrlSkills tvSetCurSel [0];

        ["updateSpAvailableHeader", _display] call vgm_c_fnc_displaySkills;
    };
    // fill left panel with skill trees
    case "initSkillTrees": {
        _params params ["_ctrlSkills"];

        private _fnc_draw = {
            params ["_skillTree", "_skillTreePath", ["_treeViewPath", []]];

            _treeViewPath pushBack (_ctrlSkills tvAdd [_treeViewPath, _skillTree get "displayName"]);
            _ctrlSkills tvSetData [_treeViewPath, str _skillTreePath];

            {
                [_y, (_skillTreePath + [_x]), +_treeViewPath] call _fnc_draw;
            } forEach (_skillTree get "subtreesHash");
        };

        // ensure that we display tabs in config order, hashmaps are unordered
        private _skillTreeClasses = "true" configClasses (missionConfigFile >> "vgm_skillTrees") apply {configName _x};
        private _skillTreesHashMap = missionNamespace getVariable "vgm_skills_treesHashMap";
        {
            private _skillTree = _skillTreesHashMap get _x;
            [_skillTree, [_x]] call _fnc_draw;
        } forEach _skillTreeClasses;
    };
    // fill right panel with skill cards
    case "selectSkillTree": {
        _params params ["_ctrlSkills", "_path"];
        private _display = ctrlParent _ctrlSkills;

        private _ctrlSkillTree = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SKILLTREE;

        private _skillTreePath = parseSimpleArray (_ctrlSkills tvData _path);
        private _skillTree = _skillTreePath call vgm_g_fnc_skills_getByPath;

        // Update header
        [
            "setSkillTreeHeader",
            [
                _display,
                [format [localize "STR_VGM_SKILLS_UI_SKILL_TREE", _skillTree get "displayName"], _skillTree get "description"]
            ]
        ] call vgm_c_fnc_displaySkills;

        // Remove all old controls
        allControls _ctrlSkillTree apply { ctrlDelete _x };
        // Save some coordinates for later use
        ctrlPosition _ctrlSkillTree params ["", "", "_wSkillTree"];
        private _wSkill = getNumber (missionConfigFile >> "VGM_ctrlSkill" >> "w");
        private _hSkill = getNumber (missionConfigFile >> "VGM_ctrlSkill" >> "h");
        private _hBranchV = getNumber (missionConfigFile >> "VGM_ctrlSkillTreeBranchV" >> "h");

        // Start adding from Ultimate to Lowest Level skill
        private _skills = +(_skillTree get "skills");
        reverse _skills;

        private _xPos = 0;
        private _yPos = 0;
        private _previousSkillCount = -1;
        {
            private _levelSkills = _x;
            private _currentSkillCount = count _levelSkills;
            if (_forEachIndex > 0) then {
                // Draw a horizontal line connecting the skills from the
                // previous level to the skills of the current level
                private _ctrlSkillLineH = _display ctrlCreate ["VGM_ctrlSkillTreeBranchH", -1, _ctrlSkillTree];
                private _hlineW = (_previousSkillCount max _currentSkillCount - 1);
                _hlineW = _hlineW * _wSkill + _hlineW * VGM_GRID_W;
                // TODO: Make line just wide enough to touch all vertical lines
                _ctrlSkillLineH ctrlSetPosition [
                    // Middle of tree, go back half the width of the line and a bit
                    // 0.5 * _wSkillTree - 0.5 * _hlineW,
                    0,
                    _yPos,
                    // _hlineW,
                    _wSkillTree,
                    1 * VGM_GRID_H
                ];
                _ctrlSkillLineH ctrlCommit 0;
                _previousSkillCount = _currentSkillCount;
                // spacing below horizontal line
                _yPos = _yPos + 3 * VGM_GRID_H;
            };

            // Center the controls
            _xPos = switch (count _levelSkills) do {
                case 1: { 0.5 * _wSkillTree - 0.5 * _wSkill };
                case 2: { 1/3 * _wSkillTree - 0.5 * _wSkill };
                default { 0 };
            };

            // Iterate over the skills of the current level
            _levelSkills apply {
                private _skill = _x;

                private _xLineV = _xPos + 0.5 * _wSkill - 0.5 * VGM_GRID_W;
                if (_forEachIndex > 0) then {
                    // Draw a vertical line into the top of the skill connecting
                    // it to the horizontal line of the previous iteration
                    private _ctrlSkillLineVTop = _display ctrlCreate ["VGM_ctrlSkillTreeBranchV", -1, _ctrlSkillTree];
                    _ctrlSkillLineVTop ctrlSetPosition [
                        _xLineV,
                        _yPos - _hBranchV
                    ];
                    _ctrlSkillLineVTop ctrlCommit 0;
                };
                // Create controls for skills of this level
                private _ctrlSkill = _display ctrlCreate ["VGM_ctrlSkill", -1, _ctrlSkillTree];
                _ctrlSkill setVariable ["vgm_params", [_skill]];
                if (!(_skill call vgm_g_fnc_skills_canSee)) then {_ctrlSkill ctrlShow false};
                _ctrlSkill ctrlSetPosition [_xPos, _yPos];
                _ctrlSkill ctrlCommit 0;

                private _ctrlDescription = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLDESCRIPTION;
                _ctrlDescription ctrlSetStructuredText parseText (_skill get "displayName");

                private _ctrlUnlock = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLUNLOCK;
                _ctrlUnlock ctrlAddEventHandler ["ButtonClick", {["focusSkill", _this] call vgm_c_fnc_displaySkills}];
                if (_skill call vgm_g_fnc_skills_isKnown) then {
                    _ctrlUnlock ctrlSetText "\a3\ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
                };

                private _ctrlCost = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLCOST;
                _ctrlCost ctrlSetText format ["%1 SP", _skill get "cost"];

                // Create a vertical line going into the bottom of the skill
                // and connecting it to the horizontal line below
                if (_skill call vgm_g_fnc_skills_canSee) then {
                    private _ctrlSkillLineVBottom = _display ctrlCreate ["VGM_ctrlSkillTreeBranchV", -1, _ctrlSkillTree];
                    _ctrlSkillLineVBottom ctrlSetPosition [_xLineV, _yPos + _hSkill];
                    _ctrlSkillLineVBottom ctrlCommit 0;
                };

                _xPos = _xPos + _wSkill + 1 * VGM_GRID_W;
            };
            // Space below skill control
            _yPos = _yPos + _hSkill + 2 * VGM_GRID_H;
        } forEach _skills;

        // Horizontal line for the root (name of the branch)
        private _ctrlSkillLineHRoot = _display ctrlCreate ["VGM_ctrlSkillTreeBranchH", -1, _ctrlSkillTree];
        private _wRootLine = _wSkillTree;//(_previousSkillCount - 1) * _wSkill + _previousSkillCount * 1 * VGM_GRID_W;
        _ctrlSkillLineHRoot ctrlSetPositionW _wRootLine;
        _ctrlSkillLineHRoot ctrlSetPosition [0.5 * _wSkillTree - 0.5 * _wRootLine, _yPos, _wRootLine, 1 * VGM_GRID_H];
        _ctrlSkillLineHRoot ctrlCommit 0;

        // Vertical line going into the root
        private _ctrlSkillLineVRoot = _display ctrlCreate ["VGM_ctrlSkillTreeBranchV", -1, _ctrlSkillTree];
        _yPos = _yPos + 1 * VGM_GRID_H;
        _ctrlSkillLineVRoot ctrlSetPosition [
            0.5 * _wSkillTree - 0.5 * VGM_GRID_W,
            _yPos
        ];
        _ctrlSkillLineVRoot ctrlCommit 0;
        _yPos = _yPos + _hBranchV;
        // Add root with name of branch
        private _ctrlBranchName = _display ctrlCreate ["VGM_ctrlBranchName", -1, _ctrlSkillTree];
        _ctrlBranchName ctrlSetPositionY _yPos;
        _ctrlBranchName ctrlCommit 0;
        private _ctrlBranchNameName = _ctrlBranchName controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_BRANCHNAME_NAME;
        _ctrlBranchNameName ctrlSetText (_ctrlSkills tvText (tvCurSel _ctrlSkills));
    };

    case "setSkillTreeHeader": {
        _params params ["_display", "_headerParams", ["_skill", createHashMap]];
        _headerParams params ["_title", "_description"];

        private _ctrlDescriptionTitle = _display displayCtrl VGM_IDC_DISPLAYSKILLS_TITLE;
        private _ctrlDescription = _display displayCtrl VGM_IDC_DISPLAYSKILLS_DESCRIPTION;
        private _ctrlUnlock = _display displayCtrl VGM_IDC_DISPLAYSKILLS_UNLOCK;

        // Update header
        _ctrlDescriptionTitle ctrlSetText _title;
        _ctrlDescription ctrlSetStructuredText parseText _description; // Max length approx 199

        if (_skill isEqualTo createHashMap) then {
            _ctrlUnlock ctrlEnable false;
            _ctrlUnlock ctrlSetText "";
        } else {
            if (_skill call vgm_g_fnc_skills_isKnown) exitWith {
                _ctrlUnlock ctrlSetText localize "STR_VGM_SKILLS_UI_KNOWN";
                _ctrlUnlock ctrlEnable false;
            };

            _ctrlUnlock ctrlSetText format [localize "STR_VGM_SKILLS_UI_UNLOCK", _skill get "cost"];
            _ctrlUnlock ctrlEnable ([player, _skill] call vgm_g_fnc_skills_canLearn);
        };
    };

    case "updateSpAvailableHeader": {
        _params params ["_display"];

        private _ctrlSpHeader = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SPAVAILABLE;

        _ctrlSpHeader ctrlSetText format [localize "STR_VGM_SKILLS_UI_SP_AVAILABLE", [] call vgm_c_fnc_skills_getSkillPoints];
    };

    case "focusSkill": {
        _params params ["_ctrlUnlock"];
        private _ctrlSkill = ctrlParentControlsGroup _ctrlUnlock;
        (_ctrlSkill getVariable "vgm_params") params ["_skill"];

        [
            "setSkillTreeHeader",
            [ctrlParent _ctrlUnlock, [_skill get "displayName", _skill get "description"], _skill]
        ] call vgm_c_fnc_displaySkills;
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
