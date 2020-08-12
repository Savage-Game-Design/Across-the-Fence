#define PARA_PATH paradigm
class cfgfunctions
{
	#include "..\paradigm\client\functions.hpp"
	#include "..\paradigm\server\functions.hpp"

	//Function definitions for mission-specific paradigm features.
	class para_interop {
		class interop {
			file = "functions\paradigm_interop";
			class get_squad_composition {};
			class valid_attack_angles {};
		};
	};

	class vn_mf
	{
		class init
		{
			class pre_init
			{
				preinit = 1;
			};
			class post_init
			{
				postinit = 1;
			};
		};
		class client
		{
			class building_check {};
			class debug_monitor {};
			class master_loop_init {};
			class apply_unit_traits {};
			class enable_debug_monitor {};
			class enable_task_roster {};
			class enable_keydown_escape {};
			class enable_selector {};
			class start_game_stage2 {};
			class snake_handler {};
			class task_client_on_task_completed {};
			class task_client_on_task_created {};
			class update_loading_screen {};
			class display_location_time {};
			class health_effects {};
			class invite_player {};
			class earplugs {};
			class training {};
			class client_teleport {};
			class client_request_supplies {};
			class player_award {};
			class set_local_var {};
			class set_respawn {};
			class consume {};
			class respawn_change {};
		};
		class helpers
		{
			class init_mission_handlers {};
			class units_on_team {};
		};
		class rehandler
		{
			class supporttaskcreate {};
			class changeteam {};
			class eatdrink {};
			class teleport {};
			class supplyrequest {};
			class inviteplayer {};
			class settrait {};
			class setlocaleh {};
			class setrespawn {};
			class packageforslingloading {};
		};

		class game
		{
			// client
			class start_game_client {};
			class start_game_headless {};
			class action_drink_water {};
			class action_eat_food {};
			class action_supplies {};
			class action_teleport {};
			class action_trait {};
			class armor_calc {};
			class ui_sub_menu {};
			class ammo_repack {};
			class unit_to_rank {};
			class player_rank_up {};
			class ui_create {};
			class ui_update {};
			class unit_next_rank {};
			class points_to_next_rank {};

			// both
			class get_gamemode_value {};
			class get_loadbalance_target {};
			class check_enemy_units_alive {};
			class progress_to_color_config {};
			class player_can_enter_vehicle {};
			class player_respawn_loc {};

			// server
			class lock_vehicle_to_teams {};
			class force_team_change {};
			class group_init {};
			class player_list_tracker {};
			class marker_init {};
			class player_on_team {};
			class player_health_stats {};
			class player_within_radius {};
			class save_time_elapsed {};

			// stats
			class change_player_stat {};
			class stats_init {};

			//Tasks
			class task_complete {};
			class task_create {};
			class task_is_completed {};
			class task_refresh_tasks_client {};
			class task_subtask_complete {};
			class task_subtask_create {};
			class task_update_clients {};


			//Zones
			class zone_add_progress {};
			class zone_active_job {};
			class zone_complete {};
			class zone_create_all_valid_connectors {};
			class zone_create_assets_for_completed_zone {};
			class zone_create_connector {};
			class zone_init {};
			class zone_maintain_aa {};
			class zone_maintain_artillery {};
			class zone_maintain_fortify_phase {};
			class zone_maintain_secondaries {};
			class zone_maintain_special_tasks {};
			class zone_make_active {};
			class zone_populate_task_pool {};

		};

		class mods
		{
			class init_tfar {};
		};

		class server
		{
			class init_player {};
			class start_game_server {};
			class end_mission {};
		};

		class tasks
		{
			class create_support_default { file = "functions\tasks\task_creation\fn_create_support_default.sqf"; };

			class simple_task_system { file = "functions\tasks\fn_simple_task_system.sqf"; };
			class state_machine_task_system { file = "functions\tasks\fn_state_machine_task_system.sqf"; };
			class task_pri_build_aid_post { file = "functions\tasks\primary\fn_task_pri_build_aid_post.sqf"; };
			class task_pri_build_school { file = "functions\tasks\primary\fn_task_pri_build_school.sqf"; };
			class task_pri_expand { file = "functions\tasks\primary\fn_task_pri_expand.sqf"; };
			class task_pri_secure { file = "functions\tasks\primary\fn_task_pri_secure.sqf"; };
			class task_pri_takeover { file = "functions\tasks\primary\fn_task_pri_takeover.sqf"; };
			class task_sec_build { file = "functions\tasks\secondary\fn_task_sec_build.sqf";};
			class task_sec_clear_minefield { file = "functions\tasks\secondary\fn_task_sec_clear_minefield.sqf";};
			class task_sec_combat_air_patrol { file = "functions\tasks\secondary\fn_task_sec_combat_air_patrol.sqf"; };
			class task_sec_destroy_camp { file = "functions\tasks\secondary\fn_task_sec_destroy_camp.sqf";};
			class task_sec_destroy_emplacement { file = "functions\tasks\secondary\fn_task_sec_destroy_emplacement.sqf";};
			class task_sec_destroy_mortar { file = "functions\tasks\secondary\fn_task_sec_destroy_mortar.sqf";};
			class task_sec_destroy_supplies { file = "functions\tasks\secondary\fn_task_sec_destroy_supplies.sqf";};
			class task_sec_kill_officer { file = "functions\tasks\secondary\fn_task_sec_kill_officer.sqf";};
			class task_sec_patrol { file = "functions\tasks\secondary\fn_task_sec_patrol.sqf";};
			class task_sec_reinforce { file = "functions\tasks\secondary\fn_task_sec_reinforce.sqf";};
			class task_sec_spike_wiretap { file = "functions\tasks\secondary\fn_task_sec_spike_wiretap.sqf";};
			class task_sec_transport_supplies { file = "functions\tasks\secondary\fn_task_sec_transport_supplies.sqf"; };
			class task_sup_brightlight { file = "functions\tasks\support\fn_task_sup_brightlight.sqf"; };
			class task_sup_cas { file = "functions\tasks\support\fn_task_sup_cas.sqf"; };
			class task_sup_destroy_target { file = "functions\tasks\support\fn_task_sup_destroy_target.sqf"; };
			class task_sup_transport { file = "functions\tasks\support\fn_task_sup_transport.sqf"; };
			class task_sup_resupply { file = "functions\tasks\support\fn_task_sup_resupply.sqf";};
			class task_zone_connector { file = "functions\tasks\fn_zone_connector.sqf";};
		};

