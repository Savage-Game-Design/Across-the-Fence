#include "macros.inc"

// #define FIRST_TIER_EXCLUSIVE
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
        _ctrlSkills lbSetCurSel ([0, lbCurSel _ctrlSkills] select ((_display getVariable "vgm_currentSkillTree") isNotEqualTo createHashMap));

        ["updateSpAvailableHeader", _display] call vgm_c_fnc_displaySkills;
        ["updateSkillTreeListLabels", _display] call vgm_c_fnc_displaySkills;
        ["updateSkillTreeHeader", _display] call vgm_c_fnc_displaySkills;
        ["updateSkillTree", _display] call vgm_c_fnc_displaySkills;
    };

    // fill left panel with skill trees
    case "initSkillTrees": {
        params ["_ctrlSkills"];

        "Filling Skills list" call vgm_g_fnc_logInfo;

        // ensure that we display tabs in config order, hashmaps are unordered
        private _skillTreeClasses = "true" configClasses (missionConfigFile >> "vgm_skillTrees") apply {configName _x};
        private _skillTreesHashMap = missionNamespace getVariable "vgm_skills_treesHashMap";
        {
            private _skillTree = _skillTreesHashMap get _x;
            private _displayName = _skillTree get "displayName";
            private _ind = _ctrlSkills lbAdd _displayName;
            _ctrlSkills lbSetData [_ind, str [_x]];
            ["skillSetTooltip", [_ctrlSkills, _ind]] call vgm_c_fnc_displaySkills;
            _ctrlSkills lbSetTooltip [_ind, format ["%1 (%2/%3)", _displayName, _skillTree call vgm_g_fnc_skills_getTreeSkillPoints, _skillTree get "skillPointsMax"]];
        } forEach _skillTreeClasses;

        _ctrlSkills setVariable ["vgm_skillsListTvPaths", _skillsTvPaths];
    };

    // fill right panel with skill cards
    case "selectSkillTree": {
        params ["_ctrlSkills", "_ind"];
        private _display = ctrlParent _ctrlSkills;

        private _skillTreePath = parseSimpleArray (_ctrlSkills lbData _ind);
        private _skillTree = _skillTreePath call vgm_g_fnc_skills_getByPath;

        _display setVariable ["vgm_currentSkillTree", _skillTree];
        _display setVariable ["vgm_currentSkill", createHashMap];

        // Update header
        ["updateSkillTreeHeader", _display] call vgm_c_fnc_displaySkills;
        ["updateSkillTree", _display] call vgm_c_fnc_displaySkills;
    };

    // update labels of skilltrees in tree control in left panel
    case "updateSkillTreeListLabels": {
        params ["_display"];
        private _ctrlSkills = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SKILLS;

        for "_i" from 0 to (lbSize _ctrlSkills - 1) do {
            ["skillSetTooltip", [_ctrlSkills, _i]] call vgm_c_fnc_displaySkills;
        };
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
            _ctrlUnlock setVariable ["vgm_skill", _currentSkill];
        };

        // render Skill Tree info
        private _currentSkillTree = _display getVariable "vgm_currentSkillTree";
        if (_currentSkillTree isNotEqualTo createHashMap) exitWith {

            _ctrlDescriptionTitle ctrlSetText (format [localize "STR_VGM_SKILLS_UI_SKILL_TREE", _currentSkillTree get "displayName"]);
            _ctrlDescription ctrlSetStructuredText parseText (_currentSkillTree get "description");

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
            private _tierCount = count _tierSkills;
            // Go to the middle of the skill tree control, then go back half the width of the controls of the tier which is the sum of the buttons and the space between them
            _xPos = 0.5 * _wSkillTree - 0.5 * (_tierCount * _wSkill + (_tierCount - 1) * VGM_GRID_W);

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
                _ctrlSkill setVariable ["vgm_skill", _skill];
                if (!(_skill call vgm_g_fnc_skills_canSee)) then {_ctrlSkill ctrlShow false};
                _ctrlSkill ctrlSetPosition [_xPos, _yPos];
                _ctrlSkill ctrlCommit 0;
                _ctrlSkill ctrlSetStructuredText parseText format ["%1 SP<br/>%2", _skill get "cost", _skill get "displayName"];
                private _tooltip = _skill get "description";

                if (_skill call vgm_g_fnc_skills_isKnown) then {
                    _ctrlSkill ctrlEnable false;
                    _ctrlSkill ctrlSetBackgroundColor [VGM_UI_COLOR_GREY,1];
                    _ctrlSkill ctrlSetDisabledColor [1,1,1,1];
                } else {
                    _ctrlSkill ctrlAddEventHandler ["ButtonClick", {["unlockSkill", _this] call vgm_c_fnc_displaySkills}];
                    _ctrlSkill setVariable ["vgm_skill", _skill];

                    private _canLearn = [player, _skill] call vgm_g_fnc_skills_canLearn;
                    _ctrlSkill ctrlEnable _canLearn;
                    if (!_canLearn) then {
                        if (_tooltip != "") then {
                            _tooltip = endl + endl + _tooltip;
                        };
                        private _lockedTooltip = ["STR_VGM_SKILLS_UI_TIER_LOCKED", "STR_VGM_SKILLS_UI_NOT_ENOUGH_SKILLPOINTS"] select _currentTierUnlocked;
                        _tooltip = localize _lockedTooltip + _tooltip;
                    };

                    #ifdef FIRST_TIER_EXCLUSIVE
                    // show the padlock icon over first tier skills which were not choosen
                    if (_currentTier < 1) exitWith {
                        private _ctrlPadlock = _ctrlSkill controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_SKILLLOCKED;
                        private _locked = [player, _skillTree, _currentTier] call vgm_g_fnc_skills_tierInvested;
                        _ctrlPadlock ctrlShow _locked;
                        _ctrlUnlock ctrlShow (ctrlShown _ctrlUnlock && !_locked);
                    };
                    #endif
                };
                _ctrlSkill ctrlSetTooltip _tooltip;

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
        _ctrlBranchName ctrlSetPosition [
            0.5 * _wSkillTree - 0.5 * (ctrlPosition _ctrlBranchName select 2),
            _yPos
        ];
        _ctrlBranchName ctrlCommit 0;
        private _ctrlBranchNameLabel = _ctrlBranchName controlsGroupCtrl VGM_IDC_DISPLAYSKILLS_BRANCHNAME_NAME;
        _ctrlBranchNameLabel ctrlSetText (_skillTree get "displayName");

        _display setVariable ["vgm_currentSkillTreeRootCtrl", _ctrlBranchNameLabel];
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
        private _skill = _ctrlSkill getVariable "vgm_skill";

        _display setVariable ["vgm_currentSkill", _skill];

        ["updateSkillTreeHeader", _display] call vgm_c_fnc_displaySkills;
    };

    case "unlockSkill": {
        params ["_ctrlUnlock"];
        private _skill = _ctrlUnlock getVariable ["vgm_skill", createHashMap];
        if (_skill isEqualTo createHashMap) exitWith {
            "unlockSkill executed with no skill selected" call vgm_g_fnc_logWarning;
        };

        // prevent skill tile from being focused
        ctrlSetFocus (ctrlParent _ctrlUnlock getVariable "vgm_currentSkillTreeRootCtrl");

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

    case "skillSetTooltip": {
        params ["_ctrlSkills", "_index"];
        private _skillTreePath = parseSimpleArray (_ctrlSkills lbData _i);
        private _skillTree = _skillTreePath call vgm_g_fnc_skills_getByPath;

        private _skillTreePoints = _skillTree call vgm_g_fnc_skills_getTreeSkillPoints;
        private _label = format ["%1 (%2/%3 SP)", _skillTree get "displayName", _skillTreePoints, _skillTree get "skillPointsMax"];

        _ctrlSkills lbSetTooltip [_i, _label];
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
