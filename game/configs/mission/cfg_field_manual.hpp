class vgm_welcome {
    logicalOrder = 1;
    displayName = "$STR_VGM_FIELD_MANUAL_VGM_WELCOME";
    class welcome {
        displayName = "$STR_VGM_FIELD_MANUAL_WELCOME";
        description = "$STR_VGM_FIELD_MANUAL_WELCOME_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_WELCOME_TIP";
        image = "assets\atf_logo.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
            };
        logicalOrder = 1;
    };
};

class vgm_tutorial {
    logicalOrder = 2;
    displayName = "$STR_VGM_FIELD_MANUAL_VGM_TUTORIAL";
    class tutorial_gearing_up {
        displayName = "$STR_VGM_FIELD_MANUAL_TUTORIAL_GEARING_UP";
        description = "$STR_VGM_FIELD_MANUAL_TUTORIAL_GEARING_UP_DESC";
        image = "assets\atf_logo.paa";
        logicalOrder = 1;
    };
    class tutorial_equipping_skills {
        displayName = "$STR_VGM_FIELD_MANUAL_TUTORIAL_EQUIPPING_SKILLS";
        description = "$STR_VGM_FIELD_MANUAL_TUTORIAL_EQUIPPING_SKILLS_DESC";
        image = "assets\atf_logo.paa";
        logicalOrder = 2;
    };
    class tutorial_missions {
        displayName = "$STR_VGM_FIELD_MANUAL_TUTORIAL_MISSIONS";
        description = "$STR_VGM_FIELD_MANUAL_TUTORIAL_MISSIONS_DESC";
        image = "assets\atf_logo.paa";
        logicalOrder = 3;
    };
    class tutorial_creating_missions {
        displayName = "$STR_VGM_FIELD_MANUAL_TUTORIAL_CREATING_MISSIONS";
        description = "$STR_VGM_FIELD_MANUAL_TUTORIAL_CREATING_MISSIONS_DESC";
        image = "assets\atf_logo.paa";
        logicalOrder = 4;
    };
    class tutorial_joining_missions {
        displayName = "$STR_VGM_FIELD_MANUAL_TUTORIAL_JOINING_MISSIONS";
        description = "$STR_VGM_FIELD_MANUAL_TUTORIAL_JOINING_MISSIONS_DESC";
        image = "assets\atf_logo.paa";
        logicalOrder = 5;
    };
    class tutorial_extraction {
        displayName = "$STR_VGM_FIELD_MANUAL_TUTORIAL_EXTRACTION";
        description = "$STR_VGM_FIELD_MANUAL_TUTORIAL_EXTRACTION_DESC";
        image = "assets\atf_logo.paa";
        logicalOrder = 6;
    };
};

class vgm {
    logicalOrder = 3;
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
                ] call (missionNamespace getVariable 'para_c_fnc_keyhandler_stringifyKeybind')",
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
    logicalOrder = 4;
    displayName = __EVAL(format [localize 'STR_VGM_FIELD_MANUAL_VGM_MISSIONS', localize 'STR_VGM_MISSION_NAME']);
    class scouting {
        displayName = "$STR_VGM_FIELD_MANUAL_SCOUTING";
        description = "$STR_VGM_FIELD_MANUAL_SCOUTING_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_SCOUTING_TIP";
        image = "\a3\ui_f\data\gui\cfg\hints\head_ca.paa";
        logicalOrder = 1;
    };
    class hints {
        displayName = "$STR_VGM_FIELD_MANUAL_HINTS";
        description = "$STR_VGM_FIELD_MANUAL_HINTS_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_HINTS_TIP";
        image = "assets\glint\vnx_atf_glint_03_ca.paa";
        logicalOrder = 2;
    };
    class stop_and_focus {
        displayName = "$STR_VGM_FIELD_MANUAL_STOP_AND_FOCUS";
        description = "$STR_VGM_FIELD_MANUAL_STOP_AND_FOCUS_DESC";
        image = "assets\atf_logo.paa";
        logicalOrder = 3;
    };
};
