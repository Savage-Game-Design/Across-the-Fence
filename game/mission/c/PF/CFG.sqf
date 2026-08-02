/*	VERSION: 0.8
	AUTHOR: Phronk
*/

PFL_On = TRUE;			//TRUE enables furniture, FALSE disables it (Default = TRUE)
PFL_SL = 88;				//Max speed limit: players moving faster than this number can't spawn stuff
PFL_Range = 60;		//Activation range on buildings to spawn furniture (Default = 60)
PFT_Range = 150;	//Activation range on map objects to spawn agents
PFC_Range = 500;	//Activation range on buildings to spawn wandering agents
PFL_BLObj = [];			//List of building CLASSNAMES to avoid spawning furniture in (Example: ["land_slum_01_f"])
PFL_BLMkr = []; //List of markers to not spawn furniture in (Example: ["BL_Mkr1","BL_Mkr2"])