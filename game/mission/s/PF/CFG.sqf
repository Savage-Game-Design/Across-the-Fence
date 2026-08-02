/*	VERSION: 0.8
	AUTHOR: Phronk
*/

PF_On = TRUE;			//TRUE enables furniture, FALSE disables it (Default = TRUE)
PF_SL = 88;				//Max speed limit: players moving faster than this number can't spawn stuff
PF_Range = 60;		//Activation range on buildings to spawn furniture (Default = 60)
PFT_Range = 150;	//Activation range on map objects to spawn agents
PFC_Range = 500;	//Activation range on buildings to spawn wandering agents
PF_BLObj = [];			//List of building CLASSNAMES to avoid spawning furniture in (Example: ["land_slum_01_f"])
PF_BL = [];		//List of markers to not spawn furniture in (Example: ["BL_Mkr1","BL_Mkr2"])