//If you want to use Paradigm in a mission, follow the steps outlined in this config.

//You need to declare the path to paradigm at the top level of your config - literally the first thing in your mission config.
//#define PARA_PATH paradigm

//You then need to include this file
//#include "paradigm\missionConfig.hpp"

//First, we let all other configs know we're in a mission
#define PARA_MISSION

//We use this in the SQF to determine is Paradigm is loaded in-mission
//isClass (missionConfigFile >> "Paradigm")
class Paradigm {};

#include "client\config.hpp"
#include "server\config.hpp"

//You need to have your own RscTitles inherit ParadigmRscTitles
//class RscTitles : ParadigmRscTitles

//Include these functions in CfgFunctions
//#include "paradigm\client\functions.hpp"
//#include "paradigm\server\functions.hpp"