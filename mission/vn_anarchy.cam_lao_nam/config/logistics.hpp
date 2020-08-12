class vn_logistics
{
    class vehicle_data
    {
	class vn_defaults_large
	{
		inventory_max_weight = 600;
		inventory_max_size = 7.5;
	};
	class vn_defaults_medium
	{
		inventory_max_weight = 300;
		inventory_max_size = 5;
	};
	class vn_defaults_small
	{
		inventory_max_weight = 100;
		inventory_max_size = 2.5;
	};
	class vn_defaults_tiny
	{
		inventory_max_weight = 50;
		inventory_max_size = 1;
	};
	//Jeeps + Small Cars
	class vn_b_wheeled_m151_01 : vn_defaults_small {};
	class vn_b_wheeled_m151_01_mp : vn_defaults_small {};
	class vn_b_wheeled_m151_02_mp : vn_defaults_small {};
	class vn_b_wheeled_m151_02 : vn_defaults_small {};

	//Armed Jeeps
	class vn_b_wheeled_m151_mg_04_mp : vn_defaults_tiny {};
	class vn_b_wheeled_m151_mg_04 : vn_defaults_tiny {};
	class vn_b_wheeled_m151_mg_02_mp : vn_defaults_tiny {};
	class vn_b_wheeled_m151_mg_02 : vn_defaults_tiny {};
	class vn_b_wheeled_m151_mg_03_mp : vn_defaults_tiny {};
	class vn_b_wheeled_m151_mg_03 : vn_defaults_tiny {};

	//Transport trucks
	class vn_b_wheeled_m54_01 : vn_defaults_large {};
	class vn_b_wheeled_m54_01_airport : vn_defaults_large {};
	class vn_b_wheeled_m54_02 : vn_defaults_large {};
	//M109 Command Truck
	class vn_b_wheeled_m54_03 : vn_defaults_medium {};
	//Repair Truck
	class vn_b_wheeled_m54_repair : vn_defaults_medium {};
	//Fuel trucks
	class vn_b_wheeled_m54_fuel : vn_defaults_medium {};
	class vn_b_wheeled_m54_fuel_airport : vn_defaults_medium {};
	//Ammo truck
	class vn_b_wheeled_m54_ammo : vn_defaults_medium {};
	//Gun trucks
	class vn_b_wheeled_m54_mg_01 : vn_defaults_small {};
	class vn_b_wheeled_m54_mg_02 : vn_defaults_small {};
	class vn_b_wheeled_m54_mg_03 : vn_defaults_small {};

	//Small VC boats
	class vn_o_boat_01_00 : vn_defaults_small {};
	class vn_o_boat_01_01 : vn_defaults_small {};
	class vn_o_boat_01_02 : vn_defaults_small {};
	class vn_o_boat_01_03 : vn_defaults_small {};
	class vn_o_boat_01_04 : vn_defaults_small {};

	class vn_o_boat_01_mg_00 : vn_defaults_tiny {};
	class vn_o_boat_01_mg_01 : vn_defaults_tiny {};
	class vn_o_boat_01_mg_02 : vn_defaults_tiny {};
	class vn_o_boat_01_mg_03 : vn_defaults_tiny {};
	class vn_o_boat_01_mg_04 : vn_defaults_tiny {};

	//Long VC Boats
	class vn_o_boat_02_00 : vn_defaults_medium {};
	class vn_o_boat_02_01 : vn_defaults_medium {};
	class vn_o_boat_02_02 : vn_defaults_medium {};
	class vn_o_boat_02_03 : vn_defaults_medium {};
	class vn_o_boat_02_04 : vn_defaults_medium {};

	class vn_o_boat_02_mg_00 : vn_defaults_small {};
	class vn_o_boat_02_mg_01 : vn_defaults_small {};
	class vn_o_boat_02_mg_02 : vn_defaults_small {};
	class vn_o_boat_02_mg_03 : vn_defaults_small {};
	class vn_o_boat_02_mg_04 : vn_defaults_small {};

	//PBR Boat
	class vn_b_boat_05_01 : vn_defaults_medium {};
	class vn_b_boat_05_02 : vn_defaults_medium {};

	//Air assets
	//Cobra Helicopter
	class vn_air_ah1g_01 : vn_defaults_tiny {};
	class vn_air_ah1g_02 : vn_defaults_tiny {};
	class vn_air_ah1g_03 : vn_defaults_tiny {};
	class vn_air_ah1g_04 : vn_defaults_tiny {};
	class vn_air_ah1g_05 : vn_defaults_tiny {};
	
	//Huey
	class vn_b_air_uh1d_02_01 : vn_defaults_tiny {};
	class vn_b_air_uh1c_03_01 : vn_defaults_tiny {};
	class vn_b_air_uh1c_04_01 : vn_defaults_tiny {};

	//Choctaw
	class vn_b_air_ch34_01_01 : vn_defaults_tiny {};
	class vn_b_air_ch34_03_01 : vn_defaults_tiny {};
	class vn_b_air_ch34_04_01 : vn_defaults_tiny {};
	class vn_b_air_ch34_04_02 : vn_defaults_tiny {};
	class vn_b_air_ch34_04_03 : vn_defaults_tiny {};
	class vn_b_air_ch34_04_04 : vn_defaults_tiny {};

	//OH6
	class vn_b_air_oh6a_01 : vn_defaults_tiny {};
	class vn_b_air_oh6a_02 : vn_defaults_tiny {};
	class vn_b_air_oh6a_03 : vn_defaults_tiny {};
	class vn_b_air_oh6a_04 : vn_defaults_tiny {};
	class vn_b_air_oh6a_05 : vn_defaults_tiny {};
	class vn_b_air_oh6a_06 : vn_defaults_tiny {};
	class vn_b_air_oh6a_07 : vn_defaults_tiny {};


	//////////////////
	////  UNSUNG  ////
	//////////////////
	class uns_willys : vn_defaults_small {};
	class uns_willys_2 : vn_defaults_small {};
	class uns_willysmg50 : vn_defaults_tiny {};
	class uns_willysm40 : vn_defaults_tiny {};
	class uns_willysmg : vn_defaults_tiny {};
	class uns_willys_2_usmp : vn_defaults_small {};
	class uns_willys_2_usmc : vn_defaults_small {};
	class uns_willys_2_m60 : vn_defaults_small {};
	class uns_willys_2_m1919 : vn_defaults_tiny {};

	//Armoured Cars
	class uns_xm706e1 : vn_defaults_small {};
	class uns_xm706e2 : vn_defaults_small {};

	//Huey
	class uns_UH1D_raaf_m60 : vn_defaults_tiny {};
	class uns_UH1C_M21_M200 : vn_defaults_tiny {};

	//Chinook
	class uns_ch47_m60_army : vn_defaults_medium {};

	//Boats
	class uns_pbr : vn_defaults_medium {};
	class uns_pbr_m10 : vn_defaults_small {};
	class uns_pbr_mk18 : vn_defaults_small {};

	//Trucks
	class uns_m37b1 : vn_defaults_medium {};
	class uns_m37b1_m1919 : vn_defaults_small {};
	class uns_M35A2 : vn_defaults_large {};
	class uns_M35A2_Open : vn_defaults_large {};
    };
    class item_data
    {
		//Building supplies
        class vn_b_ammobox_supply_05
        {
            item_weight = 200;
            item_size = 2.5;
            spawn_distance = 5;
            rotation_offset = 0;
        };

		//Workshop supplies
		class vn_b_ammobox_supply_06 : vn_b_ammobox_supply_05 {};

		//Sandbag supplies
		class vn_b_ammobox_supply_10 : vn_b_ammobox_supply_05 {};

		//Small US ammo
		class vn_b_ammobox_supply_04 
		{
			item_weight = 50;
			item_size = 1;
			spawn_distance = 2;
			rotation_offset = 0;
		};

		//SOG ammo
		class vn_b_ammobox_sog // ammo
        {
            item_weight = 100;
            item_size = 2.5;
            spawn_distance = 3;
            rotation_offset = 0;
        };
		//US Ammo
		class vn_b_ammobox_supply_01 : vn_b_ammobox_sog {};
		//Medical supplies
		class vn_b_ammobox_supply_03 : vn_b_ammobox_sog {};
		//Food supplies
		class vn_b_ammobox_supply_02 : vn_b_ammobox_supply_03 {};

		//Resupply Fuel/Repair/Ammo
		class vn_b_ammobox_supply_07 : vn_b_ammobox_supply_05
		{
				item_weight = 400;
				item_size = 10;
		};
		class vn_b_ammobox_supply_08 : vn_b_ammobox_supply_07 {};

		class vn_b_ammobox_supply_09 : vn_b_ammobox_supply_07 {};

		/* Huron cargo container used to package wrecked vehicles */
		class B_Slingload_01_Cargo_F
		{
			item_weight = 600;
			item_size = 7.5;
			spawn_distance = 8;
			rotiation_offset = 0;
		};


		///////////////////
		////  STATICS  ////
		///////////////////
		class vn_static_small {
			item_weight = 50;
			item_size = 1;
			spawn_distance = 2;
			rotation_offset = 0;
		};

		class vn_static_large {
			item_weight = 600;
			item_size = 7.5;
			spawn_distance = 4;
			rotation_offset = 0;
		};

		class vn_b_army_static_mortar_m2 : vn_static_small {};
		class vn_b_army_static_mortar_m29 : vn_static_small {};
		class vn_b_sf_static_mortar_m2 : vn_static_small {};
		class vn_b_sf_static_mortar_m29 : vn_static_small {};
		class vn_b_army_static_m1919a6 : vn_static_small {};
		class vn_b_sf_static_m1919a6 : vn_static_small {};
		class vn_b_army_static_m1919a4_low : vn_static_small {};
		class vn_b_army_static_m1919a4_high : vn_static_small {};
		class vn_b_sf_static_m1919a4_low : vn_static_small {};
		class vn_b_sf_static_m1919a4_high : vn_static_small {};
		class vn_b_army_static_m2_low : vn_static_small {};
		class vn_b_sf_static_m2_low : vn_static_small {};
		class vn_b_army_static_m2_high : vn_static_small {};
		class vn_b_sf_static_m2_high : vn_static_small {};
		class vn_b_army_static_m60_low : vn_static_small {};
		class vn_b_sf_static_m60_low : vn_static_small {};
		class vn_b_army_static_m60_high : vn_static_small {};
		class vn_b_sf_static_m60_high : vn_static_small {};
		class vn_b_army_static_m45 : vn_static_large {};
		class vn_b_sf_static_m45 : vn_static_large {};
		class vn_b_army_static_m101 : vn_static_large {};
		class vn_b_sf_static_m101 : vn_static_large {};

		class vn_i_static_mortar_m2: 	vn_b_army_static_mortar_m2 {};
		class vn_i_static_mortar_m29: 	vn_b_army_static_mortar_m29 {};
		class vn_i_static_m1919a6: 	vn_b_army_static_m1919a6 {};
		class vn_i_static_m1919a4_low: 	vn_b_army_static_m1919a4_low {};
		class vn_i_static_m1919a4_high:	vn_b_army_static_m1919a4_high {};
		class vn_i_static_m2_low: 	vn_b_army_static_m2_low {};
		class vn_i_static_m2_high: 	vn_b_army_static_m2_high {};
		class vn_i_static_m60_low: 	vn_b_army_static_m60_low {};
		class vn_i_static_m60_high: 	vn_b_army_static_m60_high {};
		class vn_i_army_static_m45: 	vn_b_army_static_m45 {};

		class vn_o_nva_static_rpd_high: 	vn_b_army_static_m60_high {};
		class vn_o_nva_static_dshkm_high_01:	vn_b_army_static_m2_high {};
		class vn_o_nva_static_dshkm_high_02: 	vn_b_army_static_m2_high {};
		class vn_o_nva_static_dshkm_low_01:	vn_b_army_static_m2_low {};
		class vn_o_nva_static_dshkm_low_02:	vn_b_army_static_m2_low {};
		class vn_o_nva_static_mortar_type53: 	vn_b_army_static_mortar_m29 {};
		class vn_o_nva_static_mortar_type63: 	vn_b_army_static_mortar_m2 {};

		class vn_o_nva_navy_static_rpd_high: 		vn_b_army_static_m60_high {};
		class vn_o_nva_navy_static_dshkm_high_01:	vn_b_army_static_m2_high {};
		class vn_o_nva_navy_static_dshkm_high_02: 	vn_b_army_static_m2_high {};
		class vn_o_nva_navy_static_dshkm_low_01:	vn_b_army_static_m2_low {};
		class vn_o_nva_navy_static_dshkm_low_02:	vn_b_army_static_m2_low {};
		class vn_o_nva_navy_static_mortar_type53: 	vn_b_army_static_mortar_m29 {};
		class vn_o_nva_navy_static_mortar_type63: 	vn_b_army_static_mortar_m2 {};

		class vn_o_vc_static_rpd_high: 		vn_b_army_static_m60_high {};
		class vn_o_vc_static_dp28_high: 	vn_b_army_static_m60_high {};
		class vn_o_vc_static_dshkm_high_01:	vn_b_army_static_m2_high {};
		class vn_o_vc_static_dshkm_high_02: 	vn_b_army_static_m2_high {};
		class vn_o_vc_static_dshkm_low_01:	vn_b_army_static_m2_low {};
		class vn_o_vc_static_dshkm_low_02:	vn_b_army_static_m2_low {};
		class vn_o_vc_static_mortar_type53: 	vn_b_army_static_mortar_m29 {};
		class vn_o_vc_static_mortar_type63: 	vn_b_army_static_mortar_m2 {};
    };
};
