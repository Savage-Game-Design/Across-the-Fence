class vgm_welcome {
    logicalOrder = 1;
    displayName = "$STR_VGM_FIELD_MANUAL_VGM_WELCOME";
    class welcome {
        displayName = "$STR_VGM_FIELD_MANUAL_WELCOME";
        description = "$STR_VGM_FIELD_MANUAL_WELCOME_DESC";
        image = "assets\atf_logo.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
            };
        logicalOrder = 1;
    };
    class getting_started {
        displayName = "$STR_VGM_FIELD_MANUAL_GETTING_STARTED";
        description = "$STR_VGM_FIELD_MANUAL_GETTING_STARTED_DESC";
        tip = __EVAL(format [localize 'STR_VGM_FIELD_MANUAL_GETTING_STARTED_TIP', selectRandom getArray (configFile >> 'CfgWorlds' >> 'cam_lao_nam' >> 'loadingTexts')]);
        image = "\a3\ui_f\data\gui\cfg\hints\miss_icon_ca.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
            };
        class Hints {
            class getting_started {
                description = "$STR_VGM_FIELD_MANUAL_GETTING_STARTED_HINT_GETTING_STARTED_DESCRIPTION";
            };
        };
        logicalOrder = 2;
    };
};

class vgm_changelog {
    logicalOrder = 2;
    displayName = "$STR_VGM_FIELD_MANUAL_VGM_CHANGELOG";
    class changelog_0_11_0 {
        displayName = "$STR_VGM_FIELD_MANUAL_CHANGELOG_0_11_0";
        description = "$STR_VGM_FIELD_MANUAL_CHANGELOG_0_11_0_DESC";
        logicalOrder = 1;
    };
    class changelog_0_12_0 {
        displayName = "$STR_VGM_FIELD_MANUAL_CHANGELOG_0_12_0";
        description = "$STR_VGM_FIELD_MANUAL_CHANGELOG_0_12_0_DESC";
        logicalOrder = 2;
    };
};

class vgm {
    logicalOrder = 3;
    displayName = "$STR_VGM_MISSION_NAME";
    class missions {
        displayName = "$STR_VGM_FIELD_MANUAL_MISSIONS";
        description = "$STR_VGM_FIELD_MANUAL_MISSIONS_DESC";
        image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
            };
        class Hints {
            class after_arsenal {
                description = "$STR_VGM_FIELD_MANUAL_MISSIONS_HINT_AFTER_ARSENAL_DESCRIPTION";
            };
            class map_board {
                description = "$STR_VGM_FIELD_MANUAL_MISSIONS_HINT_MAP_BOARD_DESCRIPTION";
            };
            class mission_created {
                displayName = "$STR_VGM_FIELD_MANUAL_MISSIONS_HINT_MISSION_CREATED_NAME";
                description = "$STR_VGM_FIELD_MANUAL_MISSIONS_HINT_MISSION_CREATED_DESCRIPTION";
            };
            class mission_joined {
                displayName = "$STR_VGM_FIELD_MANUAL_MISSIONS_HINT_MISSION_JOINED_NAME";
                description = "$STR_VGM_FIELD_MANUAL_MISSIONS_HINT_MISSION_JOINED_DESCRIPTION";
            };
            class extraction {
                displayName = "$STR_VGM_FIELD_MANUAL_MISSIONS_HINT_EXTRACTION_NAME";
                description = "$STR_VGM_FIELD_MANUAL_MISSIONS_HINT_EXTRACTION_DESCRIPTION";
            };
        };
        logicalOrder = 1;
    };
    class skills {
        displayName = "$STR_VGM_FIELD_MANUAL_SKILLS";
        description = "$STR_VGM_FIELD_MANUAL_SKILLS_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_SKILLS_TIP";
        image = "\a3\ui_f\data\gui\cfg\hints\rules_ca.paa";
        arguments[] = 
            {
                "[\
                    ['OpenActiveSkillWheel'] call (missionNamespace getVariable 'para_c_fnc_keyhandler_getKeyBind'),\
                    true\
                ] call (missionNamespace getVariable 'para_c_fnc_keyhandler_stringifyKeybind')",
            };
        class Hints {
            class levelling_up {
                description = "$STR_VGM_FIELD_MANUAL_SKILLS_HINT_LEVELLING_UP_DESCRIPTION";
            };
            class equipping_skills {
                description = "$STR_VGM_FIELD_MANUAL_SKILLS_HINT_EQUIPPING_SKILLS_DESCRIPTION";
            };
        };
        logicalOrder = 2;
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
        logicalOrder = 3;
    };
    class equipment {
        displayName = "$STR_VGM_FIELD_MANUAL_EQUIPMENT";
        description = "$STR_VGM_FIELD_MANUAL_EQUIPMENT_DESC";
        image = "assets\atf_logo.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
            };
        class Hints {
            class gearing_up {
                description = "$STR_VGM_FIELD_MANUAL_EQUIPMENT_HINT_GEARING_UP_DESCRIPTION";
            };
        };
        logicalOrder = 4;
    };
};

