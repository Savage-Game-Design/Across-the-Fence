/*	AUTHOR: Phronk
	DESCRIPTION: Proximity-based furniture spawning script. [Only runs on the client].

*/
PFL_Houses = [];
//if ( isDedicated ) exitWith {}; // Commenting this out so we can have global moving AI spawned by server
if ( !isNil "PFLrun" )exitWith{};
//if ( PFrun ) exitWith {};
PFLrun = true;
PF_WN = worldName;
PFL_Houses = [
//Altis,Malden,Stratis
//""

//Livonia
//""

//Tanoa
//""

//Cam Lao Nam
"land_vn_guardhouse_01",
"land_vn_hooch_02_02",
"land_vn_barracks_03_03",
"land_vn_hootch_01_11",
"land_vn_latrine_01",
"land_vn_shower_01",
"land_vn_b_tower_01",
"land_vn_b_trench_bunker_04_01",
"land_vn_b_trench_bunker_05_02",
"land_vn_b_trench_bunker_06_02",
"land_vn_b_trench_90_01",//Spawned by Host
"land_vn_b_trench_20_01",//Spawned by Host
"land_vn_b_foxhole_01",
"land_vn_b_trench_firing_01",
"land_vn_b_trench_firing_04",
"land_vn_b_trench_firing_05",
"land_vn_airport_01_terminal_f",

//Auto-populate
"land_vn_hootch_01_01",
"land_vn_hootch_01_02",
"land_vn_hootch_01_11",
"land_vn_hootch_01_12",
"land_vn_hootch_02_01",
"land_vn_hootch_02_11",
"land_vn_hootch_02_02",
//"land_vn_hootch_01_03",
"land_vn_hootch_01_13",
//"land_vn_hootch_02_03",

"land_vn_barracks_04_02",
"land_vn_barracks_04_01",
"land_vn_barracks_02_01",
"land_vn_barracks_03_04",
"land_vn_barracks_03_01",
"land_vn_barracks_03_02",
"land_vn_mil_barracks_i_ep1",
"land_vn_i_barracks_v2_f",
"land_vn_quonset_02_01",
"land_vn_slum_03_01_f"
];

PF_Mil=[
/*
"land_cargo_patrol_v1_f",
"land_cargo_patrol_v2_f",
"land_cargo_patrol_v3_f",
"land_cargo_patrol_v4_f"
*/
];



PFLHomes = PFL_Houses;//Intended for civ scripts, may be redundant now



PFL_ObjectMdl = [
"vn_pen_village_01.p3d",
"vn_campfire_f.p3d",
"vn_fireplace_f.p3d",
"vn_clothesline_01_short_f.p3d",
"vn_rice_plant_sapling_02.p3d",
//"vn_rice_plant_sapling_03.p3d",
"vn_rice_plant_med_02.p3d",
//"vn_rice_plant_med_03.p3d",
//"vn_rice_plant_03.p3d",
"vn_dyke_10.p3d"
];



if ( isNil"isMaxW" ) then
{
	isMaxW = false;
};



// House baseClass
PF_HBC = [ "House_F" ];
PFCars = [];



//	Intended to help furniture & civ content being automatically dynamic using correct
//	classnames, but some variables from TWAT might not be important anymore.
switch ( true ) do
{
	case ( toLower worldName in ["desert","takistan","zargabad"] ) :
	{
		PF_HBC = [ "House_EP1" ];
		PFL_Houses=["Land_House_L_3_EP1","Land_House_L_4_EP1","Land_House_L_6_EP1","Land_House_L_7_EP1","Land_House_L_8_EP1","Land_House_K_1_EP1","Land_House_K_3_EP1","Land_House_K_5_EP1","Land_House_K_6_EP1","Land_House_K_7_EP1","Land_House_K_8_EP1","Land_House_C_2_EP1","Land_House_C_4_EP1","Land_House_C_5_EP1","Land_House_C_5_V1_EP1","Land_House_C_5_V2_EP1","Land_House_C_5_V3_EP1","Land_House_C_10_EP1","Land_House_C_11_EP1"];
		PFLHomes=["Land_House_L_3_EP1","Land_House_L_4_EP1","Land_House_L_6_EP1","Land_House_L_7_EP1","Land_House_L_8_EP1","Land_House_K_1_EP1","Land_House_K_3_EP1","Land_House_K_5_EP1","Land_House_K_6_EP1","Land_House_K_7_EP1","Land_House_K_8_EP1","Land_House_C_2_EP1","Land_House_C_4_EP1","Land_House_C_5_EP1","Land_House_C_5_V1_EP1","Land_House_C_5_V2_EP1","Land_House_C_5_V3_EP1","Land_House_C_10_EP1","Land_House_C_11_EP1"];
		PFJobs=["Land_House_C_1_EP1","Land_House_C_1_v2_EP1","Land_House_C_2_EP1","Land_House_C_2_EP1","Land_House_C_3_EP1","Land_House_C_4_EP1","Land_House_C_9_EP1","Land_Market_stalls_01_EP1","Land_Market_stalls_02_EP1","Land_Ind_Coltan_Main_EP1","Land_Ind_Garage01_EP1","Land_A_FuelStation_Build","Land_Ind_FuelStation_Build_EP1","Land_FuelStation_Build_PMC","Land_House_C_12_EP1","Land_A_Mosque_small_1_EP1","Land_A_Mosque_small_2_EP1","Land_A_Mosque_big_hq_EP1"];
		if(isCUPV)then{PFCars=["CUP_C_Datsun_Tubeframe","CUP_C_Datsun","CUP_C_Datsun_Plain","CUP_C_Datsun_Covered","CUP_C_Datsun_4seat","CUP_C_Skoda_White_CIV","CUP_C_Skoda_Blue_CIV","CUP_C_Skoda_Red_CIV","CUP_C_Skoda_Green_CIV","CUP_C_UAZ_Unarmed_TK_CIV","CUP_C_LR_Transport_CTK","CUP_C_Ural_Civ_01","CUP_C_Ural_Open_Civ_01"]};
	};

	case ( toLower worldName in ["cam_lao_nam","vn_khe_sanh","vn_the_bra"] ) :
	{
		PFCars = ["vn_c_bicycle_01","vn_c_bicycle_02"];
		/*
		PF_basePlanks = (nearestTerrainObjects[player,[],500,false,true])select{"plank_01_" in str _x};
		private _planks = [];
		{
			_planks pushBack [STR _x,getpos _x];
		}forEach PF_basePlanks;
		_planks sort true;
		PF_basePlanks = _planks;
		*/
	};

	default
	{
		PFCars = ["C_Offroad_01_F","C_Offroad_01_repair_F","C_Quadbike_01_F","C_Hatchback_01_F","C_Hatchback_01_sport_F","C_SUV_01_F","C_Van_01_transport_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_02_transport_F","C_Van_02_service_F","C_Van_02_vehicle_F","I_C_Van_02_transport_F","I_C_Van_02_vehicle_F"];
	};
};



