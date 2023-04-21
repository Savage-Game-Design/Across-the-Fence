#include "macros.inc"
params ["_mode", "_params"];
switch _mode do {
    case "onLoad":{
        _params params ["_display"];
        private _ctrlSkills = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SKILLS;
        _ctrlSkills tvSetCurSel [0];
    };
    // fill left panel with skill trees
    case "initSkills": {
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
    case "selectSkill":{
        _params params ["_ctrlSkills", "_path"];
        private _display = ctrlParent _ctrlSkills;
        private _ctrlDescription = _display displayCtrl VGM_IDC_DISPLAYSKILLS_DESCRIPTION;
        private _ctrlSkillTree = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SKILLTREE;

        private _skillTreePath = parseSimpleArray (_ctrlSkills tvData _path);
        private _skillTree = _skillTreePath call vgm_g_fnc_skills_getByPath;

        // Get the appropate action for the selected entry
        switch (count _path) do {
            case 1: {
                // Top level category
                _ctrlDescription ctrlSetStructuredText parseText "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolore."; // Max length approx 199
            };
            // TODO: Skill trees, Subtrees
        };

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
                _ctrlSkill ctrlSetPosition [_xPos, _yPos];
                _ctrlSkill ctrlCommit 0;
                private _ctrlDescription = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLDESCRIPTION;
                _ctrlDescription ctrlSetStructuredText parseText (_skill get "displayName");

                private _ctrlUnlock = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLUNLOCK;

                private _ctrlCost = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLCOST;
                _ctrlCost ctrlSetText format ["%1 SP", _skill get "cost"];

                // Create a vertical line going into the bottom of the skill
                // and connecting it to the horizontal line below
                private _ctrlSkillLineVBottom = _display ctrlCreate ["VGM_ctrlSkillTreeBranchV", -1, _ctrlSkillTree];
                _ctrlSkillLineVBottom ctrlSetPosition [_xLineV, _yPos + _hSkill];
                _ctrlSkillLineVBottom ctrlCommit 0;

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
};
