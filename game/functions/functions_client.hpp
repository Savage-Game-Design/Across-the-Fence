// common_includes.hpp will be automagically included.

#define VGM_CLIENT_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))
#define VGM_GLOBAL_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))

class vgm_g
{
    class default
    {
        VGM_GLOBAL_PATH(\);
    };

    class core
    {
        VGM_GLOBAL_PATH(\core\global);

        class execNextFrame {};
        class preInit
        {
            preInit = 1;
        };
    };

    class debug
    {
        VGM_GLOBAL_PATH(\debug\global);

        class log {
            headerType = -1;
        };
        class logError {
            headerType = -1;
        };
        class logInfo {
            headerType = -1;
        };
        class logWarning {
            headerType = -1;
        };
    };

    class leveling
    {
        VGM_GLOBAL_PATH(\systems\leveling\global);
    };

    class skills
    {
        VGM_GLOBAL_PATH(\systems\skills\global);

        class skills_canLearn {};
        class skills_canSee {};
        class skills_getByPath {};
        class skills_isKnown {};
        class skills_parseTreeCfg {};
        class skills_preInit
        {
            preInit = 1;
        };
        class skills_treesHashToPathsHash;
    };
};

class vgm_c
{
    class default
    {
        VGM_CLIENT_PATH(\);
    };

    class displays
    {
        VGM_CLIENT_PATH(\core\client\displays);
        class displaySkills {};
        class displayAbilities {};
        class displayMissions {};
        class displayMissionsTargets {};
        class displayAbilityCooldown {};
    };

    class ui
    {
        VGM_CLIENT_PATH(\core\client\ui);
        class update_loading_screen {};
        class init_loading_text {};
        class handle_light_level_loop {};
        class handle_welcome_screen {};
        class init_info_panel_handler_loop {};
        class stack_controls {};
        class toggle_controls_group_overlay {};
    };

    class shared_hub
    {
        VGM_CLIENT_PATH(\systems\shared_hub\client);

        class sharedHub_areaLimiterDisable {};
        class sharedHub_areaLimiterEnable {};
        class sharedHub_teleportPlayerToHub {};
    };

    class leveling
    {
        VGM_CLIENT_PATH(\systems\leveling\client);

        class leveling_preInit
        {
            preInit = 1;
        };
        class leveling_postInit
        {
            postInit = 1;
        };
    };

    class skills
    {
        VGM_CLIENT_PATH(\systems\skills\client);

        class skills_getSkillPoints {};
        class skills_getSkillTreeFromSkill {};
        class skills_openSkillTree {};
        class skills_postInit
        {
            postInit = 1;
        };
        class skills_preInit
        {
            preInit = 1;
        };
    };

    class skills_active
    {
        VGM_CLIENT_PATH(\systems\skills\client\active);

        class skills_active_isSlotOnCooldown {};
        class skills_active_getSlot {};
        class skills_active_assignSkillToSlot {};
        class skills_active_openAssignMenu {};
        class skills_active_openSkillWheel {};
        class skills_active_skillWheelActivate {};
        class skills_active_toggleHud {};

        class skills_active_init {};
    };

    class skills_network
    {
        VGM_CLIENT_PATH(\systems\skills\client\network);

        class skills_receiveSkillLearn {};
        class skills_receiveSkillRespec {};
        class skills_receiveSkillsData {};

        class skills_requestSkillLearn {};
        class skills_requestSkillRespec {};
        class skills_requestSkillsData {};
    };
};
