class gamemode
{
	class difficulty
	{
		setting = "easy"; // easy, normal, hard
		class easy
		{
			aiskill = 0.1;
			hunger_loss_factor = 0.1;
			thirst_loss_factor = 0.1;
			building_decay_time = 259200;
			building_supplies = 10080;
		};
		class normal
		{
			aiskill = 0.3;
			hunger_loss_factor = 0.5;
			thirst_loss_factor = 0.5;
			building_decay_time = 172800;
			building_supplies = 10080;
		};
		class hard
		{
			aiskill = 0.6;
			hunger_loss_factor = 1.0;
			thirst_loss_factor = 1.0;
			building_decay_time = 86400;
			building_supplies = 10080;
		};
	};
	class rehandler
	{
		allowedfunctions[] =
		{
			"supporttaskcreate",
			"changeteam",
			"drinkwater",
			"eatfood",
			"placedbuilding",
			"refreshtasklist",
			"teleport",
			"supplyrequest",
			"swapbuilding",
			"resupplybuilding",
			"inviteplayer"
		};
	};

	class performance
	{
		// setup game optimizations
		setviewdistance = 2500;
		setobjectviewdistance[] = {2000,800};
		setterraingrid = 10;
		enableenvironment[] = {1, 1};
	};

	class keys
	{
		#include "keys\keys.hpp"
	};

	class objects
	{
		/*
		class vn_mf_obj_deliver_1
		{
			classname = "Land_Barracks_01_dilapidated_F";
			posWorld[]={16892.1,6878.72,38.88}; // getPosWorld
			dir[]={0.636993,-0.770869,0}; // vectorDir
			up[]={0,0,1}; // vectorUp
			swapclass = "Land_Barracks_01_grey_F";
		};
		*/
	};

	class buildables
	{
		class Land_vn_guardhouse_01
		{
			name = "STR_vn_mf_checkpoint";
			type = "checkpoints";
			rank = 0;

			agents[] =  {"vn_b_men_sf_02"}; // todo remove for build state use

			class build_states
			{
				class initial_state
				{
					object_class = "Land_vn_paperbox_closed_f";
					supplies = 0;
				};
				class middle_state
				{
					object_class = "Land_vn_woodencrate_01_f";
					supplies = 50;
				};
				class final_state
				{
					object_class = "Land_vn_guardhouse_01";
					agents[] =  {"vn_b_men_sf_02"};
					supplies = 100;
				};
			};
		};
		class Land_vn_tent_mash_01
		{
			name = "STR_vn_mf_aid_post";
			type = "aid";
			rank = 0;
			class build_states
			{
				class initial_state
				{
					object_class = "Land_vn_paperbox_closed_f";
					supplies = 0;
				};
				class middle_state
				{
					object_class = "Land_vn_woodencrate_01_f";
					supplies = 50;
				};
				class final_state
				{
					object_class = "Land_vn_tent_mash_01";
					supplies = 100;
				};
			};
		};
		class Land_vn_b_tower_01
		{
			name = "STR_vn_mf_fire_support_base";
			type = "fsb";
			rank = 0;
			class build_states
			{
				class initial_state
				{
					object_class = "Land_vn_paperbox_closed_f";
					supplies = 0;
				};
				class middle_state
				{
					object_class = "Land_vn_woodencrate_01_f";
					supplies = 50;
				};
				class final_state
				{
					object_class = "Land_vn_b_tower_01";
					agents[] =  {"vn_b_men_sf_02"};
					supplies = 100;
				};
			};
		};
		class Land_vn_hootch_01
		{
			name = "STR_vn_mf_school";
			type = "schools";
			rank = 0;
			class build_states
			{
				class initial_state
				{
					object_class = "Land_vn_paperbox_closed_f";
					supplies = 0;
				};
				class middle_state
				{
					object_class = "Land_vn_woodencrate_01_f";
					supplies = 50;
				};
				class final_state
				{
					object_class = "Land_vn_hootch_01";
					supplies = 100;
				};
			};
		};
	};

	class supplydrops
	{
		BuildingSupplies[] =
		{
			"STR_vn_mf_building_supplies",
			{"I_supplyCrate_F"}
		};
		FoodSupplies[] =
		{
			"STR_vn_mf_food_supplies",
			{"vn_b_ammobox_supply_02"}
		};
		MedicalSupplies[] =
		{
			"STR_vn_mf_medical_supplies",
			{"vn_b_ammobox_supply_03"}
		};
		AmmoSupplies[] =
		{
			"STR_vn_mf_ammo_supplies",
			{"vn_b_ammobox_supply_01"}
		};
	};

	class crates
	{
		class RESUPPLY
		{
			weapons[] = {};
			magazines[] = {};
			items[] = {{"FirstAidKit", 20}};
			backpacks[] = {};
		};
	};