class vgm_missions {
    logicalOrder = 4;
    displayName = __EVAL(format [localize 'STR_VGM_FIELD_MANUAL_VGM_MISSIONS', localize 'STR_VGM_MISSION_NAME']);
    class stealth {
        displayName = "$STR_VGM_FIELD_MANUAL_STEALTH";
        description = "$STR_VGM_FIELD_MANUAL_STEALTH_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_STEALTH_TIP";
        image = "\a3\ui_f\data\gui\cfg\hints\Pheripheal_vision_ca.paa";
        arguments[] = 
            {
                "localize 'STR_VGM_MISSION_NAME'",
            };
        class Hints {
            class stealth {
                description = "$STR_VGM_FIELD_MANUAL_STEALTH_HINT_STEALTH_DESCRIPTION";
            };
        };
        logicalOrder = 1;
    };
    class scouting {
        displayName = "$STR_VGM_FIELD_MANUAL_SCOUTING";
        description = "$STR_VGM_FIELD_MANUAL_SCOUTING_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_SCOUTING_TIP";
        image = "\a3\ui_f\data\gui\cfg\hints\head_ca.paa";
        arguments[] = 
            {
                """a3\ui_f\data\GUI\RscCommon\RscButtonSearch\search_start_ca.paa""",
                """a3\ui_f\data\GUI\Rsc\RscDisplayEGSpectator\free.paa""",
            };
        class Hints {
            class scouting {
                description = "$STR_VGM_FIELD_MANUAL_SCOUTING_HINT_SCOUTING_DESCRIPTION";
            };
        };
        logicalOrder = 2;
    };
    class hints {
        displayName = "$STR_VGM_FIELD_MANUAL_HINTS";
        description = "$STR_VGM_FIELD_MANUAL_HINTS_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_HINTS_TIP";
        image = "assets\glint\vnx_atf_glint_03_ca.paa";
        class Hints {
            class glint_seen {
                description = "$STR_VGM_FIELD_MANUAL_HINTS_HINT_GLINT_SEEN_DESCRIPTION";
            };
        };
        logicalOrder = 3;
    };
    class stop_and_focus {
        displayName = "$STR_VGM_FIELD_MANUAL_STOP_AND_FOCUS";
        description = "$STR_VGM_FIELD_MANUAL_STOP_AND_FOCUS_DESC";
        image = "assets\atf_logo.paa";
        class Hints {
            class stop_and_focus {
                description = "$STR_VGM_FIELD_MANUAL_STOP_AND_FOCUS_HINT_STOP_AND_FOCUS_DESCRIPTION";
            };
        };
        logicalOrder = 4;
    };
    class alertness {
        displayName = "$STR_VGM_FIELD_MANUAL_ALERTNESS";
        description = "$STR_VGM_FIELD_MANUAL_ALERTNESS_DESC";
        image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
        class Hints {
            class alertness {
                description = "$STR_VGM_FIELD_MANUAL_ALERTNESS_HINT_ALERTNESS_DESCRIPTION";
            };
        };
        logicalOrder = 5;
    };
    class desperate_escape {
        displayName = "$STR_VGM_FIELD_MANUAL_DESPERATE_ESCAPE";
        description = "$STR_VGM_FIELD_MANUAL_DESPERATE_ESCAPE_DESC";
        tip = "$STR_VGM_FIELD_MANUAL_DESPERATE_ESCAPE_TIP";
        image = "assets\atf_logo.paa";
        class Hints {
            class desperate_escape {
                description = "$STR_VGM_FIELD_MANUAL_DESPERATE_ESCAPE_HINT_DESPERATE_ESCAPE_DESCRIPTION";
            };
        };
        logicalOrder = 6;
    };
};
