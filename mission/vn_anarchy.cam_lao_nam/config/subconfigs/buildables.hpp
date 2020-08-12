#define CONDITION_HAS_RANK { $STR_vn_mf_buildingMenu_condition_hasRank, "player getVariable ['vn_mf_db_rank',0] >= getNumber(_config >> 'rank')"}
#define CONDITION_IS_ENGINEER { $STR_vn_mf_buildingMenu_condition_isEngineer, "player getUnitTrait 'engineer'"}
#define CONDITION_IS_ON_FOOT { $STR_vn_mf_buildingMenu_condition_rnFoot, "isNull objectParent player"}
#define CONDITION_NOT_IN_RESTRICTED_ZONE { $STR_vn_mf_buildingMenu_condition_inRestrictedZone, "['blocked_area1', 'blocked_area2', 'blocked_area3'] findIf {_pos inArea _x} isEqualTo -1"}
#define CONDITION_IS_ACAV { $STR_vn_mf_buildingMenu_condition_inACav, "groupId group player isEqualTo 'ACAV'"}

//Takes "Capacity" in supply units, and "Lifetime" in seconds.
#define DAYS_TO_SECONDS(days) (days * 86400)
#define HOURS_TO_SECONDS(hours) (hours * 3600)
#define MINUTES_TO_SECONDS(minutes) (minutes * 60)
#define SUPPLY_CAPACITY(capacity, lifetime) \
	supply_capacity = capacity; \
	supply_consumption = __EVAL(capacity / lifetime)

class Land_vn_guardhouse_01
{
	name = "STR_vn_mf_checkpoint";
	type = "checkpoints";
	categories[] = {"respawn", "functional", "blufor", "buildings"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {"vn_b_men_sf_02"};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_guardhouse_01_part0";
		};
		class middle_state
		{
			object_class = "vn_guardhouse_01_part1";
		};
		class final_state
		{
			object_class = "Land_vn_guardhouse_01";
			features[] = {"respawn"};
		};
	};
};

class Land_vn_tent_mash_01
{
	name = "STR_vn_mf_aid_post";
	type = "aid";
	categories[] = {"medical", "functional", "blufor", "tents"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_tent_mash_01_part0";
		};
		class middle_state
		{
			object_class = "vn_tent_mash_01_part1";
		};
		class final_state
		{
			object_class = "Land_vn_tent_mash_01";
		};
	};
};

class Land_vn_b_tower_01
{
	name = "STR_vn_mf_guardtower";
	type = "towers";
	categories[] = {"towers", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_tower_01_part0";
		};
		class middle_state
		{
			object_class = "vn_b_tower_01_part1";
		};
		class final_state
		{
			object_class = "Land_vn_b_tower_01";
		};
	};
};

class Land_vn_hootch_01
{
	name = "STR_vn_mf_school";
	type = "schools";
	categories[] = {"buildings"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_hootch_01_part0";
		};
		class middle_state
		{
			object_class = "vn_hootch_01_part1";
		};
		class final_state
		{
			object_class = "Land_vn_hootch_01";
		};
	};
};

class Land_vn_latrine_01
{
	name = "";
	type = "latrines";
	categories[] = {"buildings", "blufor", "sanitation"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_latrine_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_latrine_01";
		};
		class final_state
		{
			object_class = "Land_vn_latrine_01";
		};
	};
};
class Land_vn_shower_01
{
	name = "";
	type = "showers";
	categories[] = {"buildings", "blufor", "sanitation"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_shower_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_shower_01";
		};
		class final_state
		{
			object_class = "Land_vn_shower_01";
		};
	};
};

class vn_b_ammobox_supply_07
{
	name = "STR_vn_mf_ammoresupply";
	type = "ammocrates";
	categories[] = {"resupply", "functional"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.5;
	resupply = "WorkshopSupplies";
	nearby[] = {"ammo"};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_ammobox_supply_07";
		};
		class middle_state
		{
			//TODO: Fix this, this shouldn't able to resupply in middle state.
			object_class = "vn_b_ammobox_supply_07";
		};
		class final_state
		{
			object_class = "vn_b_ammobox_supply_07";
		};
	};
};
class vn_b_ammobox_supply_08
{
	name = "STR_vn_mf_repairresupply";
	type = "resupplycrates";
	categories[] = {"resupply", "functional"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.5;
	resupply = "WorkshopSupplies";
	nearby[] = {"repair"};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_ammobox_supply_08";
		};
		class middle_state
		{
			//TODO: Fix this, should not be able to rearm in middle state
			object_class = "vn_b_ammobox_supply_08";
		};
		class final_state
		{
			object_class = "vn_b_ammobox_supply_08";
		};
	};
};
class vn_b_ammobox_supply_09
{
	name = "STR_vn_mf_fuelresupply";
	type = "refuelcrates";
	categories[] = {"resupply", "functional"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.5;
	resupply = "WorkshopSupplies";
	nearby[] = {"fuel"};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_ammobox_supply_09";
		};
		class middle_state
		{
			//TODO: FIx this, hsould not be able to refuel in middle state.
			object_class = "vn_b_ammobox_supply_09";
		};
		class final_state
		{
			object_class = "vn_b_ammobox_supply_09";
		};
	};
};

