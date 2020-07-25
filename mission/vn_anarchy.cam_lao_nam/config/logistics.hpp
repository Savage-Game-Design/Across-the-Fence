class vn_logistics
{
    class vehicle_data
    {
	class vn_defaults_large
	{
	        inventory_max_weight = 180;
	        inventory_max_size = 30;
	};
	class vn_defaults_small
	{
	        inventory_max_weight = 90;
	        inventory_max_size = 15;
	};
	class uns_willys : vn_defaults_small {};
	class uns_willys_2 : vn_defaults_small {};
	class uns_willysmg50 : vn_defaults_small {};
	class uns_willysm40 : vn_defaults_small {};
	class uns_willys_2_usmp : vn_defaults_small {};
	class uns_willys_2_usmc : vn_defaults_small {};
	class uns_willys_2_m1919 : vn_defaults_small {};
	class uns_M35A2 : vn_defaults_large {};
	class uns_M35A2_Open : vn_defaults_large {};
	class uns_pbr : vn_defaults_small {};
	class vn_b_boat_05_02 : vn_defaults_small {};
	class vn_b_boat_05_01 : vn_defaults_small {};
	class vn_b_boat_06_02 : vn_defaults_small {};
	class vn_b_boat_06_01 : vn_defaults_small {};
	class uns_UH1D_raaf_m60 : vn_defaults_small {};
	class uns_xm706e1 : vn_defaults_small {};
	class uns_xm706e2 : vn_defaults_small {};
	class vn_b_armor_m42 : vn_defaults_large {};
	class vn_b_wheeled_m54_fuel : vn_defaults_large {};
	class vn_b_wheeled_m54_ammo : vn_defaults_large {};
	class vn_b_wheeled_m54_mg_01 : vn_defaults_large {};
	class vn_b_wheeled_m54_mg_03 : vn_defaults_large {};
	class vn_b_wheeled_m54_01 : vn_defaults_large {};
	class vn_b_wheeled_m54_02 : vn_defaults_large {};
	class vn_b_air_oh6a_02 : vn_defaults_small {};
	class vn_b_air_oh6a_04 : vn_defaults_small {};
	class vn_b_air_oh6a_03 : vn_defaults_small {};
	class vn_b_air_oh6a_01 : vn_defaults_small {};
	class vn_b_air_uh1c_04_01 : vn_defaults_small {};
	class vn_b_air_uh1c_01_01 : vn_defaults_small {};
	class vn_b_air_ch34_01 : vn_defaults_small {};
	class vn_air_ah1g_01 : vn_defaults_small {};
	class vn_air_ah1g_02 : vn_defaults_small {};
	class vn_air_ah1g_04 : vn_defaults_small {};
	class vn_air_ah1g_03 : vn_defaults_small {};
	class vn_b_air_uh1c_03_01 : vn_defaults_small {};
	class vn_b_air_uh1d_02_01 : vn_defaults_small {};
	class vn_b_air_uh1c_02_01 : vn_defaults_small {};
	class vn_b_air_uh1d_01_01 : vn_defaults_small {};
    };
    class item_data
    {

        class I_supplyCrate_F  // building supplies
        {
            item_weight = 150;
            item_size = 25;
            spawn_distance = 5;
            rotation_offset = 0;
        };
        class uns_medcrate // food + aid
        {
            item_weight = 20;
            item_size = 10;
            spawn_distance = 3;
            rotation_offset = 0;
        };
	class vn_b_ammobox_sog // ammo
        {
            item_weight = 10;
            item_size = 5;
            spawn_distance = 3;
            rotation_offset = 0;
        };
    };
};