	class rank
	{
		ranks[] =
		{
			{
				{"\a3\ui_f\data\gui\cfg\ranks\private_pr.paa","Private", 0}	// rank 0 (icon, rank, pointsneeded)
			},
			{
				{"\a3\ui_f\data\gui\cfg\ranks\corporal_pr.paa","Corporal", 10}	// rank 1
			},
			{
				{"\a3\ui_f\data\gui\cfg\ranks\sergeant_pr.paa","Sergeant", 20}	// rank 2
			},
			{
				{"\a3\ui_f\data\gui\cfg\ranks\lieutenant_pr.paa","Lieutenant", 30}	// rank 3
			},
			{
				{"\a3\ui_f\data\gui\cfg\ranks\captain_pr.paa","Captain", 40}	// rank 4
			},
			{
				{"\a3\ui_f\data\gui\cfg\ranks\major_pr.paa","Major", 50}		// rank 5
			},
			{
				{"\a3\ui_f\data\gui\cfg\ranks\colonel_pr.paa","Colonel", 60}	// rank 6
			}
		};
	};

	class stats
	{
		#include "stats\stats.hpp"
	};
	class awards
	{
		#include "awards.hpp"
	};

	class health
	{
		gui_progress_bars[] =
		{
			{"hunger",{0,1,0,0.6}},
			{"thirst",{0,0,1,0.6}}
		};
	};

	class settings
	{
		groups[] =
		{
			{"MikeForce","uns_men_RAR_65_COM"},
			{"SpikeTeam","uns_men_RAR_65_COM"},
			{"ACAV","uns_men_RAR_65_COM"},
			{"GreenHornets","uns_men_RAR_65_COM"}
		};

		class teams
		{
		    //["Regular Name", "path to Icon", "Shortname"]
		    ACAV[] = {"Armored Cavalry", "\vn\ui_f_vietnam\ui\taskroster\img\logos\Logo_ACAV_HL.paa", "ACAV"};
		    GreenHornets[] = {"Air Cavalry / Fast Air support", "\vn\ui_f_vietnam\ui\taskroster\img\logos\Logo_Hornets_HL.paa", "Air Cav. (Green Hornets)"};
		    MikeForce[] = {"Mobile Strike Force Infantry", "\vn\ui_f_vietnam\ui\taskroster\img\logos\Logo_MikeForce_HL.paa", "Mike Force"};
		    SpikeTeam[] = {"Special Forces", "\vn\ui_f_vietnam\ui\taskroster\img\logos\Logo_SpikeTeam_HL.paa", "Spike Team"};
		    FAILED[] = {"NO TEAM","\vn\ui_f_vietnam\ui\taskroster\img\missionTarget_prev.paa", "FAILED"};
		};

	};

	class missionEventHandler
	{
		class Draw3D
		{ // Drawing HUD event
			targets[] = {HEADED_CLIENT_HOST,HEADED_CLIENT};
			// optional: files[] = {"eventHandlers\mission\eh_EntityKilled_yourcustomheader.sqf","eventHandlers\mission\eh_EntityKilled.sqf","eventHandlers\mission\eh_EntityKilled_yourcustomfooter.sqf"};
		};
		class EachFrame
		{ // on each frame event
			targets[] = {HEADED_CLIENT_HOST,HEADED_CLIENT};
		};
		class EntityKilled
		{ // Some entity death event
			targets[] = {HEADED_CLIENT_HOST,DEDICATED_SERVER};
		};
		class PreloadFinished
		{ // preload event finished
			targets[] = {HEADED_CLIENT_HOST,HEADED_CLIENT};
		};
		class EntityRespawned
		{
			targets[] = {HEADED_CLIENT_HOST,DEDICATED_SERVER};
		};
		class HandleDisconnect
		{
			targets[] = {HEADED_CLIENT_HOST,DEDICATED_SERVER};
		};
		class PlayerConnected
		{
			targets[] = {HEADED_CLIENT_HOST,DEDICATED_SERVER};
		};
	};

	class displayEventHandler
	{
		class MouseButtonUp			// mouse up (LMB RMB MMB) handler
		{
			// optional: - files[] = {"eventHandlers\display\eh_KeyDown.sqf"};
		};
		class MouseButtonDown {};		// mouse down (LMB RMB MMB) handler
		class MouseZChanged {};			// mouse scroll EH
		class KeyUp {};				// Keyboard up EH
		class KeyDown {};			// Keyboard down EH
	};
	class playerEventHandler
	{
		class InventoryOpened			// Inventory Opened EH
		{
			// optional: - files[] = {"eventHandlers\player\eh_KeyDown.sqf"};
		};
		class Put {};			// Put EH
		class Take {};			// Take EH
		class HandleRating {};
		class Respawn {};
	};
	class tasks {
		initial_task = "primary_1_ba_ria";
		//Include all task configs
		#include "tasks\tasks.hpp"
	};

	class loadingScreens
	{
		images[] =
		{
			"\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_01_ca.paa",
			"\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_02_ca.paa",
			"\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_03_ca.paa"
		};
	};

	class masterloop
	{

		#include "subconfigs\masterloop.hpp"
	};

	class vars
	{
		#include "vars.hpp"
	};
};