		class Create
		{
			file = "functions\Game\Create";
			class create_aa_emplacement {};
			class create_camp_buildings {};
			class create_hq_buildings {};
			class create_mortar {};
			class create_supply_officer {};
			class spawn_object {};
			class spawn_civilian {};
		};

		//Subsystem functions

		class Player_Markers
		{
			file = "functions\Game\Subsystems\Player_Markers";
			class player_markers_job {};
			class player_markers_subsystem_init {};
			class player_markers_update_positions {};
		};

		class Squad_compositions
		{
			file = "functions\Game\Squad_compositions";
			class squad_vc_patrol {};
			class squad_vc_standard {};
			class squad_west_spiketeam {};
		};

		class Vehicle_Asset_Manager
		{
			file = "functions\Game\Subsystems\Vehicle_Asset_Manager";
			class veh_asset_add_package_action {};
			class veh_asset_add_vehicle {};
			class veh_asset_data_get {};
			class veh_asset_data_set {};
			class veh_asset_init_vehicle {};
			class veh_asset_job {};
			class veh_asset_marker_create {};
			class veh_asset_marker_delete {};
			class veh_asset_marker_update_position {};
			class veh_asset_package_wreck {};
			class veh_asset_respawn {};
			class veh_asset_set_active {};
			class veh_asset_set_disabled {};
			class veh_asset_set_idle {};
			class veh_asset_set_repairing {};
			class veh_asset_set_respawning {};
			class veh_asset_set_wrecked {};
			class veh_asset_subsystem_init {};
		};

		class Vehicle_Creation_Detection
		{
			file = "functions\Game\Subsystems\Vehicle_Creation_Detection";
			class veh_create_detection_job {};
			class veh_create_detection_subsystem_init {};
		}

		//////////////////////////////////////////
		//UI/TASK ROSTER STUFF:
		class TaskRoster
		{
			/* TaskRoster: */
			class tr_cleanRightSheet {file = "functions\ui\taskroster\fn_tr_cleanRightSheet.sqf";};
			class tr_init {file = "functions\ui\taskroster\fn_tr_init.sqf";};
			class tr_overview_init {file = "functions\ui\taskroster\fn_tr_overview_init.sqf";};
			class tr_overview_team_update {file = "functions\ui\taskroster\fn_tr_overview_team_update.sqf";};

			/* Main Info: */
			class tr_mainInfo_show {file = "functions\ui\taskroster\fn_tr_mainInfo_show.sqf";};

			/* Mission List */
			class tr_zone_change {file = "functions\ui\taskroster\fn_tr_zone_change.sqf";};
			class tr_missions_fill {file = "functions\ui\taskroster\fn_tr_missions_fill.sqf";};
			class tr_missions_show {file = "functions\ui\taskroster\fn_tr_missions_show.sqf";};
			class tr_mission_setActive {file = "functions\ui\taskroster\fn_tr_mission_setActive.sqf";};
			class tr_listboxtask_select {file = "functions\ui\taskroster\fn_tr_listboxtask_select.sqf";};

			/* Support Task Stuff */
			class tr_supportTask_show {file = "functions\ui\taskroster\fn_tr_supportTask_show.sqf";};
			class tr_supportTask_selectTask {file = "functions\ui\taskroster\fn_tr_supportTask_selectTask.sqf";};
			class tr_supportTask_selectTeam {file = "functions\ui\taskroster\fn_tr_supportTask_selectTeam.sqf";};
			class tr_supportTask_selectPosition {file = "functions\ui\taskroster\fn_tr_supportTask_selectPosition.sqf";};
			class tr_supportTask_selectPosition_accept {file = "functions\ui\taskroster\fn_tr_supportTask_selectPosition_accept.sqf";};
			class tr_supportTask_create {file = "functions\ui\taskroster\fn_tr_supportTask_create.sqf";};
			class tr_supportTask_map_hide {file = "functions\ui\taskroster\fn_tr_supportTask_map_hide.sqf";};
			class tr_getMapPosClick {file = "functions\ui\taskroster\fn_tr_getMapPosClick.sqf";};

			/* Team selection */
			class tr_selectTeam {file = "functions\ui\taskroster\fn_tr_selectTeam.sqf";};
			class tr_selectTeam_init {file = "functions\ui\taskroster\fn_tr_selectTeam_init.sqf";};
			class tr_selectTeam_set {file = "functions\ui\taskroster\fn_tr_selectTeam_set.sqf";};

			/* Character Info */
			class tr_characterInfo_show {file = "functions\ui\taskroster\fn_tr_characterInfo_show.sqf";};
		};


		//////////////////////////////////////////

		class TimerOverlay
		{
			file = "functions\ui\TimerOverlay";
			class timerOverlay_hideTimer {};
			class timerOverlay_setTimer {};
			class timerOverlay_showTimer {};
			class timerOverlay_removeTimer {};
		};

		class DisplayExample
		{
			file = "functions\ui\Example";
			class vn_mf_RscDisplayExample;
		};
	};
};
