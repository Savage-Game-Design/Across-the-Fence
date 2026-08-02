/*	AUTHOR: Phronk
	DESCRIPTION: Proximity-based furniture spawning script. [Only runs on the server].

	TODO:
		1. Clean-up init and variables
*/
PF_Houses = [];
if ( !isServer ) exitWith {};
if ( !isNil"PFrun" ) exitWith {};
PFrun = true;
PF_WN = worldName;//Redundant?
PF_Houses = [
//Altis,Malden,Stratis
/*
"land_chapel_v1_f",
"land_chapel_v2_f",
"land_chapel_small_v1_f",
"land_chapel_small_v2_f",
"land_church_01_v1_f",
"land_church_01_v2_f",
"land_i_house_small_01_v1_f",
"land_i_house_small_01_v2_f",
"land_i_house_small_01_v3_f",
"land_i_house_small_01_b_blue_f",
"land_i_house_small_01_b_pink_f",
"land_i_house_small_01_b_white_f",
"land_i_house_small_01_b_whiteblue_f",
"land_i_house_small_01_b_brown_f",
"land_i_house_small_01_b_yellow_f",
"land_i_house_small_02_v1_f",
"land_i_house_small_02_v2_f",
"land_i_house_small_02_v3_f",
"land_i_house_small_03_v1_f",
*/
"land_slum_01_f",
"land_slum_house01_f",
"land_slum_house02_f",
"land_slum_house03_f",
/*
"land_i_stone_shed_v1_f",
"land_i_stone_shed_v2_f",
"land_i_stone_shed_v3_f",
"land_i_stone_housesmall_v1_f",
"land_i_stone_housesmall_v2_f",
"land_i_stone_housesmall_v3_f",
"land_i_shed_ind_f",
"land_i_shed_ind_03_f",
"land_shed_08_brown_f",
"land_shed_08_grey_f",
"land_i_stone_shed_01_b_clay_f",
"land_i_stone_shed_01_b_raw_f",
"land_i_stone_shed_01_b_white_f",
"land_i_stone_shed_01_c_clay_f",
"land_i_stone_shed_01_c_raw_f",
"land_i_stone_shed_01_c_white_f",
"land_barn_01_brown_f",
"land_barn_01_grey_f",
"land_i_addon_02_v1_f",
"land_i_addon_03_v1_f",
"land_carservice_f",
"land_fuelstation_01_shop_f",
"land_fuelstation_01_workshop_f",
"land_fuelstation_02_workshop_f",
"land_i_garage_v1_f",
"land_i_garage_v2_f",
"land_guardhouse_01_f",
"land_i_stone_housebig_v1_f",
"land_i_stone_housebig_v2_f",
"land_i_stone_housebig_v3_f",
"land_i_stone_house_big_01_b_clay_f",
"land_i_house_big_01_v1_f",
"land_i_house_big_01_v2_f",
"land_i_house_big_01_v3_f",
"land_i_house_big_01_b_blue_f",
"land_i_house_big_01_b_whiteblue_f",
"land_i_house_big_01_b_pink_f",
"land_i_house_big_01_b_pink_f",
"land_i_house_big_01_b_white_f",
"land_i_house_big_01_b_brown_f",
"land_i_house_big_02_v1_f",
"land_i_house_big_02_v2_f",
"land_i_house_big_02_v3_f",
"land_i_house_big_02_b_blue_f",
"land_i_house_big_02_b_pink_f",
"land_i_house_big_02_b_white_f",
"land_i_house_big_02_b_whiteblue_f",
"land_i_house_big_02_b_brown_f",
"land_i_house_big_02_b_yellow_f",
"land_i_shop_01_v1_f",
"land_i_shop_01_v2_f",
"land_i_shop_01_v3_f",
"land_i_shop_02_v1_f",
"land_i_shop_02_v2_f",
"land_i_shop_02_v3_f",
"land_i_shop_02_b_blue_f",
"land_i_shop_02_b_pink_f",
"land_i_shop_02_b_white_f",
"land_i_shop_02_b_whiteblue_f",
"land_i_shop_02_b_brown_f",
"land_i_shop_02_b_yellow_f",
"land_offices_01_v1_f",

//Livonia
"land_house_1w10_f",
"land_house_1w09_f",
"land_house_1w08_f",
"land_house_1w06_f",
"land_house_1w05_f",
"land_house_1w04_f",
"land_house_1w03_f",
"land_house_1w02_f",
"land_house_1w01_f",
"land_house_2w03_f",
"land_house_2w04_f",
"land_house_2b04_f",
*/
"land_shed_13_f",
"land_barn_02_f",
/*
"land_camp_house_01_brown_f",
"land_healthcenter_01_f",
"land_villagestore_01_f",
*/

//Tanoa
"land_vn_slum_house01_f",
"land_vn_slum_house02_f",
"land_vn_slum_house03_f",
"land_vn_house_big_01_f",
"land_vn_house_small_02_f",
"land_vn_house_small_03_f",
"land_vn_slum_01_f",
"land_vn_shed_02_f",
"land_vn_slum_03_f",
"land_vn_house_small_05_f",
"land_vn_house_small_06_f",
"land_vn_house_native_01_f",
"land_vn_house_native_02_f",

//Cam Lao Nam
"land_vn_market_stalls_01_ep1",
"land_vn_market_stalls_02_ep1",
//"land_vn_market_stalls_02_ep1",
//"land_vn_b_tower_01",
//"land_vn_b_trench_bunker_04_01",

"land_vn_campfire_f",
"land_vn_fireplace_f",

"land_vn_pen_village_01",
"land_vn_hut_08",
"land_vn_hut_07",
"land_vn_hut_06",
"land_vn_hut_05",
"land_vn_hut_04",
"land_vn_hut_02",
"land_vn_hut_01",
"land_vn_hut_village_01",
"land_vn_hut_village_02",
"land_vn_hut_mont_02",
"land_vn_hut_river_01"
];

