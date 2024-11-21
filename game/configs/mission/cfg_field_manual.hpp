class vgm {
    displayName = "$STR_VGM_MISSION_NAME";
    class medical {
        logicalOrder = 4;
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
    };
};

class vgm_missions {
    displayName = __EVAL(format [localize 'STR_VGM_FIELD_MANUAL_VGM_MISSIONS', localize 'STR_VGM_MISSION_NAME']);
};
