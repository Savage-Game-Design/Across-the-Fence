/*
    File: para_player_init_client.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
        Called on the client after player_init_server has finished.
        Serverside player initialisation is done at this point.
        It is safe to access the player object in this function.
        Used for setting up UI elements, local event handlers, etc.

        Load order:
            - para_player_preload_client.sqf - Called as soon as possible on the client.
            - para_player_loaded_client.sqf - Called on client as soon as the player is ready
            - para_player_init_server.sqf - Serverside player initialisation.
            - para_player_init_client.sqf - Clientside player initialisation.
            - para_player_postinit_server.sqf - Called on server once all player initialisation is done.

    Parameter(s):
        _player - Player to initialise [OBJECT]
        _didJIP - Whether the player joined in progress [BOOLEAN]

    Returns:
        None

    Example(s):
        //description.ext
        use_paradigm_init = 1;
*/

params ["_player", "_didJIP"];

player createDiaryRecord ["Diary", [localize "STR_vn_mf_howtobuild", localize "STR_vn_mf_howtobuild_long"], taskNull, "", false];

player createDiaryRecord ["Diary", [localize "STR_vn_mf_other_keys", localize "STR_vn_mf_other_keys_long"], taskNull, "", false];

// Instantiate the main scheduler
[] call para_g_fnc_scheduler_subsystem_init;

// Set up automatic view distance scaling for performance
[] call para_c_fnc_perf_enable_dynamic_view_distance;

// initialize tools controller
call para_c_fnc_tool_controller_init;

call vgm_c_fnc_handle_light_level_loop;

call para_c_fnc_notificationInit;

["init_player_ready", []] call para_g_fnc_event_triggerLocal;

diag_log "VGM client init finished";
