// common_includes.hpp will be automagically included.

#define VGM_CLIENT_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))
#define VGM_GLOBAL_PATH(PATH) file=QUOTE(CONCAT_3(VGM_PATH,functions,PATH))

class vgm_c
{
    class default
    {
        VGM_CLIENT_PATH(\);
    };

    class ui
    {
        VGM_CLIENT_PATH(\core\client\ui);
        class update_loading_screen {};
        class init_loading_text {};
        class handle_light_level_loop {};
        class handle_welcome_screen {};
        class init_info_panel_handler_loop {};
    };

    class skills
    {
        VGM_CLIENT_PATH(\systems\skills\client);

        class skills_openSkillTree {};
        class skills_preInit
        {
            preInit = 1;
        };
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

        class execNextFrame {};
        class preInit
        {
            preInit = 1;
        };
    };
};

