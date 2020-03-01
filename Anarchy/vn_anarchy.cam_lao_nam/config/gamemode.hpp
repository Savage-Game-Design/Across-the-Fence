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
			"drinkwater",
			"eatfood",
			"teleport",
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