PF_Mil=[
/*
"land_cargo_patrol_v1_f",
"land_cargo_patrol_v2_f",
"land_cargo_patrol_v3_f",
"land_cargo_patrol_v4_f"
*/
];



PFHomes = PF_Houses;//Intended for civ scripts, may be redundant now



//List of model names; used for findT.sqf to spawn civs on
PF_ObjectMdl = [
"vn_pen_village_01.p3d",
"vn_campfire_f.p3d",
"vn_fireplace_f.p3d",
"vn_clothesline_01_short_f.p3d",
"vn_rice_plant_sapling_02.p3d",
//"vn_rice_plant_sapling_03.p3d",
"vn_rice_plant_med_02.p3d",
//"vn_rice_plant_med_03.p3d",
//"vn_rice_plant_03.p3d",
"vn_dyke_10.p3d",
"vn_bench_f.p3d",
"vn_bench_05_f.p3d",
"vn_bench_ep1.p3d",
"vn_us_common_bench_01.p3d",
//"vn_picnictable_01_f.p3d",
"vn_boat_02_abandoned_f.p3d",
"vn_boat_01_abandoned_blue_f.p3d",
"vn_boat_01_abandoned_red_f.p3d"
];



//List of model names; used for civ1.fsm for civilians to dynamically interact with objects
PF_ObjectMdlCiv = [
"vn_campfire_f.p3d",
"vn_fireplace_f.p3d",
"vn_clothesline_01_short_f.p3d",
"vn_bench_f.p3d",
"vn_bench_05_f.p3d",
"vn_bench_ep1.p3d",
"vn_us_common_bench_01.p3d"
];

if ( isNil"isMaxW" ) then
{
	isMaxW = false;
};



// House baseClass
PF_HBC = [ "House_F" ];
PFCars = [];//Redundant?