class Land_vn_bridge_bailey_01
{
	name = "STR_vn_mf_bridgebailey01";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;
	offset[] = {22.19,0,0};
	max_segments = 10;
	min_distance = 15;
	max_distance = 30;
	check_pos_start[] = {-10.386,0.14209,-0.55};
	check_pos_stop[] = {10.386,0.14209,-0.55};

	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_bailey_01_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_bailey_01_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_bailey_01";
		};
	};
};
class Land_vn_bridge_bailey_02
{
	name = "STR_vn_mf_bridgebailey02";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;
	offset[] = {22.19,0,0};
	max_segments = 10;
	min_distance = 15;
	max_distance = 30;
	check_pos_start[] = {-10.386,0.14209,-0.55};
	check_pos_stop[] = {10.386,0.14209,-0.55};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_bailey_02_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_bailey_02_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_bailey_02";
		};
	};
};
class Land_vn_bridge_bailey_03
{
	name = "STR_vn_mf_bridgebailey03";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;
	offset[] = {22.19,0,0};
	max_segments = 10;
	min_distance = 15;
	max_distance = 30;
	check_pos_start[] = {-10.386,0.14209,-0.55};
	check_pos_stop[] = {10.386,0.14209,-0.55};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_bailey_03_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_bailey_03_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_bailey_03";
		};
	};
};
class Land_vn_bridge_bailey_04
{
	name = "STR_vn_mf_bridgebailey04";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;
	offset[] = {22.19,0,0};
	max_segments = 10;
	min_distance = 15;
	max_distance = 30;
	check_pos_start[] = {-10.386,0.14209,-0.55};
	check_pos_stop[] = {10.386,0.14209,-0.55};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_bailey_04_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_bailey_04_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_bailey_04";
		};
	};
};

class Land_vn_bridge_ramp_01
{
	name = "STR_vn_mf_bridgeramp01";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;

	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_ramp_01_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_ramp_01_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_ramp_01";
		};
	};
};

class Land_vn_bridge_small_01
{
	name = "STR_vn_mf_bridgesmall01";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;
	offset[] = {22.19,0,0};
	max_segments = 10;
	min_distance = 15;
	max_distance = 30;
	check_pos_start[] = {-10.386,0.14209,-0.55};
	check_pos_stop[] = {10.386,0.14209,-0.55};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_small_01_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_small_01_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_small_01";
		};
	};
};
class Land_vn_bridge_small_02
{
	name = "STR_vn_mf_bridgesmall02";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;
	offset[] = {22.19,0,0};
	max_segments = 10;
	min_distance = 15;
	max_distance = 30;
	check_pos_start[] = {-10.386,0.14209,-0.55};
	check_pos_stop[] = {10.386,0.14209,-0.55};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_small_02_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_small_02_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_small_02";
		};
	};
};
class Land_vn_bridge_small_03
{
	name = "STR_vn_mf_bridgesmall03";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;
	offset[] = {22.19,0,0};
	max_segments = 10;
	min_distance = 15;
	max_distance = 30;
	check_pos_start[] = {-10.386,0.14209,-0.55};
	check_pos_stop[] = {10.386,0.14209,-0.55};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_small_03_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_small_03_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_small_03";
		};
	};
};

class Land_vn_bridge_small_04
{
	name = "STR_vn_mf_bridgesmall04";
	type = "bridges";
	categories[] = {"bridges"};
	rank = 0;
	SUPPLY_CAPACITY(1000, DAYS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	rotation = -90;
	offset[] = {22.19,0,0};
	max_segments = 10;
	min_distance = 15;
	max_distance = 30;
	check_pos_start[] = {-10.386,0.14209,-0.55};
	check_pos_stop[] = {10.386,0.14209,-0.55};
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bridge_small_04_part0";
		};
		class middle_state
		{
			object_class = "vn_bridge_small_04_part1";
		};
		class final_state
		{
			object_class = "Land_vn_bridge_small_04";
		};
	};
};


