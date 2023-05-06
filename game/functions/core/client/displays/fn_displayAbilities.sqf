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

        ["initSkillsList", _display] call SELF;
        ["refreshUI", _display] call SELF;
    };

    case "refreshUI": {
        params ["_display"];

        ["updateStandardSkillStack", _display] call SELF;
        ["updateUltimateSkillStack", _display] call SELF;
    };

    // update standard skill panel on the left
    case "updateStandardSkillStack": {
        params ["_display"];

        ["setSkillStackData", [_display, VGM_IDC_DISPLAYABILITIES_STDSTACK, SLOT_STANDARD]] call SELF;
    };

    // update ultimate skill panel on the left
    case "updateUltimateSkillStack": {
        params ["_display"];

        ["setSkillStackData", [_display, VGM_IDC_DISPLAYABILITIES_ULTSTACK, SLOT_ULTIMATE]] call SELF;
    };

    // fill skill stack with data based on the current skill in the slot
    case "setSkillStackData": {
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
        if (_skill isEqualTo createHashMap) exitWith {
            _ctrlTitle ctrlSetText "-";
            _ctrlIcon ctrlSetText "#(rgb,1,1,1)color(1,0,0,0.5)";
            _ctrlCategory ctrlSetText "-";
            _ctrlCooldown ctrlSetText "-";
            _ctrlDescription ctrlSetText "-";
        };

        private _skillTree = _skill call vgm_c_fnc_skills_getSkillTreeFromSkill;

        _ctrlTitle ctrlSetText (_skill get "displayName");
        _ctrlIcon ctrlSetText (_skill get "icon");
        _ctrlCategory ctrlSetText (_skillTree get "displayName");
        _ctrlCooldown ctrlSetText str (_skill get "cooldown");
        _ctrlDescription ctrlSetText (_skill get "description");
    };

    // fill central panel with skills
    case "initSkillsList": {
        params ["_display"];

        private _ctrlAvailable = _display displayCtrl VGM_IDC_DISPLAYABILITIES_AVAILABLE;

        {
            private _skill = _x;
            private _name = _skill get "displayName";
            private _icon = _skill get "icon";
            private _skillTree = _skill call vgm_c_fnc_skills_getSkillTreeFromSkill;
            private _category = _skillTree get "displayName";

            (ctAddRow _ctrlAvailable select 1) params [
                "", // Frame
                "_ctrlRowName",
                "_ctrlRowCategory",
                "", // Icon frame
                "_ctrlRowIcon",
                "_ctrlRowEquip"
            ];

            _ctrlRowName ctrlSetStructuredText parseText format ["<t size='1.25'>%1</t>", _skill get "displayName"];
            _ctrlRowCategory ctrlSetText _category;
            _ctrlRowIcon ctrlSetText _icon;

            _ctrlRowEquip setVariable ["vgm_skill", _skill];
            _ctrlRowEquip ctrlSetText localize "STR_VGM_SKILLS_UI_EQUIP";
            _ctrlRowEquip ctrlAddEventHandler ["ButtonClick", {["equipSkill", _this] call SELF}];
        } forEach (values vgm_c_skills_active_list);

    };

    case "equipSkill": {
        params ["_ctrlRowEquip"];

        private _skill = _ctrlRowEquip getVariable "vgm_skill";
        private _slot = [SLOT_STANDARD, SLOT_ULTIMATE] select (_skill get "isUltimate");

        private _result = [_slot, _skill] call vgm_c_fnc_skills_active_assignSkillToSlot;
        if (!_result) then {
            hint "Failed to assign skill to slot";
        };

        ["refreshUI", ctrlParent _ctrlRowEquip] call SELF;
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
