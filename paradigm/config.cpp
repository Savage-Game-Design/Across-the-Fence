/*
	To use Paradigm in a mission, you need to:
	- Place a copy of Paradigm in the mission folder
	- #define PARA_PATH \my\path\to\paradigm
	- #define PARA_MISSION so Paradigm knows it's being run in a mission
*/

#define PARA_PATH \sgd\paradigm
//Not strictly needed, but it makes it clear we're not a mission.
//#ifdef PARA_MISSION
//#undef PARA_MISSION
//#endif

class CfgPatches 
{
	class sgd_paradigm
	{
		author = "Savage Game Design";
		name = "Paradigm";
		url = "https://www.arma3.com";
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"objects_f_vietnam_c","objects_f_vietnam","ui_f_vietnam","ui_fonts_f_vietnam"};
	};
};

//We use this to check if Paradigm is loaded as an addon.
//isClass (configFile >> "Paradigm")
class Paradigm {};

#include "client\config.hpp"
#include "server\config.hpp"

class CfgFunctions
{
	#include "client\functions.hpp"
	#include "server\functions.hpp"
};

class CfgNotifications
{
	#include "client\configs\notifications.hpp"
};

class CfgRespawnTemplates
{
	#include "global\config\respawn_templates\MenuPosition.inc"
};