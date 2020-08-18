class respawn_short {
	respawnType = "RESPAWN";
	time = 10;
};

class respawn_medium {
	respawnType = "RESPAWN";
	time = 30;
};

class respawn_long {
	respawnType = "RESPAWN";
	time = 60;
};

class wreck_short {
	respawnType = "WRECK";
	time = 10;
};

class wreck_medium {
	respawnType = "WRECK";
	time = 30;
};

class wreck_long {
	respawnType = "WRECK";
	time = 60;
};

//Jeeps + Small Cars
class uns_willys : respawn_short {};
class uns_willys_2 : respawn_short {};
class uns_willysmg50 : respawn_short {};
class uns_willysm40 : respawn_short {};
class uns_willysmg : respawn_short {};
class uns_willys_2_usmp : respawn_short {};
class uns_willys_2_usmc : respawn_short {};
class uns_willys_2_m60 : respawn_short {};
class uns_willys_2_m1919 : respawn_short {};
class vn_b_wheeled_m151_01 : respawn_short {};
class vn_b_wheeled_m151_02 : respawn_short {};
class vn_b_wheeled_m151_mg_01 : respawn_medium {};
class vn_b_wheeled_m151_mg_02 : respawn_medium {};
class vn_b_wheeled_m151_mg_03 : respawn_medium {};
class vn_b_wheeled_m151_mg_04 : respawn_medium {};

//Trucks
class uns_m37b1 : respawn_medium {};
class uns_m37b1_m1919 : respawn_medium {};
class uns_M35A2 : respawn_medium {};
class uns_M35A2_Open : respawn_medium {};


//Transport trucks
class vn_b_wheeled_m54_01 : respawn_medium {};
class vn_b_wheeled_m54_01_airport : respawn_medium {};
class vn_b_wheeled_m54_02 : respawn_medium {};
//M109 Command Truck
class vn_b_wheeled_m54_03 : respawn_medium {};
//Repair Truck
class vn_b_wheeled_m54_repair : wreck_short {};
//Fuel trucks
class vn_b_wheeled_m54_fuel : wreck_short {};
class vn_b_wheeled_m54_fuel_airport : wreck_short {};
//Ammo truck
class vn_b_wheeled_m54_ammo : wreck_short {};
//Gun trucks
class vn_b_wheeled_m54_mg_01 : wreck_short {};
class vn_b_wheeled_m54_mg_02 : wreck_short {};
class vn_b_wheeled_m54_mg_03 : wreck_short {};

//Armoured Cars
class uns_xm706e1 : wreck_short {};
class uns_xm706e2 : wreck_short {};

//Wooden boats
class vn_c_boat_01_01 : respawn_short {};
class vn_c_boat_02_01 : respawn_short {};

//PBR Boat
class uns_pbr : respawn_long {};
class uns_pbr_m10 : respawn_long {};
class uns_pbr_mk18 : respawn_long {};
class vn_b_boat_05_01 : respawn_long {};

//Air assets
//Cobra Helicopter
class vn_air_ah1g_01 : wreck_long {};
class vn_air_ah1g_02 : wreck_long {};
class vn_air_ah1g_03 : wreck_long {};
class vn_air_ah1g_04 : wreck_long {};
class vn_air_ah1g_05 : wreck_long {};

//Choctaw
class vn_b_air_ch34_01_01 : respawn_medium {};
class vn_b_air_ch34_03_01 : respawn_medium {};
//Choctaw gunships
class vn_b_air_ch34_04_01 : wreck_medium {};
class vn_b_air_ch34_04_02 : wreck_medium {};
class vn_b_air_ch34_04_03 : wreck_medium {};
class vn_b_air_ch34_04_04 : wreck_medium {};

//Littlebird
class C_Heli_Light_01_civil_F : respawn_short {};
class vn_b_air_oh6a_01 : respawn_short {};
class vn_b_air_oh6a_02 : wreck_medium {};
class vn_b_air_oh6a_03 : wreck_medium {};
class vn_b_air_oh6a_04 : wreck_medium {};
class vn_b_air_oh6a_05 : wreck_medium {};
class vn_b_air_oh6a_06 : wreck_medium {};
class vn_b_air_oh6a_07 : wreck_medium {};


//Huey
class uns_UH1D_raaf_m60 : respawn_medium {};
class uns_UH1C_M21_M200 : wreck_medium {};
class vn_b_air_uh1c_02_01 : wreck_medium {};

//Chinook
class uns_ch47_m60_army : respawn_medium {};