class Land_vn_bunker_small_01
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bunker_small_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_bunker_small_01";
		};
		class final_state
		{
			object_class = "Land_vn_bunker_small_01";
		};
	};
};
class Land_vn_bunker_big_01
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bunker_big_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_bunker_big_01";
		};
		class final_state
		{
			object_class = "Land_vn_bunker_big_01";
		};
	};
};
class Land_vn_bunker_big_02
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.4;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_bunker_big_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_bunker_big_02";
		};
		class final_state
		{
			object_class = "Land_vn_bunker_big_02";
		};
	};
};
class Land_vn_b_trench_wall_01_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	offset[] = {0,6.5,0};
	//max_segments = 3;
	min_distance = 7;
	max_distance = 15;
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_01_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_01_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_01_01";
		};
	};
};
class Land_vn_b_trench_wall_01_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_01_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_01_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_01_02";
		};
	};
};
class Land_vn_b_trench_wall_01_03
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_01_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_01_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_01_03";
		};
	};
};
class Land_vn_b_trench_wall_03_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_03_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_03_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_03_01";
		};
	};
};
class Land_vn_b_trench_wall_03_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_03_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_03_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_03_02";
		};
	};
};
class Land_vn_b_trench_wall_03_03
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_03_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_03_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_03_03";
		};
	};
};
class Land_vn_b_trench_wall_05_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_05_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_05_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_05_01";
		};
	};
};

class Land_vn_b_trench_wall_05_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_05_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_05_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_05_02";
		};
	};
};
class Land_vn_b_trench_wall_05_03
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_05_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_05_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_05_03";
		};
	};
};
class Land_vn_b_trench_wall_10_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_10_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_10_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_10_01";
		};
	};
};
class Land_vn_b_trench_wall_10_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_10_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_10_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_10_02";
		};
	};
};

class Land_vn_b_trench_wall_10_03
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_wall_10_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_wall_10_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_wall_10_03";
		};
	};
};

class Land_vn_b_trench_tee_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_tee_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_tee_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_tee_01";
		};
	};
};
class Land_vn_b_trench_stair_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_stair_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_stair_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_stair_01";
		};
	};
};
class Land_vn_b_trench_stair_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_stair_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_stair_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_stair_02";
		};
	};
};

class Land_vn_b_trench_revetment_tall_09
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_revetment_tall_09_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_revetment_tall_09";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_revetment_tall_09";
		};
	};
};

class Land_vn_b_trench_revetment_tall_03
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_revetment_tall_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_revetment_tall_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_revetment_tall_03";
		};
	};
};

class Land_vn_b_trench_revetment_90_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_revetment_90_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_revetment_90_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_revetment_90_01";
		};
	};
};

class Land_vn_b_trench_revetment_05_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(2));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_revetment_05_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_revetment_05_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_revetment_05_01";
		};
	};
};

class Land_vn_b_trench_firing_05
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_firing_05_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_firing_05";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_firing_05";
		};
	};
};

class Land_vn_b_trench_firing_04
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_firing_04_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_firing_04";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_firing_04";
		};
	};
};

class Land_vn_b_trench_firing_03
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_firing_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_firing_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_firing_03";
		};
	};
};

class Land_vn_b_trench_firing_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_firing_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_firing_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_firing_02";
		};
	};
};

class Land_vn_b_trench_firing_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_firing_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_firing_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_firing_01";
		};
	};
};

class Land_vn_b_trench_end_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_end_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_end_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_end_01";
		};
	};
};

class Land_vn_b_trench_cross_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_cross_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_cross_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_cross_02";
		};
	};
};

class Land_vn_b_trench_cross_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(400, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_cross_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_cross_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_cross_01";
		};
	};
};

class Land_vn_b_trench_corner_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor","nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_corner_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_corner_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_corner_01";
		};
	};
};

class Land_vn_b_trench_bunker_06_02
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.3;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_06_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_06_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_06_02";
		};
	};
};

class Land_vn_b_trench_bunker_06_01
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.3;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_06_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_06_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_06_01";
		};
	};
};

class Land_vn_b_trench_bunker_05_02
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_05_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_05_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_05_02";
		};
	};
};

class Land_vn_b_trench_bunker_05_01
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_05_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_05_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_05_01";
		};
	};
};

class Land_vn_b_trench_bunker_04_01
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_04_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_04_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_04_01";
		};
	};
};

class Land_vn_b_trench_bunker_03_04
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_03_04_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_03_04";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_03_04";
		};
	};
};

