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

#define PARA_PATH \paradigm

class CfgFunctions
{
	#include "..\paradigm\client\functions.hpp"


};