//	Intended to help furniture & civ content being automatically dynamic using correct
//	classnames, but some variables from TWAT might not be important anymore.
switch ( true ) do
{
	case ( toLower worldName in ["desert","takistan","zargabad"] ) :
	{
		PF_HBC = [ "House_EP1" ];
		PF_Houses=["Land_House_L_3_EP1","Land_House_L_4_EP1","Land_House_L_6_EP1","Land_House_L_7_EP1","Land_House_L_8_EP1","Land_House_K_1_EP1","Land_House_K_3_EP1","Land_House_K_5_EP1","Land_House_K_6_EP1","Land_House_K_7_EP1","Land_House_K_8_EP1","Land_House_C_2_EP1","Land_House_C_4_EP1","Land_House_C_5_EP1","Land_House_C_5_V1_EP1","Land_House_C_5_V2_EP1","Land_House_C_5_V3_EP1","Land_House_C_10_EP1","Land_House_C_11_EP1"];
		PFHomes=["Land_House_L_3_EP1","Land_House_L_4_EP1","Land_House_L_6_EP1","Land_House_L_7_EP1","Land_House_L_8_EP1","Land_House_K_1_EP1","Land_House_K_3_EP1","Land_House_K_5_EP1","Land_House_K_6_EP1","Land_House_K_7_EP1","Land_House_K_8_EP1","Land_House_C_2_EP1","Land_House_C_4_EP1","Land_House_C_5_EP1","Land_House_C_5_V1_EP1","Land_House_C_5_V2_EP1","Land_House_C_5_V3_EP1","Land_House_C_10_EP1","Land_House_C_11_EP1"];//Redundant?
		PFJobs=["Land_House_C_1_EP1","Land_House_C_1_v2_EP1","Land_House_C_2_EP1","Land_House_C_2_EP1","Land_House_C_3_EP1","Land_House_C_4_EP1","Land_House_C_9_EP1","Land_Market_stalls_01_EP1","Land_Market_stalls_02_EP1","Land_Ind_Coltan_Main_EP1","Land_Ind_Garage01_EP1","Land_A_FuelStation_Build","Land_Ind_FuelStation_Build_EP1","Land_FuelStation_Build_PMC","Land_House_C_12_EP1","Land_A_Mosque_small_1_EP1","Land_A_Mosque_small_2_EP1","Land_A_Mosque_big_hq_EP1"];//Redundant?
		if(isCUPV)then{PFCars=["CUP_C_Datsun_Tubeframe","CUP_C_Datsun","CUP_C_Datsun_Plain","CUP_C_Datsun_Covered","CUP_C_Datsun_4seat","CUP_C_Skoda_White_CIV","CUP_C_Skoda_Blue_CIV","CUP_C_Skoda_Red_CIV","CUP_C_Skoda_Green_CIV","CUP_C_UAZ_Unarmed_TK_CIV","CUP_C_LR_Transport_CTK","CUP_C_Ural_Civ_01","CUP_C_Ural_Open_Civ_01"]};//Redundant? (Handled by separate traffic scripts)
	};

	case ( toLower worldName in ["cam_lao_nam","vn_khe_sanh","vn_the_bra"] ) :
	{
		PFCars = ["vn_c_bicycle_01","vn_c_bicycle_02"];
	};

	default
	{
		PFCars = ["C_Offroad_01_F","C_Offroad_01_repair_F","C_Quadbike_01_F","C_Hatchback_01_F","C_Hatchback_01_sport_F","C_SUV_01_F","C_Van_01_transport_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_02_transport_F","C_Van_02_service_F","C_Van_02_vehicle_F","I_C_Van_02_transport_F","I_C_Van_02_vehicle_F"];
	};
};



