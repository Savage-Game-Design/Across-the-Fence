class CfgPatches 
{
	class sgd_anarchy_client
	{
		author = "Savage Game Design";
		name = "Anarchy Client";
		url = "https://www.arma3.com";
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
	};
};


class CfgFunctions
{
	class AN_C
	{
		// DEV: Disabled until paradigm is set up properly
		// #include "..\paradigm\an_server\functions.hpp"
		#include "client\functions\functions_c.h"
	};
	
	class AN_G
	{
		#include "global\functions\functions_g.h"
	};
};