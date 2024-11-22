class vgm {
    logicalOrder = 1;
    displayName = "$STR_VGM_MISSION_NAME";
    class getting_started {
        displayName = "$STR_VGM_FIELD_MANUAL_GETTING_STARTED";
        description = "$STR_VGM_FIELD_MANUAL_GETTING_STARTED_DESC";
        tip = __EVAL(format [localize 'STR_VGM_FIELD_MANUAL_GETTING_STARTED_TIP', selectRandom getArray (configFile >> 'CfgWorlds' >> 'cam_lao_nam' >> 'loadingTexts')]);
        image = "\a3\ui_f\data\gui\cfg\hints\miss_icon_ca.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
            };
        logicalOrder = 1;
    };
    class missions {
        displayName = "$STR_VGM_FIELD_MANUAL_MISSIONS";
        description = "$STR_VGM_FIELD_MANUAL_MISSIONS_DESC";
        image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
            };
        logicalOrder = 2;
    };
    class skills {
        displayName = "$STR_VGM_FIELD_MANUAL_SKILLS";
        description = "$STR_VGM_FIELD_MANUAL_SKILLS_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_SKILLS_TIP";
        image = "\a3\ui_f\data\gui\cfg\hints\rules_ca.paa";
        arguments[] = 
            {
                "private _key = [\
                    ['OpenActiveSkillWheel'] call (missionNamespace getVariable 'para_c_fnc_keyhandler_getKeyBind'),\
                    true\
                ] call (missionNamespace getVariable 'para_c_fnc_keyhandler_stringifyKeybind');\
                _key = [_key];\
                \
                format ([localize 'STR_VGM_FIELD_MANUAL_SKILLS_WHEEL_DESC'] + ([[_key]] call BIS_fnc_advHintArg))",
            };
        logicalOrder = 3;
    };
    class medical {
        displayName = "$STR_VGM_FIELD_MANUAL_MEDICAL";
        description = "$STR_VGM_FIELD_MANUAL_MEDICAL_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_MEDICAL_TIP";
        image = "\a3\ui_f\data\gui\cfg\hints\injury_ca.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
                "[\
                    ['OpenMedicalMenu'] call (missionNamespace getVariable 'para_c_fnc_keyhandler_getKeyBind'),\
                    true\
                ] call (missionNamespace getVariable 'para_c_fnc_keyhandler_stringifyKeybind')",
                "[\
                    ['OpenMedicalMenuSelf'] call (missionNamespace getVariable 'para_c_fnc_keyhandler_getKeyBind'),\
                    true\
                ] call (missionNamespace getVariable 'para_c_fnc_keyhandler_stringifyKeybind')",
                "localize 'STR_VGM_SKILLS_SKILL_SUPPORT_LOADOUT_MEDICAL'",
            };
        logicalOrder = 4;
    };
};

class vgm_missions {
    logicalOrder = 2;
    displayName = __EVAL(format [localize 'STR_VGM_FIELD_MANUAL_VGM_MISSIONS', localize 'STR_VGM_MISSION_NAME']);
    class scouting {
        displayName = "$STR_VGM_FIELD_MANUAL_SCOUTING";
        description = "$STR_VGM_FIELD_MANUAL_SCOUTING_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_SCOUTING_TIP";
        image = "\a3\ui_f\data\gui\cfg\hints\head_ca.paa";
        logicalOrder = 1;
    };
};
