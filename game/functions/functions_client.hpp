// common_includes.hpp will be automagically included.

#define VGM_CLIENT_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))
#define VGM_GLOBAL_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))

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
    };

    class shared_hub
    {
        VGM_CLIENT_PATH(\systems\shared_hub\client);

        class sharedHub_areaLimiterDisable {};
        class sharedHub_areaLimiterEnable {};
        class sharedHub_teleportPlayerToHub {};
    };
};

class vgm_g
{
    class default
    {
        VGM_GLOBAL_PATH(\);
    };

    class core
    {
        VGM_GLOBAL_PATH(\core\global);

        class preInit
        {
            preInit = 1;
        };
    };
};