baseFaces = ["AfricanHead_01","AfricanHead_02","AfricanHead_03", "Barklem","Dwarden","GreekHead_A3_01","GreekHead_A3_08","GreekHead_A3_09","GreekHead_A3_12","Kerry","Kerry_C_F","LivonianHead_2","LivonianHead_3","LivonianHead_4","LivonianHead_5","LivonianHead_10","TanoanHead_A3_01","TanoanHead_A3_02","TanoanHead_A3_05","TanoanHead_A3_08","WhiteHead_04","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08","WhiteHead_09","WhiteHead_11","WhiteHead_14","WhiteHead_15","WhiteHead_16","WhiteHead_23","WhiteHead_25","WhiteHead_27","WhiteHead_28","WhiteHead_32"];
//PF_Ambient = [];
//PF_MapObjs = [];
PF_LB = [];
PF_wMid = [ worldSize/2 , worldSize/2 , 0 ];
{
	_x params [ [ "_fn" , "" ] , [ "_file" , "" ] ];
	private _code = compileFinal ( preprocessFile _file );
	missionNamespace setVariable [ _fn , _code ];
}forEach[
["PF_callL","c\PF\f\call.sqf"],
["PF_callTL","c\PF\f\callT.sqf"],
["PF_sndL","c\PF\vn\snd.sqf"],
["PFL_vn_Dress","c\PF\vn\dress.sqf"],
["PFL_vn_oFind","c\PF\vn\ofind.sqf"],
["PF_vn_m1_1","c\PF\vn\m1_1.sqf"],
["PF_vn_m2_1","c\PF\vn\m2_1.sqf"],
["PF_vn_m3_1","c\PF\vn\m3_1.sqf"],
//["PF_vn_m4_1","c\PF\vn\m4_1.sqf"],
["PF_vn_m5_1","c\PF\vn\m5_1.sqf"],
["PF_vn_m6_1","c\PF\vn\m6_1.sqf"],
["PF_vn_m7_1","c\PF\vn\m7_1.sqf"],
["PF_vn_m8_1","c\PF\vn\m8_1.sqf"],
["PF_vn_m9_1","c\PF\vn\m9_1.sqf"],
["PF_vn_m10_1","c\PF\vn\m10_1.sqf"],
["PF_vn_m11_1","c\PF\vn\m11_1.sqf"],
["PF_vn_m12_1","c\PF\vn\m12_1.sqf"],
["PF_vn_m13_1","c\PF\vn\m13_1.sqf"],
["PF_vn_m14_1","c\PF\vn\m14_1.sqf"],
["PF_vn_m1_2","c\PF\vn\m1_2.sqf"],
["PF_vn_m2_2","c\PF\vn\m2_2.sqf"],
["PFL_CFG","c\PF\CFG.sqf"]];
[] call PFL_CFG;



//Delete all furniture and nil the variable upon building destruction (Possibly broken, need to partially rewrite)
/*
addMissionEventHandler [ "buildingChanged" ,
{
	params [ "_b" , "_b2" , "_r" ];
	if ( !isNil{ _b getVariable "PF" } ) then
	{
		{ deleteVehicle _x }forEach ( _b getVariable"PF" );
		_b setVariable [ "PF" , nil ];
		_b setVariable [ "PF_B" , nil ];
	};
}];
*/



//Blacklist Areas Code
waitUntil { !isNil "PFL_BLObj" };
if ( count PFL_BLObj > 0 ) then
{
	PFLHomes = PFLHomes - [ PFL_BLObj ]
};
sleep 1;
if(PFL_On)then
{
	if ( isServer ) then // Server Only
	{
		//[]spawn compileFinal(loadFile"c\PF\f\findB.sqf");//[]spawn compileFinal(loadFile"c\PF\f\cleanB.sqf");
	};
	
	[]spawn compileFinal(loadFile"c\PF\f\find.sqf");[]spawn compileFinal(loadFile"c\PF\f\clean.sqf");// Client Only
//[]spawn compileFinal(loadFile"c\PF\f\findT.sqf");[]spawn compileFinal(loadFile"c\PF\f\cleanT.sqf");
//[]execFSM"c\PF\vn\animal.fsm";
};