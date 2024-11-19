
class CfgHints {
    class vgm {
        logicalOrder = 1;
        displayName = "$STR_VGM_MISSION_NAME";

        class getting_started {
            logicalOrder = 1;

            displayName = "$STR_VGM_FIELD_MANUAL_GETTING_STARTED";
            description = "$STR_VGM_FIELD_MANUAL_GETTING_STARTED_DESC";
            arguments[] = {
                "localize 'STR_VGM_MISSION_NAME'"
            };
            tip = __EVAL(format ['<br/>"%1"', selectRandom getArray (configFile >> 'CfgWorlds' >> 'cam_lao_nam' >> 'loadingTexts')]);

            image = "\a3\ui_f\data\gui\cfg\hints\miss_icon_ca.paa";
        };

        class missions {
            logicalOrder = 2;

            displayName = "$STR_VGM_FIELD_MANUAL_MISSIONS";
            description = "$STR_VGM_FIELD_MANUAL_MISSIONS_DESC";
            arguments[] = {
                "localize 'STR_VGM_MISSION_NAME'"
            };

            // image = "\a3\ui_f\data\gui\cfg\hints\tasks_ca.paa";
            image = "\a3\ui_f\data\gui\cfg\hints\tactical_view_ca.paa";
        };

        class skills {
            logicalOrder = 3;

            displayName = "$STR_VGM_FIELD_MANUAL_SKILLS";
            description = "$STR_VGM_FIELD_MANUAL_SKILLS_DESC";
            arguments[] = {
                "\
                private _key = [\
                    ['OpenActiveSkillWheel'] call (missionNamespace getVariable 'para_c_fnc_keyhandler_getKeyBind'),\
                    true\
                ] call (missionNamespace getVariable 'para_c_fnc_keyhandler_stringifyKeybind');\
                _key = [_key];\
                \
                format ([localize 'STR_VGM_FIELD_MANUAL_SKILLS_WHEEL_DESC'] + ([[_key]] call BIS_fnc_advHintArg))\
                "
            };
            tip = "$STR_VGM_FIELD_MANUAL_SKILLS_TIP";

            image = "\a3\ui_f\data\gui\cfg\hints\rules_ca.paa";
        };

        class medical {
            logicalOrder = 4;

            displayName = "$STR_VGM_FIELD_MANUAL_MEDICAL";
            description = "$STR_VGM_FIELD_MANUAL_MEDICAL_DESC";
            arguments[] = {
                "localize 'STR_VGM_MISSION_NAME'",
                "[\
                    ['OpenMedicalMenu'] call (missionNamespace getVariable 'para_c_fnc_keyhandler_getKeyBind'),\
                    true\
                ] call (missionNamespace getVariable 'para_c_fnc_keyhandler_stringifyKeybind')",
                "[\
                    ['OpenMedicalMenuSelf'] call (missionNamespace getVariable 'para_c_fnc_keyhandler_getKeyBind'),\
                    true\
                ] call (missionNamespace getVariable 'para_c_fnc_keyhandler_stringifyKeybind')",
                "localize 'STR_VGM_SKILLS_SKILL_SUPPORT_LOADOUT_MEDICAL'"
            };
            tip = "$STR_VGM_FIELD_MANUAL_MEDICAL_TIP";

            image = "\a3\ui_f\data\gui\cfg\hints\injury_ca.paa"
        };
    };

    class vgm_missions {
        logicalOrder = 2;
        displayName = __EVAL(format ["%1 - %2", localize "STR_VGM_MISSION_NAME", localize "STR_VGM_FIELD_MANUAL_MISSIONS"]);

        class scouting {
            logicalOrder = 1;

            displayName = "$STR_VGM_FIELD_MANUAL_MISSIONS_SCOUTING";
            description = "$STR_VGM_FIELD_MANUAL_MISSIONS_SCOUTING_DESC";
            tip = "$STR_VGM_FIELD_MANUAL_MISSIONS_SCOUTING_TIP";

            image = "\a3\ui_f\data\gui\cfg\hints\head_ca.paa";
        };
    };
};
