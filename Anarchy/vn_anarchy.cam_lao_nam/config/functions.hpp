class cfgfunctions
{
	class vn_an
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
			//class enable_task_roster {};
			//class enable_build_mode {};
			//class enable_build_cycle1 {};
			//class enable_build_cycle2 {};
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
			class player_within_radius {};
		};
		class rehandler
		{
			class changeteam {};
			class drinkwater {};
			class eatfood {};
			class teleport {};
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
			class save_time_elapsed {};
			class player_health_stats {};
			class change_player_stat {};

			//Scheduler
			class scheduler_add_job {};
			class scheduler_remove_job {};
			class scheduler_start {};
			class scheduler_monitor {};
			class scheduler_init {};
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

			class spawn_object {};
			class spawn_enemy_units {};
			class spawn_civilian {};
		};

		//Subsystem functions


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