class Land_vn_b_trench_bunker_03_03
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_03_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_03_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_03_03";
		};
	};
};

class Land_vn_b_trench_bunker_03_02
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_03_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_03_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_03_02";
		};
	};
};

class Land_vn_b_trench_bunker_03_01
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_03_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_03_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_03_01";
		};
	};
};

class Land_vn_b_trench_bunker_02_04
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_02_04_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_02_04";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_02_04";
		};
	};
};

class Land_vn_b_trench_bunker_02_03
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_02_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_02_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_02_03";
		};
	};
};

class Land_vn_b_trench_bunker_02_02
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_02_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_02_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_02_02";
		};
	};
};

class Land_vn_b_trench_bunker_02_01
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_02_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_02_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_02_01";
		};
	};
};

class Land_vn_b_trench_bunker_01_03
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_01_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_01_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_01_03";
		};
	};
};

class Land_vn_b_trench_bunker_01_02
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_01_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_01_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_01_02";
		};
	};
};

class Land_vn_b_trench_bunker_01_01
{
	name = "";
	type = "bunkers";
	categories[] = {"bunkers", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_bunker_01_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_bunker_01_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_bunker_01_01";
		};
	};
};

class Land_vn_b_trench_90_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_90_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_90_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_90_02";
		};
	};
};

class Land_vn_b_trench_90_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(400, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_90_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_90_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_90_01";
		};
	};
};

class Land_vn_b_trench_45_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_45_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_45_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_45_02";
		};
	};
};

class Land_vn_b_trench_45_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(400, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_45_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_45_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_45_01";
		};
	};
};

class Land_vn_b_trench_20_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(300, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.3;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_20_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_20_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_20_02";
		};
	};
};

class Land_vn_b_trench_20_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_20_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_20_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_20_01";
		};
	};
};

class Land_vn_b_trench_05_03
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_05_03_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_05_03";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_05_03";
		};
	};
};

class Land_vn_b_trench_05_02
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.3;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_05_02_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_05_02";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_05_02";
		};
	};
};

class Land_vn_b_trench_05_01
{
	name = "";
	type = "trenches";
	categories[] = {"trenches", "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_trench_05_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_trench_05_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_trench_05_01";
		};
	};
};

class Land_vn_b_mortarpit_01
{
	name = "";
	type = "mortarpits";
	categories[] = { "fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_mortarpit_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_mortarpit_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_mortarpit_01";
		};
	};
};

class Land_vn_b_helipad_01
{
	name = "";
	type = "helipads";
	categories[] = {"helipads", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.5;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_helipad_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_helipad_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_helipad_01";
		};
	};
};

class Land_vn_b_gunpit_01
{
	name = "";
	type = "gunpits";
	categories[] = {"fortifications", "blufor"};
	rank = 0;
	SUPPLY_CAPACITY(500, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.2;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE,
		CONDITION_IS_ACAV
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_gunpit_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_gunpit_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_gunpit_01";
		};
	};
};

class Land_vn_b_foxhole_01
{
	name = "";
	type = "foxholes";
	categories[] = {"trenches", "fortifications", "blufor", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.25;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_b_foxhole_01_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_b_foxhole_01";
		};
		class final_state
		{
			object_class = "Land_vn_b_foxhole_01";
		};
	};
};

class Land_vn_o_shelter_06
{
	name = "";
	type = "shelters";
	categories[] = {"tents", "fortifications", "nv", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(100, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.1;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_o_shelter_06_part0";
		};
		class middle_state
		{
			object_class = "Land_vn_o_shelter_06";
		};
		class final_state
		{
			object_class = "Land_vn_o_shelter_06";
		};
	};
};

class Land_vn_o_tower_01
{
	name = "";
	type = "towers";
	categories[] = {"towers", "nv", "nonACav"};
	rank = 0;
	SUPPLY_CAPACITY(200, HOURS_TO_SECONDS(4));
	minimum_supplies_to_function = 0.3;
	agents[] =  {};
	resupply = "BuildingSupplies";
	conditions[] = {
		CONDITION_HAS_RANK,
		CONDITION_IS_ENGINEER,
		CONDITION_IS_ON_FOOT,
		CONDITION_NOT_IN_RESTRICTED_ZONE
	};
	class build_states
	{
		class initial_state
		{
			object_class = "vn_o_tower_01_part0";
		};
		class middle_state
		{
			object_class = "vn_o_tower_01_part1";
		};
		class final_state
		{
			object_class = "Land_vn_o_tower_01";
		};
	};
};
