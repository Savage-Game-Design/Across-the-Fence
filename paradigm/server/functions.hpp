#include "..\common_includes.hpp"
#include "..\global\functions.hpp"

#define PARA_SERVER_PATH(PATH) file=QUOTE(CONCAT_3(PARA_PATH,\server\functions,PATH))

class para_s
{
	class default
	{
		PARA_SERVER_PATH(\);
	};

	class ai
	{
		PARA_SERVER_PATH(\ai);
		class ai_add_player_event_handlers {};
		class ai_group_report_combat {};
	};

	class ai_objectives
	{
		PARA_SERVER_PATH(\ai_objectives);
		class ai_obj_assign_to_objective {};
		class ai_obj_available_reinforcements {};
		class ai_obj_create_objective {};
		class ai_obj_create_squads_from_unit_count {};
		class ai_obj_delete_objective {};
		class ai_obj_entity_killed_update_reinforcements {};
		class ai_obj_finish_objective {};
		class ai_obj_get_objective_by_id {};
		class ai_obj_give_group_ownership {};
		class ai_obj_job {};
		class ai_obj_reinforce {};
		class ai_obj_objective_reinforcements_full_strength_unit_quantity {};
		class ai_obj_request_ambush {};
		class ai_obj_request_attack {};
		class ai_obj_request_crew {};
		class ai_obj_request_defend {};
		class ai_obj_request_patrols {};
		class ai_obj_request_pursuit {};
		class ai_obj_subsystem_init {};
		class ai_obj_unassign_from_objective {};
	};

	class allow_damage
	{
		PARA_SERVER_PATH(\allow_damage);
		class allow_damage_persistent {};
	};

	class basebuilding
	{
		PARA_SERVER_PATH(\basebuilding);
		class base_create {};
		class base_delete {};
		class base_deserialize {};
		class base_serialize {};
		class basebuilding_load {};
		class basebuilding_save {};
		class building_add_build_progress {};
		class building_change_objects {};
		class building_connect_base {};
		class building_connect_supply_source {};
		class building_consume_supplies {};
		class building_create {};
		class building_delete {};
		class building_deserialize {};
		class building_disconnect_base {};
		class building_disconnect_supply_source {};
		class building_functional_update {};
		class building_on_constructed {};
		class building_on_deconstructed {};
		class building_on_functional {};
		class building_on_hit {};
		class building_on_non_functional {};
		class building_serialize {};
		class building_state_tracker {};
		class building_system_init {};
		class placedbuilding {};
		class replace_building {};
		class resupplybuilding {};
		class supply_source_create {};
	};

	class building_features_maintenance
	{
		PARA_SERVER_PATH(\building_features\maintenance);
		class bf_maintenance_on_building_objects_changed {};
		class bf_maintenance_rearm_vehicle {};
		class bf_maintenance_refuel_vehicle {};
		class bf_maintenance_rehandler {};
		class bf_maintenance_repair_vehicle {};
	};

	class building_features_radio
	{
		PARA_SERVER_PATH(\building_features\radio);
		class bf_radio_on_functional {};
		class bf_radio_on_nonfunctional {};
	};

	class building_features_respawn
	{
		PARA_SERVER_PATH(\building_features\respawn);
		class bf_respawn_on_functional {};
		class bf_respawn_on_nonfunctional {};
		class bf_respawn_on_supplies_changed {};
		class bf_respawn_register_respawn {};
		class bf_respawn_unregister_respawn {};
	};

	class building_features_supply_depot
	{
		PARA_SERVER_PATH(\building_features\supply_depot);
		class bf_supply_depot_on_base_connected {};
		class bf_supply_depot_on_base_disconnected {};
	};

	class building_features_vehicle_spawning
	{
		PARA_SERVER_PATH(\building_features\vehicle_spawning);
		class bf_veh_spawn_create_vehicle {};
		class bf_veh_spawn_create_vehicle_rehandler {};
		class bf_veh_spawn_on_building_objects_changed {};
		class bf_veh_spawn_on_building_placed {};
		class bf_veh_spawn_on_functional {};
		class bf_veh_spawn_on_nonfunctional {};
	};

	class building_features_wreck_recovery
	{
		PARA_SERVER_PATH(\building_features\wreck_recovery);
		class bf_wreck_recovery_availablity_check {};
		class bf_wreck_recovery_on_building_delete {};
		class bf_wreck_recovery_on_building_placed {};
	};

	class cleanup
	{
		PARA_SERVER_PATH(\cleanup);
		class cleanup_add_items {};
		class cleanup_job {};
		class cleanup_register_player {};
		class cleanup_subsystem_init {};
	};

	class day_night_cycle
	{
		PARA_SERVER_PATH(\day_night_cycle);
		class day_night_job {};
		class day_night_subsystem_init {};
	};

	class db
	{
		PARA_SERVER_PATH(\db);
		class profile_db {};
	};

	class harass
	{
		PARA_SERVER_PATH(\harass);
		class harass_add_player_event_handlers {};
		class harass_calculate_difficulty {};
		class harass_create_squads {};
		class harass_job {};
		class harass_subsystem_init {};
	};

	class init
	{
		PARA_SERVER_PATH(\init);
		class init_server { postInit = 1; };
		class init_player {};
		class postinit_player {};
	};

	class load_balancer
	{
		PARA_SERVER_PATH(\load_balancer);
		class loadbal_create_squad {};
		class loadbal_fps_aggregator {};
		class loadbal_set_fps {};
		class loadbal_subsystem_init {};
		class loadbal_suggest_host {};
	};

	class networked_actions
	{
		PARA_SERVER_PATH(\networked_actions);
		class net_action_add {};
		class net_action_fire {};
		class net_action_hold_add {};
		class net_action_hold_fire {};
		class net_action_hold_remove {};
		class net_action_remove {};
	};

	class performance
	{
		PARA_SERVER_PATH(\performance);
		class enable_dynamic_sim {};
	};

	class rehandler
	{
		PARA_SERVER_PATH(\rehandler);
		class rehandler {};
		class set_public_variable {};
	};

	class remoteExec
	{
		PARA_SERVER_PATH(\remoteExec);
		class remoteExec_jip_obj_stacked {};
		class remoteExecCall_jip_obj_stacked {};
	};

	class respawn
	{
		PARA_SERVER_PATH(\respawn);
		class on_player_respawn_rehandler {};
	};

	class terrain
	{
		PARA_SERVER_PATH(\terrain);
		class hide_foliage {};
	};

	class voting
	{
		PARA_SERVER_PATH(\voting);
		class create_vote {};
		class finish_vote {};
		class submit_vote {};
	};

	class tools
	{
		PARA_SERVER_PATH(\tools);
		class fell_tree {};  // needs to stay on server
		class fell_tree_initial {};
	};
};
