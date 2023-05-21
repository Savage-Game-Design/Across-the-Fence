#include "macros.inc"

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad": {
        params ["_display"];

        _display setVariable ["vgm_currentSkillTree", createHashMap];
        _display setVariable ["vgm_currentSkill", createHashMap];

        private _handlerId = ["vgm_skills_learnt", [_display, {
            params ["", "_display"];
            ["refreshUI", _display] call vgm_c_fnc_displaySkills;
        }]] call para_g_fnc_event_subscribeLocal;
        _display setVariable ["vgm_skills_ui_learntHandlerId", _handlerId];

        ["refreshUI", _display] call vgm_c_fnc_displaySkills;
    };

    case "onUnload": {
        params ["_display"];
        [_display getVariable "vgm_skills_ui_learntHandlerId"] call para_g_fnc_event_unsubscribe;
    };

    case "refreshUI": {
        params ["_display"];

        "Refreshing Skills display" call vgm_g_fnc_logInfo;

        private _ctrlSkills = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SKILLS;
        _ctrlSkills tvSetCurSel ([[0], tvCurSel _ctrlSkills] select ((_display getVariable "vgm_currentSkillTree") isNotEqualTo createHashMap));

        ["updateSpAvailableHeader", _display] call vgm_c_fnc_displaySkills;
        ["updateSkillTreeHeader", _display] call vgm_c_fnc_displaySkills;
        ["updateSkillTree", _display] call vgm_c_fnc_displaySkills;
    };

    // fill left panel with skill trees
    case "initSkillTrees": {
        params ["_ctrlSkills"];

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
        params ["_ctrlSkills", "_path"];
        private _display = ctrlParent _ctrlSkills;

        private _skillTreePath = parseSimpleArray (_ctrlSkills tvData _path);
        private _skillTree = _skillTreePath call vgm_g_fnc_skills_getByPath;

        _display setVariable ["vgm_currentSkillTree", _skillTree];
        _display setVariable ["vgm_currentSkill", createHashMap];

        // Update header
        ["updateSkillTreeHeader", _display] call vgm_c_fnc_displaySkills;
        ["updateSkillTree", _display] call vgm_c_fnc_displaySkills;
    };

    case "updateSkillTreeHeader": {
        params ["_display"];

        private _ctrlDescriptionTitle = _display displayCtrl VGM_IDC_DISPLAYSKILLS_TITLE;
        private _ctrlDescription = _display displayCtrl VGM_IDC_DISPLAYSKILLS_DESCRIPTION;
        private _ctrlUnlock = _display displayCtrl VGM_IDC_DISPLAYSKILLS_UNLOCK;
        _ctrlUnlock ctrlShow true;

        // render Skill info
        private _currentSkill = _display getVariable "vgm_currentSkill";
        if (_currentSkill isNotEqualTo createHashMap) exitWith {

            _ctrlDescriptionTitle ctrlSetText (_currentSkill get "displayName");
            _ctrlDescription ctrlSetStructuredText parseText (_currentSkill get "description");

            if (_currentSkill call vgm_g_fnc_skills_isKnown) exitWith {
                _ctrlUnlock ctrlSetText localize "STR_VGM_SKILLS_UI_KNOWN";
                _ctrlUnlock ctrlEnable false;
            };

            _ctrlUnlock ctrlSetText format [localize "STR_VGM_SKILLS_UI_UNLOCK", _skill get "cost"];
            _ctrlUnlock ctrlEnable ([player, _currentSkill] call vgm_g_fnc_skills_canLearn);
            _ctrlUnlock setVariable ["vgm_params", [_currentSkill]];
        };

        // render Skill Tree info
        private _currentSkillTre = _display getVariable "vgm_currentSkillTree";
        if (_currentSkillTre isNotEqualTo createHashMap) exitWith {

            _ctrlDescriptionTitle ctrlSetText (format [localize "STR_VGM_SKILLS_UI_SKILL_TREE", _currentSkillTre get "displayName"]);
            _ctrlDescription ctrlSetStructuredText parseText (_currentSkillTre get "description");

            _ctrlUnlock ctrlShow false;
            _ctrlUnlock ctrlEnable false;
            _ctrlUnlock ctrlSetText "";
        };
    };

    case "updateSkillTree": {
        params ["_display"];

        private _ctrlSkillTree = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SKILLTREE;
        private _skillTree = _display getVariable "vgm_currentSkillTree";

        // Remove all old controls
        allControls _ctrlSkillTree apply { ctrlDelete _x };

        // nothing to render if no skill tree selected
        if (_skillTree isEqualTo createHashMap) exitWith {};

        // Save some coordinates for later use
        ctrlPosition _ctrlSkillTree params ["", "", "_wSkillTree"];
        private _wSkill = getNumber (missionConfigFile >> "VGM_ctrlSkill" >> "w");
        private _hSkill = getNumber (missionConfigFile >> "VGM_ctrlSkill" >> "h");
        private _hBranchV = getNumber (missionConfigFile >> "VGM_ctrlSkillTreeBranchV" >> "h");
        private _hBranchH = getNumber (missionConfigFile >> "VGM_ctrlSkillTreeBranchH" >> "h");

        // Start adding from Ultimate to Lowest Level skill
        private _skills = +(_skillTree get "skills");
        reverse _skills;

        private _xPos = 0;
        private _yPos = 0;
        private _previousSkillCount = -1;
        {
            private _tierSkills = _x;
            private _currentTier = _tierSkills#0 get "tier";
            private _currentTierUnlocked = [player, _skillTree, _currentTier] call vgm_g_fnc_skills_tierUnlocked;
            private _currentSkillCount = count _tierSkills;

            if (_forEachIndex > 0) then {
                // Draw a horizontal line connecting the skills from the
                // previous level to the skills of the current level
                private _ctrlSkillLineH = _display ctrlCreate ["VGM_ctrlSkillTreeBranchH", -1, _ctrlSkillTree];
                private _hlineW = (_previousSkillCount max _currentSkillCount - 1) max 1;
                _hlineW = _hlineW * _wSkill + _hlineW * VGM_GRID_W;
                _ctrlSkillLineH ctrlSetPosition [
                    // Middle of tree, go back half the width of the line and a bit
                    0.5 * _wSkillTree - 0.5 * _hlineW,
                    _yPos,
                    _hlineW,
                    _hBranchH
                ];
                _ctrlSkillLineH ctrlCommit 0;
                _previousSkillCount = _currentSkillCount;
                // spacing below horizontal line
                _yPos = _yPos + 3 * VGM_GRID_H;
            };

            // show padlock on the right side of the tier row if it's not unlocked
            if (!_currentTierUnlocked) then {
                private _ctrlTierLocked = _display ctrlCreate ["VGM_ctrlStaticPicture", -1, _ctrlSkillTree];
                private _iconWH = 10 * VGM_GRID_W;
                _ctrlTierLocked ctrlSetText "\a3\ui_f_orange\Data\Displays\RscDisplayAANArticle\lock_ca.paa";
                _ctrlTierLocked ctrlSetPosition [
                    _wSkillTree - _iconWH,
                    _yPos + _hSkill/2 - _hBranchV - _iconWH/2 + (2 * VGM_GRID_W),
                    _iconWH,
                    _iconWH
                ];
                _ctrlTierLocked ctrlSetTextColor [0,0,0,1];
                _ctrlTierLocked ctrlSetTooltip localize "STR_VGM_SKILLS_UI_TIER_LOCKED";
                _ctrlTierLocked ctrlCommit 0;
            };

            // Center the controls
            _xPos = switch (count _tierSkills) do {
                case 1: { 0.5 * _wSkillTree - 0.5 * _wSkill };
                case 2: { 1/3 * _wSkillTree - 0.5 * _wSkill };
                default { 0 };
            };

            // Iterate over the skills of the current tier
            _tierSkills apply {
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
                // Create controls for skills of this tier
                private _ctrlSkill = _display ctrlCreate ["VGM_ctrlSkill", -1, _ctrlSkillTree];
                _ctrlSkill setVariable ["vgm_params", [_skill]];
                if (!(_skill call vgm_g_fnc_skills_canSee)) then {_ctrlSkill ctrlShow false};
                _ctrlSkill ctrlSetPosition [_xPos, _yPos];
                _ctrlSkill ctrlCommit 0;

                private _ctrlDescription = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLDESCRIPTION;
                _ctrlDescription ctrlSetStructuredText parseText (_skill get "displayName");

                private _ctrlFocus = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLFOCUS;
                _ctrlFocus ctrlAddEventHandler ["ButtonClick", {["focusSkill", _this] call vgm_c_fnc_displaySkills}];

                private _ctrlUnlock = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLUNLOCK;
                if (_skill call vgm_g_fnc_skills_isKnown) then {
                    _ctrlUnlock ctrlSetText "\a3\ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
                    _ctrlUnlock ctrlSetTooltip localize "STR_VGM_SKILLS_UI_KNOWN";
                } else {
                    _ctrlUnlock ctrlAddEventHandler ["ButtonClick", {["unlockSkill", _this] call vgm_c_fnc_displaySkills}];
                    _ctrlUnlock setVariable ["vgm_params", [_skill]];

                    private _canLearn = [player, _skill] call vgm_g_fnc_skills_canLearn;
                    _ctrlUnlock ctrlEnable _canLearn;
                    _ctrlUnlock ctrlSetTooltip ([localize "STR_VGM_SKILLS_UI_NOT_ENOUGH_SKILLPOINTS", ""] select _canLearn);

                    _ctrlUnlock ctrlShow _currentTierUnlocked;

                    // show the padlock icon over first tier skills which were not choosen
                    if (_currentTier < 1) exitWith {
                        private _ctrlPadlock = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLLOCKED;
                        private _locked = [player, _skillTree, _currentTier] call vgm_g_fnc_skills_tierInvested;
                        _ctrlPadlock ctrlShow _locked;
                        _ctrlUnlock ctrlShow (ctrlShown _ctrlUnlock && !_locked);
                    };
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
        private _wRootLine = _previousSkillCount - 1;
        _wRootLine = _wRootLine * _wSkill + _wRootLine * VGM_GRID_W;
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
        private _ctrlBranchNameLabel = _ctrlBranchName controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_BRANCHNAME_NAME;
        _ctrlBranchNameLabel ctrlSetText (_skillTree get "displayName");
    };

    case "updateSpAvailableHeader": {
        params ["_display"];

        private _ctrlSpHeader = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SPAVAILABLE;

        _ctrlSpHeader ctrlSetText format [localize "STR_VGM_SKILLS_UI_SP_AVAILABLE", [] call vgm_c_fnc_skills_getSkillPoints];
    };

    case "focusSkill": {
        params ["_ctrlFocus"];
        private _display = ctrlParent _ctrlFocus;
        private _ctrlSkill = ctrlParentControlsGroup _ctrlFocus;
        (_ctrlSkill getVariable "vgm_params") params ["_skill"];

        _display setVariable ["vgm_currentSkill", _skill];

        ["updateSkillTreeHeader", _display] call vgm_c_fnc_displaySkills;
    };

    case "unlockSkill": {
        params ["_ctrlUnlock"];
        (_ctrlUnlock getVariable "vgm_params") params [["_skill", createHashMap]];
        if (_skill isEqualTo createHashMap) exitWith {
            "unlockSkill executed with no skill selected" call vgm_g_fnc_logWarning;
        };

        // confirm skill selection
        // TODO this would need some sort of fitting UI design
        [ctrlParent _ctrlUnlock, _skill] spawn {
            params ["_display", "_skill"];
            private _learn = [parseText ([
                "Do you want to learn: <t color='#ff0000'>", _skill get "displayName", "</t><br/>",
                format ["You have <t color='#ff0000'>%1</t> out of <t color='#ff0000'>%2</t> needed skillpoints", call vgm_c_fnc_skills_getSkillPoints, _skill get "cost"],
                ["<br/>Can't learn!", ""] select ([player, _skill] call vgm_g_fnc_skills_canLearn)
            ] joinString ""), "Confirm", true, true, _display] call BIS_fnc_guiMessage;
            // check if confirmed
            if (!_learn) exitWith {};

            [_skill, _display] call vgm_c_fnc_skills_requestSkillLearn;
        };
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