baseFaces = ["AfricanHead_01","AfricanHead_02","AfricanHead_03", "Barklem","Dwarden","GreekHead_A3_01","GreekHead_A3_08","GreekHead_A3_09","GreekHead_A3_12","Kerry","Kerry_C_F","LivonianHead_2","LivonianHead_3","LivonianHead_4","LivonianHead_5","LivonianHead_10","TanoanHead_A3_01","TanoanHead_A3_02","TanoanHead_A3_05","TanoanHead_A3_08","WhiteHead_04","WhiteHead_05","WhiteHead_06","WhiteHead_07","WhiteHead_08","WhiteHead_09","WhiteHead_11","WhiteHead_14","WhiteHead_15","WhiteHead_16","WhiteHead_23","WhiteHead_25","WhiteHead_27","WhiteHead_28","WhiteHead_32"];
PF_Ambient = [];
PF_MapObjs = [];
PF_B = [];
PF_wMid = [ worldSize/2 , worldSize/2 , 0 ];
{
	_x params [ [ "_fn" , "" ] , [ "_file" , "" ] ];
	private _code = compileFinal ( preprocessFile _file );
	missionNamespace setVariable [ _fn , _code ];
}forEach[
["PF_call","s\PF\f\call.sqf"],
["PF_callT","s\PF\f\callT.sqf"],
["PF_snd","s\PF\vn\snd.sqf"],
["PF_h1_1","s\PF\A3\h1_1.sqf"],
["PF_Lh1_1","s\PF\L\h1_1.sqf"],
["PF_Th1_1","s\PF\T\h1_1.sqf"],
["PF_Th2_1","s\PF\T\h2_1.sqf"],
["PF_Lh2_1","s\PF\L\h2_1.sqf"],
["PF_Lh2_2","s\PF\L\h2_2.sqf"],
["PF_h2a_1","s\PF\A3\h2a_1.sqf"],
["PF_h2b_1","s\PF\A3\h2b_1.sqf"],
["PF_h2c_1","s\PF\A3\h2c_1.sqf"],
["PF_h3_1","s\PF\A3\h3_1.sqf"],
["PF_Lh3_1","s\PF\L\h3_1.sqf"],
["PF_Th3_1","s\PF\T\h3_1.sqf"],
["PF_Th3s_1","s\PF\T\h3s_1.sqf"],
["PF_h4_1","s\PF\A3\h4_1.sqf"],
["PF_Lh4_1","s\PF\L\h4_1.sqf"],
["PF_h5_1","s\PF\A3\h5_1.sqf"],
["PF_Lh5_1","s\PF\L\h5_1.sqf"],
["PF_Th5_1","s\PF\T\h5_1.sqf"],
["PF_h6_1","s\PF\A3\h6_1.sqf"],
["PF_Lh6_1","s\PF\L\h6_1.sqf"],
["PF_Th6_1","s\PF\T\h6_1.sqf"],
["PF_Th7a_1","s\PF\T\h7_1a.sqf"],
["PF_Lh7_1","s\PF\L\h7_1.sqf"],
["PF_h7_1","s\PF\A3\h7_1.sqf"],
["PF_Lh8_1","s\PF\L\h8_1.sqf"],
["PF_h8a_1","s\PF\A3\h8a_1.sqf"],
["PF_h8b_1","s\PF\A3\h8b_1.sqf"],
["PF_h8c_1","s\PF\A3\h8c_1.sqf"],
["PF_h9_1","s\PF\A3\h9_1.sqf"],
["PF_Lh9_1","s\PF\L\h9_1.sqf"],
["PF_h10_1","s\PF\A3\h10_1.sqf"],
["PF_Lh10_1","s\PF\L\h10_1.sqf"],
["PF_Th10_1","s\PF\T\h10_1.sqf"],
["PF_h11_1","s\PF\A3\h11_1.sqf"],
["PF_Lh11_1","s\PF\L\h11_1.sqf"],
["PF_Th11_1","s\PF\T\h11_1.sqf"],
["PF_h12_1","s\PF\A3\h12_1.sqf"],
["PF_Lh12_1","s\PF\L\h12_1.sqf"],
["PF_h13_1","s\PF\A3\h13_1.sqf"],
["PF_Lh13_1","s\PF\L\h13_1.sqf"],
["PF_h14_1","s\PF\A3\h14_1.sqf"],
["PF_Lh14_1","s\PF\L\h14_1.sqf"],
["PF_h15_1","s\PF\A3\h15_1.sqf"],
["PF_Lh15_1","s\PF\L\h15_1.sqf"],
["PF_h16_1","s\PF\A3\h16_1.sqf"],
["PF_h17_1","s\PF\A3\h17_1.sqf"],
["PF_h18_1","s\PF\A3\h18_1.sqf"],
["PF_h19_1","s\PF\A3\h19_1.sqf"],
["PF_h20_1","s\PF\A3\h20_1.sqf"],
["PF_h1_2","s\PF\A3\h1_2.sqf"],
["PF_Lh1_2","s\PF\L\h1_2.sqf"],
["PF_m1a_2","s\PF\A3\m1a_2.sqf"],
["PF_m1b_2","s\PF\A3\m1b_2.sqf"],
["PF_h2a_2","s\PF\A3\h2a_2.sqf"],
["PF_h2b_2","s\PF\A3\h2b_2.sqf"],
["PF_h3_2","s\PF\A3\h3_2.sqf"],
["PF_h4_2","s\PF\A3\h4_2.sqf"],
["PF_h5_2","s\PF\A3\h5_2.sqf"],
["PF_h1_4","s\PF\A3\h1_4.sqf"],
["PF_c1_1","s\PF\A3\c1_1.sqf"],
["PF_vn_h1_1a","s\PF\vn\h1_1a.sqf"],
["PF_vn_h1_1b","s\PF\vn\h1_1b.sqf"],
["PF_vn_h1_1c","s\PF\vn\h1_1c.sqf"],
["PF_vn_h1_1d","s\PF\vn\h1_1d.sqf"],
["PF_vn_h2_1a","s\PF\vn\h2_1a.sqf"],
["PF_vn_h2_1b","s\PF\vn\h2_1b.sqf"],
["PF_vn_h2_1c","s\PF\vn\h2_1c.sqf"],
["PF_vn_h4_1","s\PF\vn\h4_1.sqf"],
["PF_vn_h5_1","s\PF\vn\h5_1.sqf"],
["PF_vn_h6_1","s\PF\vn\h6_1.sqf"],
["PF_vn_h7_1a","s\PF\vn\h7_1a.sqf"],
["PF_vn_h7_1b","s\PF\vn\h7_1b.sqf"],
["PF_vn_h8_1","s\PF\vn\h8_1.sqf"],
["PF_vn_h9_1","s\PF\vn\h9_1.sqf"],
["PF_vn_h10_1","s\PF\vn\h10_1.sqf"],
["PF_vn_h11_1","s\PF\vn\h11_1.sqf"],
["PF_vn_h12_1","s\PF\vn\h12_1.sqf"],
["PF_vn_h13_1","s\PF\vn\h13_1.sqf"],
["PF_vn_h14_1","s\PF\vn\h14_1.sqf"],
["PF_vn_e1","s\PF\vn\e1.sqf"],
["PF_vn_e2","s\PF\vn\e2.sqf"],
["PF_vn_e3","s\PF\vn\e3.sqf"],
["PF_vn_e4","s\PF\vn\e4.sqf"],
["PF_vn_e5","s\PF\vn\e5.sqf"],
["PF_vn_e6","s\PF\vn\e6.sqf"],
["PF_vn_e7","s\PF\vn\e7.sqf"],
["PF_vn_e9","s\PF\vn\e9.sqf"],
//["PF_vn_m1_2","s\PF\vn\m1_2.sqf"],
//["PF_vn_m2_2","s\PF\vn\m2_2.sqf"],
["PF_CFG","s\PF\CFG.sqf"]];
[] call PF_CFG;



//Delete all furniture and nil the variable upon building destruction (Possibly broken, need to partially rewrite)
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



//Blacklist Areas Code
waitUntil { !isNil "PF_BLObj" };
if ( count PF_BLObj > 0 ) then
{
	PFHomes = PFHomes - [ PF_BLObj ]
};

sleep 1;

if(PF_On)then
{
[]spawn compileFinal(loadFile"s\PF\f\find.sqf");[]spawn compileFinal(loadFile"s\PF\f\clean.sqf");
[]spawn compileFinal(loadFile"s\PF\f\findT.sqf");[]spawn compileFinal(loadFile"s\PF\f\cleanT.sqf");
[]execFSM"s\PF\vn\animal.fsm";
};