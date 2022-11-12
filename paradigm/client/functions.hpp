#include "..\common_includes.hpp"
#include "..\global\functions.hpp"

#define PARA_CLIENT_PATH(PATH) file=QUOTE(CONCAT_3(PARA_PATH,\client\functions,PATH))

class para_c
{
	class default
	{
		PARA_CLIENT_PATH(\);
	};

	class aperture
	{
		PARA_CLIENT_PATH(\aperture);
		class set_aperture_based_on_light_level {};
	};

	class basebuilding
	{
		PARA_CLIENT_PATH(\basebuilding);
		class abort_building {};
		class action_resupply {};
		class buildable_overlay_init {};
		class buildable_resupply_info {};
		class building_check {};
		class place_object {};
		class placing_object_adjust {};
		class resupply_building_with_crate {};
		class resupply_building_with_sandbag {};
		class toggle_buildmode {};
	};

	class building_features_maintenance
	{
		PARA_CLIENT_PATH(\building_features\maintenance);
		class bf_maintenance_add_rearm_action {};
		class bf_maintenance_add_refuel_action {};
		class bf_maintenance_add_repair_action {};
	};

	class building_features_vehicle_spawning
	{
		PARA_CLIENT_PATH(\building_features\vehicle_spawning);
		class bf_veh_spawn_add_spawn_actions {};
		class bf_veh_spawn_request_vehicle_spawn {};
	};

	class dynamicGroups
	{
		PARA_CLIENT_PATH(\dynamicGroups);
		class dynamicGroups {};
	};

	class eventhandler
	{
		PARA_CLIENT_PATH(\eventhandler);
		class init_display_event_handler {};
		class init_player_event_handlers {};
		class set_local_var {};
	};

	class init
	{
		PARA_CLIENT_PATH(\init);
		class client_init { preInit = 1; };
	};

	class keyhandler
	{
		PARA_CLIENT_PATH(\keyhandler);
		class change_key_bind {};
		class eh_key_down {};
		class eh_key_up {};
		class get_key_bind {};
		class init_key_down {};
		class init_key_up {};
	};

	class networked_actions
	{
		PARA_CLIENT_PATH(\networked_actions);
		class net_action_add {};
		class net_action_hold_add {};
		class net_action_hold_remove {};
		class net_action_remove {};
	};

	class performance
	{
		PARA_CLIENT_PATH(\performance);
		class perf_enable_dynamic_view_distance {};
		class perf_update_dynamic_view_distance {};
	};

	class rehandler
	{
		PARA_CLIENT_PATH(\rehandler);
		class call_on_server {};
		class spawn_on_server {};
	};

	class scheduler
	{
		PARA_CLIENT_PATH(\scheduler);
		class compiled_loop_init {};
	};

	class helpers
	{
		PARA_CLIENT_PATH(\helpers);
		class localize {};
		class localize_and_format {};
	};

	class voting
	{
		PARA_CLIENT_PATH(\voting);
		class show_global_vote {};
	};

	class tools
	{
		PARA_CLIENT_PATH(\tools);
		class operate_axe {};
		class operate_wrench {};
		class tool_controller_init {};
		class operate_shovel {};
		class operate_hammer {};

	};


	//////////////////////////
	///// User Interface /////
	//////////////////////////

	//General UI scripts
	class ui
	{
		PARA_CLIENT_PATH(\ui);
		class getKeyName {};
		class show_notification {};
		class ui_initMissionDisplay {}; // preInit = 1;
		class ui_updateImg {};
		class initEscapeMenu {}; // postInit = 1;
	};

	class building_menu
	{
		PARA_CLIENT_PATH(\ui\building_menu);
		class buildingMenu_filterAvailable {};
		class buildingMenu_filterSearch {};
		class buildingMenu_indexBuildings {};
		class buildingMenu_indexCategories {};
		class buildingMenu_onBuild {};
		class buildingMenu_onCategoryChange {};
		class buildingMenu_onCheckedChanged {};
		class buildingMenu_onLoad {};
		class buildingMenu_onPageChange {};
		class buildingMenu_onSelect {};
		class buildingMenu_onUpdate {};
		class buildingMenu_quickBuild {};
	};

