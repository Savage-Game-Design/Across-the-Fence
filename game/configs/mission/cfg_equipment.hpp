class vgm_equipment {
    startingUniform = "vn_b_uniform_sog_02_05";
    startingVest = "vn_b_vest_sog_04";
    startingBackpack = "vn_b_pack_01";

    startingItems[] = {"vn_b_item_map", "vn_b_item_compass", "vn_b_item_watch"};
    startingBinocular[] = {"vn_camera_01", ""};

    startingWeaponItems[] = {
        // mags/explosives/FAKs
        {"", {
            {"vn_b_item_toolkit_weightless", 1},
            {"vn_helper_item_firstaidkit", 15},
            {"vn_m18_white_mag", 3},
            {"vn_m18_red_mag", 3},
            {"vn_m18_green_mag", 3},
            {"vn_m61_grenade_mag", 3},
            {"vn_mine_m14_mag", 20}
        }},
        // weapons
        {"vn_xm177", {{"vn_m16_20_mag", 11}, {"vn_m16_20_t_mag", 5}}},
        {"vn_m1911", {"vn_s_m1911", {"vn_m1911_mag", 4}}},
        {"vn_m127", {{"vn_m127_mag", 4}}},
    };

    #include "cfg_equipment_generated.hpp"

    class explosives {
        condition = "(['fireSupport', 'loadout_explosives'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
        };

        magazines[] = {
            // Weapon magazines
            // Flare launcher flares
            // Grenades and explosives
            "vn_mine_tripwire_m49_02_mag",
            "vn_mine_tripwire_m49_04_mag",
            "vn_mine_m18_wp_mag",
            "vn_mine_m18_wp_range_mag",
            "vn_mine_m18_wp_fuze10_mag",
            "vn_mine_m18_x3_mag",
            "vn_mine_m18_x3_range_mag",
            "vn_mine_m18_mag",
            "vn_mine_m18_range_mag",
            "vn_mine_m18_fuze10_mag",
            "vn_mine_m16_mag",
            "vn_mine_tripwire_m16_04_mag",
            "vn_mine_tripwire_m16_02_mag",
            "vn_mine_m15_mag",
            "vn_mine_m14_mag",
            "vn_mine_limpet_01_mag",
            "vn_mine_ammobox_range_mag",
            "vn_mine_m112_remote_mag",
            "vn_satchelcharge_02_throw_mag",
            "vn_m14_grenade_mag",
            "vn_m14_early_grenade_mag",
            "vn_m34_grenade_mag",
            "vn_m61_grenade_mag",
            "vn_m67_grenade_mag"
        };

        backpacks[] = {

        };

        items[] = {
            // Accessories
            // Uniforms
            // Vests
            // Headgear
            // Equipment
        };
    };

    class grenadier {
        condition = "(['fireSupport', 'loadout_grenadier'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
        };

        magazines[] = {
            // Weapon magazines
            // Flare launcher flares
            // Grenades and explosives
            "vn_m14_grenade_mag",
            "vn_m14_early_grenade_mag",
            "vn_m34_grenade_mag",
            "vn_m61_grenade_mag",
            "vn_m67_grenade_mag",
            "vn_m7_grenade_mag",
            "vn_rkg3_grenade_mag",
            "vn_m18_green_mag",
            "vn_m18_purple_mag",
            "vn_m18_red_mag",
            "vn_m18_white_mag",
            "vn_m18_yellow_mag",
            "vn_t67_grenade_mag",
            "vn_v40_grenade_mag"
        };

        backpacks[] = {

        };

        items[] = {
            // Accessories
            // Uniforms
            // Vests
            // Headgear
            // Equipment
        };
    };
};
