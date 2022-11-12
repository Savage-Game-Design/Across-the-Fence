//Used to prevent re-including the global function definitions if they've already been included
#ifndef PARA_GLOBAL
#define PARA_GLOBAL
#include "..\common_includes.hpp"

#define PARA_GLOBAL_PATH(PATH) file=QUOTE(CONCAT_3(PARA_PATH,\global\functions,PATH))


class para_g
{
	class default
	{
		PARA_GLOBAL_PATH(\);

	};

	class ai
	{
		PARA_GLOBAL_PATH(\ai);
		class ai_behaviour_init {};
		class ai_behaviour_subsystem_init {};
		class ai_create_behaviour_execution_loop {};
		class ai_public_var_get {};
		class ai_public_var_set {};
		class ai_run_behaviours_all_groups {};
		class ai_scale_to_player_count {};
	};

	class ai_behaviours
	{
		PARA_GLOBAL_PATH(\ai_behaviours);
		class behaviour_ambush {};
		class behaviour_attack {};
		class behaviour_combat {};
		class behaviour_combat_check {};
		class behaviour_assign_nearby_statics {};
		class behaviour_hold {};
		class behaviour_get_unclaimed_statics {};
		class behaviour_investigate_nearby_combat {};
		class behaviour_is_valid_target {};
		class behaviour_main {};
		class behaviour_move_to {};
		class behaviour_patrol {};
		class behaviour_patrol_points {};
		class behaviour_patrol_roads {};
		class behaviour_process_claimed_statics {};
		class behaviour_pursue {};
		class behaviour_report_combat {};
		class behaviour_set_group_stance {};
		class behaviour_set_unit_stance {};
		class behaviour_unassign_statics {};
		class behaviour_update_ai_knowledge {};
		class behaviour_vehicle_assign {};
		class behaviour_vehicle_unassign {};
		class behaviour_waypoint {};
	};

	class basebuilding
	{
		PARA_GLOBAL_PATH(\basebuilding);
		class bases_containing_pos {};
		class building_class_fire_feature_event {};
		class building_class_get_feature_configs {};
		class building_fire_feature_event {};
		class building_is_decaying {};
		class building_is_functional {};
		class get_building_config {};
		class is_resupply {};
	};

	class building_features_vehicle_spawning
	{
		PARA_GLOBAL_PATH(\building_features\vehicle_spawning);
		class bf_veh_spawn_can_place_building {};
	};

	class building_features_wreck_recovery
	{
		PARA_GLOBAL_PATH(\building_features\wreck_recovery);
		class bf_wreck_recovery_cooldown_check {};
	};

	class config_file
	{
		//This loads the correct config file for paradigm, depending if it's run as a mission or addon.
		class config_file
		{
			preInit = 1;
			PARA_GLOBAL_PATH(\config_file\config_file_runtime.sqf);
		};
	};

	class create
	{
		PARA_GLOBAL_PATH(\create);
		class create_crate {};
		class create_group {};
		class create_mine {};
		class create_squad {};
		class create_unit {};
		class create_vehicle {};
		class create_vehicle_safely {};
	};

	class data_structures_arraydict
	{
		PARA_GLOBAL_PATH(\data_structures\arraydict);
		class arraydict_create {};
		class arraydict_get {};
		class arraydict_remove {};
		class arraydict_set {};
	};

	class data_structures_namespace
	{
		PARA_GLOBAL_PATH(\data_structures\namespace);
		class create_namespace {};
		class delete_namespace {};
	};

	class data_structures_struct
	{
		PARA_GLOBAL_PATH(\data_structures\struct);
		class load_structs { preInit = 1; };
		class create_struct {};
		class deserialize_struct {};
		class serialize_struct {};
	};

	class events
	{
		PARA_GLOBAL_PATH(\events);
		class event_add_handler {};
		class event_dispatch_immediate {};
		class event_dispatch {};
		class event_dispatcher_job {};
		class event_fire {};
		class event_remove_handler {};
		class event_subsystem_init {};
	};

	class fallthrough_world_checker
	{
		PARA_GLOBAL_PATH(\create\fallthrough_world_checker);
		class fallthrough_checker_add_object {};
		class fallthrough_checker_job {};
		class fallthrough_checker_subsystem_init {};
	};

	class localized_markers
	{
		PARA_GLOBAL_PATH(\localized_markers);
		class create_localized_marker {};
		class delete_localized_marker {};
	};

	class logging
	{
		PARA_GLOBAL_PATH(\logging);
		class log { headerType = -1;};
	};

	class mission_interop
	{
		PARA_GLOBAL_PATH(\mission_interop);
		class load_interop_functions { postInit = 1; };
	};

	class networked_actions
	{
		PARA_GLOBAL_PATH(\networked_actions);
		class net_action_varname {};
	};

	class respawn
	{
		PARA_GLOBAL_PATH(\respawn);
		class respawn_menu {};
	};

	class serialization
	{
		PARA_GLOBAL_PATH(\serialization);
		class serialize_namespace {};
		class serialize_object {};
	};

	class scheduler
	{
		PARA_GLOBAL_PATH(\scheduler);
		class scheduler_add_job {};
		class scheduler_get_job {};
		class scheduler_monitor {};
		class scheduler_remove_job {};
		class scheduler_start {};
		class scheduler_subsystem_init {};
	};

	class spawning
	{
		PARA_GLOBAL_PATH(\spawning);
		class spawning_find_valid_position_tracer {};
		class spawning_get_squad_composition {};
		class spawning_valid_attack_angles {};
	};

	class helpers
	{
		PARA_GLOBAL_PATH(\helpers);
		class add_allow_damage_persistence {};
		class build_unit_clusters {};
		class compile_functions {};
		class count_alive_units_in_groups {};
		class count_units_in_groups {};
		class create_or_reuse_waypoint {};
		class custom_scope {};
		class get_gamemode_value {};
		class init_mission_handlers {};
		class localize_slingloaded_objects {};
		class paradigm_config_file {};
		class parse_pos_config {};
		class vehicle_will_collide_at_pos {};
		class unit_is_incapacitated {};
	};
	class tools
	{
		PARA_GLOBAL_PATH(\tools);
		class is_valid_axe_target {};
	};
};

#endif
