#include "macros.inc"
/*
    File: fn_displayAbilities.sqf
    Author: Savage Game Design
    Date: 2023-01-31
    Public: No

    Description:
        UI script for the ability selection UI.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_c_fnc_displayAbilities
*/

#define SELF vgm_c_fnc_displayAbilities
#define SLOT_STANDARD "ability1"
#define SLOT_ULTIMATE "ultimate"

#if __A3_DEBUG__
    diag_log ["fn_displayAbilities", _this];
#endif

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad":{
        params ["_display"];

        ["refreshUI", _display] call SELF;
    };

    case "refreshUI": {
        params ["_display"];

        ["fillSkillsList", _display] call SELF;
        ["updateStandardSkillStack", _display] call SELF;
        ["updateUltimateSkillStack", _display] call SELF;
        ["updateFocusedSkillStack", _display] call SELF;
    };

    // update standard skill panel on the left
    case "updateStandardSkillStack": {
        params ["_display"];

        ["setSlotSkillStackData", [_display, VGM_IDC_DISPLAYABILITIES_STDSTACK, SLOT_STANDARD]] call SELF;
    };

    // update ultimate skill panel on the left
    case "updateUltimateSkillStack": {
        params ["_display"];

        ["setSlotSkillStackData", [_display, VGM_IDC_DISPLAYABILITIES_ULTSTACK, SLOT_ULTIMATE]] call SELF;
    };

    // fill skill stack with data based on the current skill in the slot
    case "setSlotSkillStackData": {
        params ["_display", "_idcSkillStack", "_slotName"];

        private _ctrlSkillStack = _display displayCtrl _idcSkillStack;

        private _slot = vgm_c_skills_active_slots get _slotName;
        private _skill = _slot get "skill";

        private _ctrlTitle = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_STDULT_NAME;
        private _ctrlIcon = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_STDULT_ICON;
        private _ctrlCategory = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_STDULT_CATEGORY;
        private _ctrlCooldown = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_STDULT_COOLDOWN;
        private _ctrlDescription = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_STDULT_DESCRIPTION;

        // no skill in the slot
        private _idcEmpty = [VGM_IDC_DISPLAYABILITIES_STDEMPTY, VGM_IDC_DISPLAYABILITIES_ULTEMPTY] select (_slotName == SLOT_ULTIMATE);
        private _ctrlEmpty = _display displayCtrl _idcEmpty;
        if (isNil "_skill" || { _skill isEqualTo createHashMap }) exitWith {
            _ctrlSkillStack ctrlShow false;
            _ctrlEmpty ctrlShow true;
        };

        private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;

        _ctrlTitle ctrlSetText (_skill get "displayName");
        _ctrlIcon ctrlSetText (_skill get "icon");
        _ctrlCategory ctrlSetText (_skillTree get "displayName");
        _ctrlCooldown ctrlSetText format [localize "STR_VGM_SKILLS_UI_COOLDOWN_LONG", _skill get "cooldown"];
        _ctrlDescription ctrlSetText (_skill get "description");

        _ctrlSkillStack ctrlShow true;
        _ctrlEmpty ctrlShow false;
    };

    // player wants to assign his standard ability
    case "slotSelectStandard": {
        params ["_ctrlSlotSelect"];
        private _display = ctrlParent _ctrlSlotSelect;

        ["fillSkillsList", [_display, SLOT_STANDARD]] call SELF;
    };

    // player wants to assign his ultimate ability
    case "slotSelectUltimate": {
        params ["_ctrlSlotSelect"];
        private _display = ctrlParent _ctrlSlotSelect;

        ["fillSkillsList", [_display, SLOT_ULTIMATE]] call SELF;
    };

    // skill was selected on available skills list
    case "skillSelected": {
        params ["_ctrlAvailable", "_idx"];
        private _display = ctrlParent _ctrlAvailable;

        if (_idx > -1) then {
            private _skillPath = (_ctrlAvailable getVariable "vgm_skills") get _idx;
            private _skill = _skillPath call vgm_g_fnc_skills_getByPath;

            _display setVariable ["vgm_focusedSkill", _skill];
        };

        ["updateFocusedSkillStack", _display] call SELF;
    };

    // update right panel with currently focused skill
    case "updateFocusedSkillStack": {
        params ["_display"];

        private _ctrlSkillStack = _display displayCtrl VGM_IDC_DISPLAYABILITIES_ABILITYSTACK;
        private _ctrlTitle = _display displayCtrl VGM_IDC_DISPLAYABILITIES_ABILITYTITLE;

        private _ctrlIcon = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_ABILITYICON;
        private _ctrlCategory = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_ABILITYCATEGORY;
        private _ctrlCooldown = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_ABILITYCOOLDOWN;
        private _ctrlDescription = _ctrlSkillStack controlsGroupCtrl VGM_IDC_DISPLAYABILITIES_ABILITYDESCRIPTION;

        private _focusedSkill = _display getVariable "vgm_focusedSkill";

        // disable the button if skill already equipped
        private _skillSlot = _focusedSkill call VGM_C_fnc_skills_active_getSlot;
        _ctrlEquip ctrlSetText localize (["STR_VGM_SKILLS_UI_EQUIPPED", "STR_VGM_SKILLS_UI_EQUIP"] select (_skillSlot == ""));
        _ctrlEquip ctrlEnable (_skillSlot == "");

        _ctrlAbilityEmpty = _display displayCtrl VGM_IDC_DISPLAYABILITIES_ABILITYEMPTY;
        if (isNil "_focusedSkill" || {_focusedSkill isEqualTo createHashMap}) exitWith {
            _ctrlAbilityEmpty ctrlShow true;
            _ctrlSkillStack ctrlShow false;
            _ctrlTitle ctrlSetText "No Skill Selected";
        };
        _ctrlAbilityEmpty ctrlShow false;
        _ctrlSkillStack ctrlShow true;

        private _skillTree = _focusedSkill call vgm_g_fnc_skills_getSkillTreeFromSkill;

        _ctrlTitle ctrlSetText (_focusedSkill get "displayName");
        _ctrlIcon ctrlSetText (_focusedSkill get "icon");
        _ctrlCategory ctrlSetText (_skillTree get "displayName");
        _ctrlCooldown ctrlSetText format [localize "STR_VGM_SKILLS_UI_COOLDOWN_LONG", _focusedSkill get "cooldown"];
        _ctrlDescription ctrlSetText (_focusedSkill get "description");
        _display setVariable ["vgm_skill", _focusedSkill];
    };

    // fill central panel with skills
    case "fillSkillsList": {
        params ["_display", ["_slot", SLOT_STANDARD]];

        _display setVariable ["vgm_focusedSkill", createHashMap];

        private _ctrlTitle = _display displayCtrl VGM_IDC_DISPLAYABILITIES_AVAILABLETITLE;
        private _title = ["STR_VGM_SKILLS_UI_ABILITY_AVAILABLE_STD", "STR_VGM_SKILLS_UI_ABILITY_AVAILABLE_ULT"] select (_slot == SLOT_ULTIMATE);
        _ctrlTitle ctrlSetText localize _title;

        private _ctrlAvailable = _display displayCtrl VGM_IDC_DISPLAYABILITIES_AVAILABLE;
        private _skillPathsHashMap = createHashMap;
        _ctrlAvailable setVariable ["vgm_skills", _skillPathsHashMap];
        private _available = (values vgm_c_skills_active_list select {_x get "isUltimate" == (_slot == SLOT_ULTIMATE)});
        private _ctrlAvailableEmpty = _display displayCtrl VGM_IDC_DISPLAYABILITIES_AVAILABLEEMPTY;
        if (isNil "_available" || {count _available == 0}) exitWith {
            _ctrlAvailable ctrlShow false;
            _ctrlAvailableEmpty ctrlShow true;
        };

        ctClear _ctrlAvailable;
        {
            private _skill = _x;
            private _name = _skill get "displayName";
            private _icon = _skill get "icon";
            private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
            private _category = _skillTree get "displayName";

            ctAddRow _ctrlAvailable params ["_idx", "_rowData"];
            _rowData params [
                "", // Frame
                "_ctrlRowName",
                "_ctrlRowCategory",
                "_ctrlRowIcon",
                "_ctrlRowEquip"
            ];

            _skillPathsHashMap set [_idx, _skill get "path"];

            _ctrlRowName ctrlSetStructuredText parseText format ["<t size='1.25'>%1</t>", _skill get "displayName"];
            _ctrlRowCategory ctrlSetText _category;
            _ctrlRowIcon ctrlSetText _icon;

            _ctrlRowEquip setVariable ["vgm_skill", _skill];
            _ctrlRowEquip ctrlSetText localize "STR_VGM_SKILLS_UI_EQUIP";
            _ctrlRowEquip ctrlAddEventHandler ["ButtonClick", {
                ["equipSkill", [ctrlParent (_this#0)]] call SELF
            }];
            // disable the button if skill already equipped
            private _skillSlot = _skill call VGM_C_fnc_skills_active_getSlot;
            _ctrlRowEquip ctrlSetText localize (["STR_VGM_SKILLS_UI_EQUIPPED", "STR_VGM_SKILLS_UI_EQUIP"] select (_skillSlot == ""));
            _ctrlRowEquip ctrlEnable (_skillSlot == "");
        } forEach _available;

        _ctrlAvailable ctSetCurSel 0;
        _ctrlAvailable ctrlShow true;
        _ctrlAvailableEmpty ctrlShow false;
    };

    // put the skill into currently selected slot
    case "equipSkill": {
        params ["_display"];

        private _skill = _display getVariable "vgm_skill";
        private _slot = [SLOT_STANDARD, SLOT_ULTIMATE] select (_skill get "isUltimate");

        private _result = [_slot, _skill] call vgm_c_fnc_skills_active_assignSkillToSlot;
        // this should not really happen, does not need translation
        if (!_result) then {hint "Failed to assign skill to slot"};

        // delay by frame to prevent crash, current control will be deleted on UI refresh
        [SELF, ["refreshUI", _display]] call vgm_g_fnc_execNextFrame;
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
