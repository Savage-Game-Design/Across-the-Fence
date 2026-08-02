PT_cList=["C_Offroad_01_F","C_Offroad_01_repair_F","C_Quadbike_01_F","C_Hatchback_01_F","C_Hatchback_01_sport_F","C_SUV_01_F","C_Van_01_transport_F","C_Van_01_box_F","C_Van_01_fuel_F","C_Van_02_transport_F","C_Van_02_service_F","C_Van_02_vehicle_F","I_C_Van_02_transport_F","I_C_Van_02_vehicle_F"];
PT_CUP=FALSE;
PT_RHS=FALSE;

0 call compileFinal(preprocessFileLineNumbers"s\civ\traffic\CFG.sqf");
0 call compileFinal(preprocessFileLineNumbers"s\civ\traffic\f.sqf");
0 call compileFinal(preprocessFileLineNumbers"s\civ\traffic\traffic.sqf");

if(!PT_Mods)exitWith{};
if((isClass(configFile>>"cfgPatches">>"CUP_Vehicles_Core"))&&{(isClass(configFile>>"cfgPatches">>"CUP_BaseConfigs"))})then{PT_CUP=TRUE};
if(isClass(configFile>>"cfgPatches">>"rhs_t72"))then{PT_RHS=TRUE};
if(PT_CUP)then{PT_cList=["CUP_C_TT650_TK_CIV","CUP_C_Bus_City_TKCIV","CUP_C_Datsun_Tubeframe","CUP_C_Datsun","CUP_C_Datsun_Plain","CUP_C_Datsun_Covered","CUP_C_Datsun_4seat","CUP_C_Skoda_White_CIV","CUP_C_Skoda_Blue_CIV","CUP_C_Skoda_Red_CIV","CUP_C_Skoda_Green_CIV","CUP_C_Golf4_black_Civ","CUP_C_Golf4_white_Civ","CUP_C_UAZ_Unarmed_TK_CIV","CUP_C_LR_Transport_CTK","CUP_C_Ural_Civ_01","CUP_C_Ural_Open_Civ_01","CUP_C_Ikarus_TKC","CUP_C_Volha_Gray_TKCIV","CUP_C_Volha_Blue_TKCIV","CUP_C_Lada_TK_CIV","CUP_C_S1203_CIV","CUP_C_S1203_Ambulance_CIV"]};
if(PT_RHS)then{PT_cList=PT_cList+["RHS_Ural_Open_Civ_01","RHS_Ural_Civ_01","RHS_Ural_Open_Civ_02","RHS_Ural_Civ_02","RHS_Ural_Open_Civ_03","RHS_Ural_Civ_03","C_Offroad_02_unarmed_F","C_Hatchback_01_F","C_SUV_01_F"]};