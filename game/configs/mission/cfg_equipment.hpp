class vgm_equipment {
    startingUniform = "vn_b_uniform_sog_02_05";
    startingVest = "vn_b_vest_sog_04";
    startingBackpack = "vn_b_pack_01";

    startingItems[] = {"vn_b_item_map", "vn_b_item_compass", "vn_b_item_watch", "vn_b_item_radio_urc10"};
    startingBinocular[] = {"vn_camera_01", ""};

    startingWeaponItems[] = {
        {"vn_m1911", {"vn_s_m1911", {"vn_m1911_mag", 4}}},
        {"vn_xm177", {{"vn_m16_20_mag", 3}, {"vn_m16_20_t_mag", 2}}},
        {"", {
            {"vn_helper_item_firstaidkit", 6},
            {"vn_mine_m14_mag", 3},
            {"vn_m61_grenade_mag", 3}
        }},
        {"", {
            {"vn_m16_20_mag", 8},
            {"vn_m16_20_t_mag", 3},
            {"vn_helper_item_firstaidkit", 9},
            {"vn_b_item_toolkit_weightless", 1},
            {"vn_m18_white_mag", 3},
            {"vn_m18_red_mag", 3},
            {"vn_m18_green_mag", 3},
            {"vn_mine_m14_mag", 17}
        }},
        {"vn_m127", {{"vn_m127_mag", 4}}}
    };

    #include "cfg_equipment_generated.hpp"
};
