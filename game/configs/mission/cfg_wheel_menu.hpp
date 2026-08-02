// Wheel Menu Actions
// Loaded automatically by Paradigm's fn_wheel_menu_load_config_actions at preInit.
// visible = "ALWAYS" -> shown regardless of cursor target
// visible = "NO_TARGET" -> shown only when no cursor target

class wheel_menu_actions
{
    class heal_self
    {
        function = "vgm_c_fnc_medical_openMedicalMenu";
        text = "STR_VGM_MEDICAL_UI_OPEN_MEDICAL_MENU_SELF";
        icon = "\A3\ui_f\data\igui\cfg\actions\heal_ca.paa";
        arguments = "player";
        visible = "ALWAYS";
        condition = "!(player getVariable ['para_carry_carrying', false])";
    };

    class focus_mode
    {
        function = "vgm_c_fnc_skill_investigate_toggleFocusMode";
        text = "STR_VGM_SKILL_INVESTIGATE_ACTION";
        icon = "assets\skills\recon_ca.paa";
        visible = "ALWAYS";
    };

    class call_artillery
    {
        function = "vgm_c_fnc_artillery_menu";
        text = "STR_VN_ARTILLERY_ACTION_NAME";
        icon = "assets\skills\fire_support_ca.paa";
        arguments = "['init']";
        spawn = 1;
        visible = "ALWAYS";
        condition = "count (missionNamespace getVariable ['vn_artillery_config_array',[]]) > 0 && {call vn_fnc_artillery_radio}";
    };
};