	//////////////////////////////////////////
	//UI/DYNAMIC GROUPS STUFF:
	class ui_dynamicGroups
	{
		PARA_CLIENT_PATH(\ui\dynamicGroups);
		class ui_dynamicGroups {};
	};

	class infopanel
	{
		PARA_CLIENT_PATH(\ui\infopanel);
		/* Rewards/XP/etc Notifications */
		class infopanel_init {};
		class infoPanel_handler {};
		class infoPanel_addToQueue {};
	};

	class bugreport
	{
		PARA_CLIENT_PATH(\ui\bug_report);
		class bugReport_show {};
		class bugReport_init {};
		class bugReport_onKeyDown {};
	};

	class welcomeScreen
	{
		PARA_CLIENT_PATH(\ui\welcome_screen);
		class loadChangelogContent {};
		class welcomeScreenLoad {};
	};

	class interaction_overlay
	{
		PARA_CLIENT_PATH(\ui\interaction_overlay);
		class interactionOverlay_add {};
		class interactionOverlay_create {};
		class interactionOverlay_hide {};
		class interactionOverlay_init {};
		class interactionOverlay_intersect {};
		class interactionOverlay_modify {};
		class interactionOverlay_onDraw3D {};
		class interactionOverlay_setProgress {};
		class interactionOverlay_show {};
		class interactionOverlay_update {};
		class interactionOverlay_toggle {};
	};

	class KeybindingsMenu
	{
		PARA_CLIENT_PATH(\ui\keybindings_menu);
		class para_RscDisplayKeybindingsMenu;
		class keybindingsMenu_onLoad;
		class keybindingsMenu_onUnload;
		class keybindingsMenu_init {}; // postInit = 1;
		class keybindingsMenu_editBind;
		class keybindingsMenu_editBind_input;
		class keybindingsMenu_reset;
		class keybindingsMenu_updateColors;
	};

	class notification_overlay
	{
		PARA_CLIENT_PATH(\ui\notification_overlay);
		class notificationHide {};
		class notificationLoop {};
		class notificationManager {};
		class notificationNext {};
		class notificationRush {};
		class notificationShow {};
		class notificationUpdate {};
		class postNotification {};
		class notificationInit {};
		class deleteNotification {};
	};

	class options_menu
	{
		PARA_CLIENT_PATH(\ui\options_menu);
		class optionsMenu_getValue {};
		class optionsMenu_handleChange {};
		class optionsMenu_init {};
		class optionsMenu_open {};
		class optionsMenu_onCheckedChanged {};
		class optionsMenu_onLBSelChanged {};
		class optionsMenu_onSliderPosChanged {};
		class optionsMenu_onUnload {};
		class optionsMenu_setValue {};
	};

	class voting_menu
	{
		PARA_CLIENT_PATH(\ui\voting_menu);
		class createVote {};
		class endVote {};
		class hideVote {};
		class openVoteMenu {};
		class showVote {};
		class submitVote {};
		class vote_1 {};
		class vote_2 {};
		class loadVotingMenu {};
	};

	class wheel_menu
	{
		PARA_CLIENT_PATH(\ui\wheel_menu);
		class wheel_menu_add_obj_action_from_config {};
		class wheel_menu_add_obj_action {};
		class wheel_menu_callback_wrapper {};
		class wheel_menu_create_entry {};
		class wheel_menu_load_config_actions { preInit = 1; };
		class wheel_menu_open {};
		class wheel_menu_open_keybind {};
		class wheel_menu_open_with_configured_actions {};
		class wheel_menu_submenu_open {};
	};

	class survival_hints
	{
		PARA_CLIENT_PATH(\ui\survival_hints);
		class para_RscSurvivalHints;
		class ui_hints_acknowledgeHintKeypress {};
		class ui_hints_openFieldManual {};
		class ui_hints_pop_hint {};
		class ui_hints_setup {};
		class ui_hints_show_hint {};
	};

	class zone_markers
	{
		PARA_CLIENT_PATH(\ui\zone_marker);
		class zone_marker_add;
		class zone_marker_delete;
		class zone_marker_fob_info;
		class zone_marker_hide_info;
		class zone_marker_init;
		class zone_marker_show_info;
		class zone_marker_update_info_position;
	};


};
