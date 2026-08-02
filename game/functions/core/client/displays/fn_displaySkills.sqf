#include "macros.inc"

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad": {
        params ["_display"];

        uiNamespace setVariable ["VGM_DisplaySkills", _display];

        _display setVariable ["vgm_currentSkillTree", createHashMap];
        _display setVariable ["vgm_currentSkill", createHashMap];

        private _refreshHandlersIds = [];
        _display setVariable ["vgm_skills_ui_refreshHandlerIds", _refreshHandlersIds];
        {
            private _ehId = [_x, [_display, {
                params ["", "_display"];
                ["refreshUI", _display] call vgm_c_fnc_displaySkills;
            }]] call para_g_fnc_event_subscribeLocal;

            _refreshHandlersIds pushBack _ehId;
        } forEach [
            "vgm_skills_learnt",
            "vgm_skills_forgotten"
        ];

        ["refreshUI", _display] call vgm_c_fnc_displaySkills;
    };

    case "onUnload": {
        params ["_display"];

        {[_x] call para_g_fnc_event_unsubscribe} forEach (_display getVariable "vgm_skills_ui_refreshHandlerIds");
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
        ["updatePrestigeButton", _display] call vgm_c_fnc_displaySkills;
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
            private _ind = _ctrlSkills lbAdd "";
            _ctrlSkills lbSetPicture [_ind, _skillTree get "icon"];
            _ctrlSkills lbSetData [_ind, str [_x]];
            ["skillSetTooltip", [_ctrlSkills, _ind]] call vgm_c_fnc_displaySkills;
            _ctrlSkills lbSetTooltip [_ind, format ["%1 (%2/%3)", _displayName, _skillTree call vgm_g_fnc_skills_getTreeSkillPoints, _skillTree get "skillPointsMax"]];
        } forEach _skillTreeClasses;
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

        private _ctrlSkillTree = _display displayCtrl VGM_IDC_DISPLAYSKILLS_SKILLTREE;
        _ctrlSkillTree spawn {_this ctrlSetScrollValues [1, 0]};
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

            _ctrlUnlock ctrlSetText format [localize "STR_VGM_SKILLS_UI_UNLOCK", [_currentSkill, player] call vgm_g_fnc_skills_getEffectiveCost];
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

        private _skillTree = _display getVariable ["vgm_currentSkillTree", createHashMap];

        // Remove all old controls
        allControls _ctrlSkillTree apply { ctrlDelete _x };

        // nothing to render if no skill tree selected
        if (_skillTree isEqualTo createHashMap) exitWith {};

        // Save some coordinates for later use
        ctrlPosition _ctrlSkillTree params ["", "", "_wSkillTree"];
        private _wSkill = getNumber (missionConfigFile >> "VGM_ctrlSkill" >> "w");
        private _hSkill = getNumber (missionConfigFile >> "VGM_ctrlSkill" >> "h");

        private _topMargin = 1 * VGM_GRID_H;
        private _rightMargin = 1 * VGM_GRID_W;
        private _bottomMargin = 1 * VGM_GRID_H;
        private _leftMargin = 1 * VGM_GRID_W;

        private _fnc_calcLayout = {
            params ["_skillSectionWidth", "_tiersYAndHeight"];

            private _layout = createHashMap;
            _layout set ["tiersYAndHeight", _tiersYAndHeight];

            private _tierInfoColumn = createHashMapFromArray [
                ["x", _leftMargin],
                ["width", 25 * VGM_GRID_W]
            ];
            _layout set ["tierInfo", _tierInfoColumn];

            _skillSectionColumn = createHashMapFromArray [
                ["x", (_tierInfoColumn get "x") + (_tierInfoColumn get "width")],
                ["width", _skillSectionWidth]
            ];
            _layout set ["skillSection", _skillSectionColumn];

            _layout set ["width", (_skillSectionColumn get "x") + (_skillSectionColumn get "width") + _rightMargin];

            _layout set ["tierSeparator", createHashMapFromArray [
                ["x", _leftMargin],
                ["width", (_layout get "width") - _rightMargin]
            ]];

            _layout
        };

        private _skillTreeLayout = [0, []] call _fnc_calcLayout;

        // Track the maximum width of the skill section, so we know where to start drawing things after it.
        private _skillSectionWidth = 0;
        private _skillTiersYAndHeight = [];

        // Start adding from Ultimate to Lowest Level skill
        private _skillTiers = +(_skillTree get "skills");
        reverse _skillTiers;

        private _tierUnlockStatuses = [];
        {
            _tierUnlockStatuses pushBack ([player, _skillTree, _forEachIndex] call vgm_g_fnc_skills_tierUnlocked);
        } forEach _skillTiers;

        private _yPos = 0;
        {
            private _tierSkills = _x;
            private _currentTier = _tierSkills#0 get "tier";
            private _currentTierUnlocked = _tierUnlockStatuses # _currentTier;
            private _currentSkillCount = count _tierSkills;
            private _tierStartYPos = _yPos;

            // Top padding above skills
            _yPos = _yPos + 2 * VGM_GRID_H;

            /*
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
            */

            // Center the controls
            private _tierCount = count _tierSkills;
            // Fallback for old skill trees. Can be removed when they are.
            private _isManualLayout = _tierSkills findIf {_x get "column" > 0} > -1;

            // Iterate over the skills of the current tier
            {
                private _skill = _x;

                // Create controls for skills of this tier
                private _ctrlSkill = _display ctrlCreate ["VGM_ctrlSkill", -1, _ctrlSkillTree];
                _ctrlSkill setVariable ["vgm_skill", _skill];
                if (!(_skill call vgm_g_fnc_skills_canSee)) then {_ctrlSkill ctrlShow false};

                private _effectiveCost = [_skill, player] call vgm_g_fnc_skills_getEffectiveCost;
                private _costText = format ["%1 SP", _effectiveCost];
                private _skillText = [
                    parseText (_skill get "displayName"),
                    lineBreak,
                    parseText _costText
                ];

                if (_skill get "isActive") then {
                    _skillText = _skillText + [
                        lineBreak,
                        parseText format ["<t size='0.8'>Duration: %1s", _skill get "duration"],
                        lineBreak,
                        parseText format ["<t size='0.8'>Cooldown: %1s", _skill get "cooldown"]
                    ];
                };

                _ctrlSkill ctrlSetStructuredText composeText _skillText;
                private _tooltip = _skill get "description";

                if (_skill call vgm_g_fnc_skills_isKnown) then {
                    _ctrlSkill ctrlSetBackgroundColor [VGM_UI_COLOR_GREY,1];
                    // Click to unlearn
                    _ctrlSkill ctrlAddEventHandler ["ButtonClick", {
                        params ["_ctrl"];
                        private _skill = _ctrl getVariable "vgm_skill";
                        private _display = ctrlParent (ctrlParentControlsGroup _ctrl);
                        ["unlearnSkill", [_display, _skill]] call vgm_c_fnc_displaySkills;
                    }];
                    _tooltip = _tooltip + endl + "(Click to unlearn)";
                } else {
                    _ctrlSkill ctrlAddEventHandler ["ButtonClick", {["unlockSkill", _this] call vgm_c_fnc_displaySkills}];
                    _ctrlSkill setVariable ["vgm_skill", _skill];

                    [player, _skill] call vgm_g_fnc_skills_canLearnWithReason params ["_canLearn", "_cantLearnReason"];
                    _ctrlSkill ctrlEnable _canLearn;
                    if (!_canLearn) then {
                        if (_tooltip != "") then {
                            _tooltip = [localize "STR_VGM_SKILLS_UI_SKILL_LOCKED", endl, _cantLearnReason call para_c_fnc_localize, endl, endl, _tooltip] joinString "";
                        } else {
                            _tooltip = [localize "STR_VGM_SKILLS_UI_SKILL_LOCKED", endl, _cantLearnReason call para_c_fnc_localize] joinString "";
                        };
                    };
                };

                private _column = [_forEachIndex, _skill get "column"] select _isManualLayout;
                private _skillXOffset = _column * (
                        // Width of skill
                        _wSkill +
                        // Spacing after each skill.
                        1 * VGM_GRID_W
                );
                private _skillXPos = (_skillTreeLayout get "skillSection" get "x") + _skillXOffset;
                _ctrlSkill ctrlSetPosition [_skillXPos, _yPos];
                _ctrlSkill ctrlCommit 0;

                _ctrlSkill ctrlSetTooltip _tooltip;


                // Track the maximum width of the skill section.
                _skillSectionWidth = _skillSectionWidth max (_skillXOffset + _wSkill + 1 * VGM_GRID_W);
            } forEach _tierSkills;

            // Bottom padding below skills
            _yPos = _yPos + _hSkill + 2 * VGM_GRID_H;
            _skillTiersYAndHeight pushBack [_tierStartYPos, _yPos - _tierStartYPos];
        } forEach _skillTiers;

        _skillTreeLayout = [_skillSectionWidth, _skillTiersYAndHeight] call _fnc_calcLayout;

        {
            private _tierSkills = _x;
            private _currentTier = (count _skillTiers - _forEachIndex - 1);
            private _currentTierUnlocked = _tierUnlockStatuses # _currentTier;
            private _currentSkillPointsSpent = [_skillTree, player, _currentTier] call vgm_g_fnc_skills_getTreeSkillPointsBelowTier;
            private _requiredSkillPointsToUnlock = [_skillTree, player, _currentTier] call vgm_g_fnc_skills_getTierUnlockCost;
            ((_skillTreeLayout get "tiersYAndHeight") # _forEachIndex) params ["_tierY", "_tierH"];

            // Horizontal separators
            private _tierSeparatorLayout = _skillTreeLayout get "tierSeparator";
            private _ctrlTierTopSeparator = _display ctrlCreate ["VGM_ctrlTierSeparator", -1, _ctrlSkillTree];
            _ctrlTierTopSeparator ctrlSetPosition [
                _tierSeparatorLayout get "x",
                _tierY,
                _tierSeparatorLayout get "width",
                (0.2 * VGM_GRID_H) max pixelH
            ];
            _ctrlTierTopSeparator ctrlCommit 0;

            private _tierInfoLayout = _skillTreeLayout get "tierInfo";
            private _ctrlTierText = _display ctrlCreate ["VGM_ctrlTierText", -1, _ctrlSkillTree];
            // TODO - Localise
            private _tierText = format ["Tier %1", _currentTier];
            if (_requiredSkillPointsToUnlock > 0) then {
                _tierText = _tierText + "\n" + format ["%1/%2", _currentSkillPointsSpent, _requiredSkillPointsToUnlock];
            };
            _ctrlTierText ctrlSetText _tierText;
            private _yOffset = (_tierH - ctrlTextHeight _ctrlTierText) / 2;
            _ctrlTierText ctrlSetPosition [
                _tierInfoLayout get "x",
                _tierY + _yOffset,
                _tierInfoLayout get "width",
                _tierH
            ];
            _ctrlTierText ctrlCommit 0;


            if (!_currentTierUnlocked) then {
                private _ctrlPadlock = _display ctrlCreate ["VGM_ctrlTierLockedIcon", -1, _ctrlSkillTree];
                private _ctrlPadlockHeight = ctrlPosition _ctrlPadlock # 3;
                _ctrlPadlock ctrlSetPosition [
                    _tierInfoLayout get "x",
                    _tierY + (_tierH - _ctrlPadlockHeight) / 2
                ];
                _ctrlPadlock ctrlCommit 0;
            };
        } forEach _skillTiers;

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
        [ctrlParent _ctrlUnlock, _skill] spawn {
            params ["_display", "_skill"];
            private _effectiveCost = [_skill, player] call vgm_g_fnc_skills_getEffectiveCost;
            private _learn = [parseText ([
                "Do you want to learn: <t color='#ff0000'>", _skill get "displayName", "</t><br/>",
                format ["You have <t color='#ff0000'>%1</t> out of <t color='#ff0000'>%2</t> needed skillpoints", call vgm_c_fnc_skills_getSkillPoints, _effectiveCost],
                ["<br/>Can't learn!", ""] select ([player, _skill] call vgm_g_fnc_skills_canLearn)
            ] joinString ""), "Confirm", true, true, _display] call BIS_fnc_guiMessage;
            // check if confirmed
            if (!_learn) exitWith {};

            [_skill, _display] call vgm_c_fnc_skills_requestSkillLearn;
        };
    };

    case "unlearnSkill": {
        params ["_display", "_skill"];

        [_display, _skill] spawn {
            params ["_display", "_skill"];

            private _effectiveCost = [_skill, player] call vgm_g_fnc_skills_getEffectiveCost;

            // Check if unlearning would cascade (break tier thresholds)
            private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
            private _tiers = _skillTree get "skills";
            private _targetTier = _skill get "tier";
            private _skillPath = _skill get "path";

            // Simulate removal to find cascaded skills
            private _skillsData = player getVariable "vgm_g_skillsData";
            private _knownPaths = +(_skillsData get "skillPaths");
            _knownPaths deleteAt (_knownPaths find _skillPath);

            private _cascadeNames = [];
            for "_tierIdx" from (_targetTier + 1) to (count _tiers - 1) do {
                private _spentBelow = 0;
                for "_t" from 0 to (_tierIdx - 1) do {
                    {
                        if ((_x get "path") in _knownPaths) then {
                            _spentBelow = _spentBelow + (_x get "cost");
                        };
                    } forEach (_tiers # _t);
                };
                private _requiredPoints = [_skillTree, player, _tierIdx] call vgm_g_fnc_skills_getTierUnlockCost;
                if (_spentBelow < _requiredPoints) then {
                    {
                        private _path = _x get "path";
                        if (_path in _knownPaths) then {
                            _cascadeNames pushBack (_x get "displayName");
                            _knownPaths deleteAt (_knownPaths find _path);
                        };
                    } forEach (_tiers # _tierIdx);
                };
            };

            // Build confirmation message
            private _msg = format [
                "Do you want to unlearn: <t color='#ff0000'>%1</t><br/>You will regain <t color='#00ff00'>%2</t> skill points.",
                _skill get "displayName",
                _effectiveCost
            ];

            if (count _cascadeNames > 0) then {
                private _cascadeList = _cascadeNames joinString ", ";
                _msg = _msg + format [
                    "<br/><br/><t color='#ffaa00'>WARNING: This will also unlearn %1 skill(s) in higher tiers:</t><br/>%2",
                    count _cascadeNames,
                    _cascadeList
                ];
            };

            private _confirm = [parseText _msg, "Confirm Unlearn", true, true, _display] call BIS_fnc_guiMessage;
            if (!_confirm) exitWith {};

            [_skill, _display] call vgm_c_fnc_skills_requestSkillUnlearn;
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

    case "respec": {
        params ["_ctrlRespec"];
        [ctrlParent _ctrlRespec] call vgm_c_fnc_skills_requestSkillRespec;
    };

    case "initPrestige": {
        params ["_ctrlPrestige"];
        ["updatePrestigeButton", ctrlParent _ctrlPrestige] call vgm_c_fnc_displaySkills;
    };

    case "updatePrestigeButton": {
        params ["_display"];
        private _ctrlPrestige = _display displayCtrl VGM_IDC_DISPLAYSKILLS_PRESTIGE;
        private _level = player getVariable ["vgm_g_levelingData", createHashMap] getOrDefault ["level", 0];
        private _canPrestige = _level >= vgm_g_leveling_maxLvl;
        _ctrlPrestige ctrlEnable _canPrestige;
        if (_canPrestige) then {
            _ctrlPrestige ctrlSetTooltip localize "STR_VGM_PRESTIGE_BUTTON_TOOLTIP";
        } else {
            _ctrlPrestige ctrlSetTooltip localize "STR_VGM_PRESTIGE_LOCKED";
        };
    };

    case "prestige": {
        params ["_ctrlPrestige"];
        private _display = ctrlParent _ctrlPrestige;

        [_display] spawn {
            params ["_display"];

            private _levelingData = player getVariable ["vgm_g_levelingData", createHashMap];
            private _prestige = _levelingData getOrDefault ["prestige", 0];
            private _displayLevel = _prestige * 30 + (_levelingData getOrDefault ["level", 0]);

            private _msg = format [
                "<t size='1.2' color='#ffcc00'>PRESTIGE</t><br/><br/>" +
                "Current display level: <t color='#00ff00'>%1</t><br/>" +
                "Current prestige: <t color='#00ff00'>%2</t><br/><br/>" +
                "Prestiging will:<br/>" +
                "- Reset your level back to 1<br/>" +
                "- Reset all skill points<br/>" +
                "- <t color='#00ff00'>Keep your arsenal cosmetics</t><br/><br/>" +
                "Your nametag level will continue from <t color='#ffcc00'>%3</t>.<br/><br/>" +
                "Are you sure?",
                _displayLevel,
                _prestige,
                _displayLevel + 1
            ];

            private _confirm = [parseText _msg, "Confirm Prestige", true, true, _display] call BIS_fnc_guiMessage;
            if (!_confirm) exitWith {};

            _display closeDisplay 1;
            [] call vgm_c_fnc_prestige_requestPrestige;
        };
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
