class cfgfunctions
{
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
			class debug_monitor {};
			class master_loop_init {};
			class init_key_down {};
			class init_key_up {};
			class enable_debug_monitor {};
			class change_key_bind {};
			class enable_task_roster {};
			class enable_build_mode {};
			class enable_build_cycle1 {};
			class enable_build_cycle2 {};
			class enable_keydown_shift {};
			class enable_keydown_ctrl {};
			class enable_keydown_alt {};
			class enable_keyup_shift {};
			class enable_keyup_ctrl {};
			class enable_keyup_alt {};
			class start_game_stage2 {};
			class update_loading_screen {};
			class display_location_time {};
		};
		class helpers
		{
			class count_units_in_groups {};
			class create_namespace {};
			class custom_scope {};
			class delete_namespace {};
			class init_mission_handlers {};
			class parse_pos_config {};
			class units_on_team {};
			class vehicle_will_collide_at_pos {};
		};
		class rehandler
		{
			class supporttaskcreate {};
			class changeteam {};
			class drinkwater {};
			class eatfood {};
			class placedbuilding {};
			class refreshtasklist {};
			class teleport {};
			class supplyrequest {};
			class swapbuilding {};
			class resupplybuilding {};
			class inviteplayer {};
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
			class armor_calc {};
			class ui_sub_menu {};
			class ammo_repack {};
			class init_display_event_handler {};
			class init_player_event_handlers {};
			class init_public_variable_event_handlers {};
			class unit_to_rank {};
			class player_rank_up {};
			class ui_create {};
			class ui_update {};
			class unit_next_rank {};
			class points_to_next_rank {};

			// both
			class get_gamemode_value {};
			class check_enemy_units_alive {};
			class progress_to_color_config {};
			class player_respawn_loc {};

			// server
			class place_object {};
			class group_init {};
			class building_state_tracker {};

			class player_on_team {};
			class player_rank {};
			class player_health_stats {};
			class player_within_radius {};
			class swap_building {};
			class delete_building {};
			class save_time_elapsed {};

			// stats
			class change_player_stat {};

			//Scheduler
			class scheduler_add_job {};
			class scheduler_remove_job {};
			class scheduler_start {};
			class scheduler_monitor {};

			//Tasks
			class task_init {};
			class task_complete {};
			class task_create {};
			class task_refresh_task_list {};
			class task_refresh_tasks_client {};
			class task_subtask_complete {};
			class task_subtask_create {};

			//Zones
			class zone_complete;
			class zone_init {};
			class zone_make_active;
			class zone_active_job;

		};
		class db
		{
			class hive {};
		};
		class server
		{
			class rehandler {};
			class init_player {};
			class start_game_server {};
			class end_mission {};
		};

		class tasks
		{
			class simple_task_system { file = "functions\tasks\fn_simple_task_system.sqf"; };
			class state_machine_task_system { file = "functions\tasks\fn_state_machine_task_system.sqf"; };
			class task_pri_9 { file = "functions\tasks\primary\fn_task_pri_9.sqf"; };
			class task_sec_clear_minefield { file = "functions\tasks\secondary\fn_task_sec_clear_minefield.sqf";};
			class task_sec_combat_air_patrol { file = "functions\tasks\secondary\fn_task_sec_combat_air_patrol.sqf"; };
			class task_sec_destroy_camp { file = "functions\tasks\secondary\fn_task_sec_destroy_camp.sqf";};
			class task_sec_destroy_emplacement { file = "functions\tasks\secondary\fn_task_sec_destroy_emplacement.sqf";};
			class task_sec_kill_officer { file = "functions\tasks\secondary\fn_task_sec_kill_officer.sqf";};
			class task_sec_reinforce { file = "functions\tasks\secondary\fn_task_sec_reinforce.sqf";};
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
			class create_camp {};
			class create_crate {};
			class create_group {};
			class create_mine {};
			class create_squad {};
			class create_unit {};
			class create_vehicle {};
			class create_vehicle_safely {};
			class spawn_objects {};
			class spawn_object {};
			class spawn_enemy_units {};
			class spawn_civilian {};
		};

		//Subsystem functions

		class Cleanup
		{
			file = "functions\Game\Subsystems\Cleanup";
			class cleanup_addItems {};
			class cleanup_job {};
			class cleanup_subsystem_init {};
		};

		class Events
		{
			file = "functions\Game\Subsystems\Events";
			class event_add_handler {};
			class event_remove_handler {};
			class event_dispatch {};
			class event_dispatcher_job {};
			class event_subsystem_init {};
		}

		class Patrol
		{
			file = "functions\Game\Subsystems\Patrol";
			class patrol_assign_group {};
			class patrol_create {};
			class patrol_job {};
			class patrol_subsystem_init {};
		};

		class Squad_compositions
		{
			file = "functions\Game\Squad_compositions";
			class squad_patrol {};
			class squad_standard {};
			class squad_west_spiketeam {};
		}
	};
};
