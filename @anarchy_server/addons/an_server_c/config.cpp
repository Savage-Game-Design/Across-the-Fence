class CfgPatches 
{
	class sgd_anarchy_server 
	{
		author = "Savage Game Design";
		name = "Anarchy Server";
		url = "https://www.arma3.com";
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"sgd_anarchy_client"};
	};
};

// #define PARA_PATH \paradigm

class CfgFunctions
{
	class AN_S
	{
		
		// DEV: Disabled until paradigm is set up properly
		// #include "..\paradigm\an_server\functions.hpp"
		#include "functions\functions_s.h"
	};
};
