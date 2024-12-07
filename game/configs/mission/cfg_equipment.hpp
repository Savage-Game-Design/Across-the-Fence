class vgm_equipment {
    startingUniform = "vn_b_uniform_sog_02_05";
    startingVest = "vn_b_vest_sog_04";
    startingBackpack = "vn_b_pack_01";

    startingItems[] = {"vn_b_item_map", "vn_b_item_compass", "vn_b_item_watch", "vn_b_item_radio_urc10"};
    startingBinocular[] = {"vn_camera_01", ""};

    startingWeaponItems[] = {
        // mags/explosives/FAKs
        {"", {
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

    class default {
        condition = "true";

        weapons[] = {
            "vn_m45",
            "vn_m1carbine",
            "vn_m1_garand",
            "vn_xm177",
            "vn_m1911",
            "vn_p38",
            "vn_m127"
        };

        magazines[] = {
            // Weapon magazines
            "vn_m45_mag",
            "vn_m45_t_mag",
            "vn_carbine_15_mag",
            "vn_carbine_15_t_mag",
            "vn_carbine_30_mag",
            "vn_carbine_30_t_mag",
            "vn_m1_garand_mag",
            "vn_m1_garand_t_mag",
            "vn_m16_20_mag",
            "vn_m16_20_t_mag",
            "vn_m1911_mag",
            "vn_p38_mag",
            // Flare launcher flares
            "vn_m127_mag",
            "vn_m128_mag",
            "vn_m129_mag",
            // Grenades and explosives
            "vn_m18_green_mag",
            "vn_m18_purple_mag",
            "vn_m18_red_mag",
            "vn_m18_white_mag",
            "vn_m18_yellow_mag",
            "vn_m61_grenade_mag",
            "vn_mine_satchel_remote_02_mag",
            "vn_mine_m14_mag"
        };

        backpacks[] = {
            "vn_b_pack_01",
            "vn_b_pack_02",
            "vn_b_pack_04",
            "vn_b_pack_05"
        };

        items[] = {
            // Accessories
            "vn_s_ppk",
            "vn_s_m1911",
            "vn_helper_item_firstaidkit",
            // Uniforms
            "vn_b_uniform_sog_01_01",
            "vn_b_uniform_sog_01_02",
            "vn_b_uniform_sog_01_03",
            "vn_b_uniform_sog_01_04",
            "vn_b_uniform_sog_01_05",
            "vn_b_uniform_sog_01_06",
            "vn_b_uniform_sog_02_01",
            "vn_b_uniform_sog_02_02",
            "vn_b_uniform_sog_02_03",
            "vn_b_uniform_sog_02_04",
            "vn_b_uniform_sog_02_05",
            "vn_b_uniform_sog_02_06",
            // Vests
            "vn_b_vest_sog_01",
            "vn_b_vest_sog_02",
            "vn_b_vest_sog_03",
            "vn_b_vest_sog_04",
            "vn_b_vest_sog_05",
            "vn_b_vest_sog_06",
            // Headgear
            "vn_b_headband_01",
            "vn_b_headband_02",
            "vn_b_headband_03",
            "vn_b_headband_04",
            "vn_b_headband_08",
            // Equipment
            "vn_camera_01",
            "vn_anpvs2_binoc",
            "vn_m19_binocs_grey",
            "vn_m19_binocs_green",
            "vn_mk21_binocs",
            "vn_b_item_map",
            "vn_b_item_radio_urc10",
            "vn_b_item_compass",
            "vn_b_item_watch"
        };
    };

    class rifleman {
        condition = "(['rifleman', 'loadout'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
           "vn_xm177",
           "vn_xm177_stock",
           "vn_xm177_short",
           "vn_xm177_fg",
           "vn_m16",
           "vn_type56",
           "vn_hd",
           "vn_m10",
           "vn_hp"
        };

        magazines[] = {
            // Weapon magazines
            "vn_m16_20_mag",
            "vn_m16_30_mag",
            "vn_m16_40_mag",
            "vn_m16_20_t_mag",
            "vn_m16_30_t_mag",
            "vn_m16_40_t_mag",
            "vn_type56_mag",
            "vn_type56_t_mag",
            "vn_hd_mag",
            "vn_m10_mag",
            "vn_hp_mag",
            // Grenades and explosives
            "vn_v40_grenade_mag"
        };

        backpacks[] = {
        };

        items[] = {
            // Weapon accessories
            "vn_o_4x_m16",
            "vn_o_1x_sp_m16",
            "vn_bipod_m16",
            "vn_b_m16",
            "vn_o_anpvs2_m16",
            "vn_b_type56",
            "vn_s_hp"
        };
    };

    class historical {
        condition = "(['rifleman', 'loadout_historical'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
            "vn_m3a1",
            "vn_m1928a1_tommy",
            "vn_mp40",
            "vn_m1918",
            "vn_m1903",
            "vn_sten",
            "vn_welrod",
            "vn_ppk",
            "vn_m712",
            "vn_tt33"
        };

        magazines[] = {
            // Weapon magazines
            "vn_m3a1_mag",
            "vn_m3a1_t_mag",
            "vn_m1a1_20_mag",
            "vn_m1a1_20_t_mag",
            "vn_m1a1_30_mag",
            "vn_m1a1_30_t_mag",
            "vn_m1928_mag",
            "vn_m1928_t_mag",
            "vn_mp40_mag",
            "vn_mp40_t_mag",
            "vn_m1918_mag",
            "vn_m1918_t_mag",
            "vn_m1903_mag",
            "vn_m1903_t_mag",
            "vn_sten_mag",
            "vn_sten_t_mag",
            "vn_welrod_mag",
            "vn_ppk_mag",
            "vn_m712_mag",
            "vn_tt33_mag",
            // Flare launcher flares
            // Grenades and explosives
            "vn_rgd33_grenade_mag",
            "vn_t67_grenade_mag",
            "vn_rg42_grenade_mag"
        };

        backpacks[] = {

        };

        items[] = {
            // Accessories
            "vn_bipod_m1918",
            "vn_o_8x_m1903",
            "vn_b_m1903",
            "vn_b_camo_m1903",
            "vn_s_ppk"
            // Uniforms
            // Vests
            // Headgear
            // Equipment
        };
    };

    class marksman {
        condition = "(['recon', 'loadout_marksman'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
            "vn_m14",
            "vn_m1903",
            "vn_l1a1_01",
            "vn_m3carbine",
            "vn_m1carbine_shorty",
            "vn_m40a1",
            "vn_mk22",
            "vn_type64",
            "vn_vz61_p"
        };

        magazines[] = {
            // Weapon magazines
            "vn_m14_mag",
            "vn_m14_t_mag",
            "vn_m14_10_mag",
            "vn_m14_10_t_mag",
            "vn_m1903_mag",
            "vn_m1903_t_mag",
            "vn_l1a1_20_mag",
            "vn_l1a1_20_t_mag",
            "vn_l1a1_30_mag",
            "vn_l1a1_30_t_mag",
            "vn_l1a1_30_02_mag",
            "vn_l1a1_30_02_t_mag",
            "vn_l1a1_10_mag",
            "vn_l1a1_10_t_mag",
            "vn_carbine_30_mag",
            "vn_carbine_30_t_mag",
            "vn_carbine_15_mag",
            "vn_carbine_15_t_mag",
            "vn_hp_mag",
            "vn_carbine_15_mag",
            "vn_carbine_15_t_mag",
            "vn_carbine_30_mag",
            "vn_carbine_30_t_mag",
            "vn_m40a1_mag",
            "vn_m40a1_t_mag",
            "vn_mk22_mag",
            "vn_type64_mag",
            "vn_vz61_mag",
            "vn_vz61_t_mag"
            // Flare launcher flares
            // Grenades and explosives
        };

        backpacks[] = {

        };

        items[] = {
            // Accessories
            "vn_s_m14",
            "vn_o_9x_m14",
            "vn_o_anpvs2_m14",
            "vn_b_m14",
            "vn_b_camo_m14",
            "vn_o_8x_m1903",
            "vn_b_m1903",
            "vn_b_camo_m1903",
            "vn_o_3x_l1a1",
            "vn_b_l1a1",
            "vn_b_carbine",
            "vn_s_m14",
            "vn_o_9x_m40a1",
            "vn_o_anpvs2_m40a1",
            "vn_b_camo_m40a1",
            "vn_s_mk22"
            // Uniforms
            // Vests
            // Headgear
            // Equipment
        };
    };

    class pointman {
        condition = "(['recon', 'loadout_pointman'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
            "vn_m3a1",
            "vn_m1897",
            "vn_m45",
            "vn_sten",
            "vn_l34a1",
            "vn_izh54_p",
            "vn_hd",
            "vn_welrod"
        };

        magazines[] = {
            // Weapon magazines
            "vn_m3a1_mag",
            "vn_m3a1_t_mag",
            "vn_m1897_fl_mag",
            "vn_m1897_buck_mag",
            "vn_izh54_mag",
            "vn_izh54_so_mag",
            "vn_m45_mag",
            "vn_m45_t_mag",
            "vn_sten_mag",
            "vn_sten_t_mag",
            "vn_l34a1_smg_mag",
            "vn_l34a1_smg_t_mag",
            "vn_izh54_so_mag",
            "vn_izh54_mag",
            "vn_hd_mag",
            "vn_welrod_mag"
            // Flare launcher flares
            // Grenades and explosives
        };

        backpacks[] = {

        };

        items[] = {
            // Accessories
            "vn_s_m3a1",
            "vn_b_m1897",
            "vn_s_m45",
            "vn_s_m45_camo",
            "vn_s_sten"
            // Uniforms
            // Vests
            // Headgear
            // Equipment
        };
    };


    class machine_gunner {
        condition = "(['fireSupport', 'loadout_machineGunner'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
            "vn_rpd_shorty_01",
            "vn_l2a1_01",
            "vn_m1918",
            "vn_m60_shorty",
            "vn_m60",
            "vn_m63a_cdo",
            "vn_m63a_lmg",
            "vn_rpd",
            "vn_p38s"
        };

        magazines[] = {
            // Weapon magazines
            "vn_rpd_125_mag",
            "vn_rpd_100_mag",
            "vn_l1a1_30_02_mag",
            "vn_l1a1_30_02_t_mag",
            "vn_l1a1_30_mag",
            "vn_l1a1_30_t_mag",
            "vn_l1a1_10_mag",
            "vn_l1a1_10_t_mag",
            "vn_l1a1_20_mag",
            "vn_l1a1_20_t_mag",
            "vn_m1918_mag",
            "vn_m1918_t_mag",
            "vn_m60_100_mag",
            "vn_m60_100_mag",
            "vn_m63a_150_mag",
            "vn_m63a_150_t_mag",
            "vn_m63a_100_mag",
            "vn_m63a_100_t_mag",
            "vn_rpd_100_mag",
            "vn_rpd_125_mag",
            "vn_m10_mag"
            // Flare launcher flares
            // Grenades and explosives
        };

        backpacks[] = {

        };

        items[] = {
            // Accessories
            "vn_bipod_m1918",
            "vn_bipod_m63a",
            "vn_bipod_m63a"
            // Uniforms
            // Vests
            // Headgear
            // Equipment
        };
    };

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
            "vn_m16_xm148",
            "vn_m16_m203",
            "vn_m79",
            "vn_xm177_xm148",
            "vn_xm177_m203",
            "vn_xm16e1_xm148",
            "vn_m2carbine_gl",
            "vn_m1903_gl",
            "vn_l1a1_xm148",
            "vn_m20a1b1_01",
            "vn_m72",
            "vn_rpg7",
            "vn_rpg2",
            "vn_m79_p"
        };

        magazines[] = {
            // Weapon magazines
            "vn_m16_20_mag",
            "vn_m16_30_mag",
            "vn_m16_20_t_mag",
            "vn_m16_30_t_mag",
            "vn_40mm_m381_he_mag",
            "vn_40mm_m406_he_mag",
            "vn_40mm_m397_ab_mag",
            "vn_40mm_m433_hedp_mag",
            "vn_40mm_m583_flare_w_mag",
            "vn_40mm_m661_flare_g_mag",
            "vn_40mm_m662_flare_r_mag",
            "vn_40mm_m695_flare_y_mag",
            "vn_40mm_m680_smoke_w_mag",
            "vn_40mm_m682_smoke_r_mag",
            "vn_40mm_m715_smoke_g_mag",
            "vn_40mm_m716_smoke_y_mag",
            "vn_40mm_m717_smoke_p_mag",
            "vn_40mm_m651_cs_mag",
            "vn_40mm_m576_buck_mag",
            "vn_carbine_15_mag",
            "vn_carbine_15_t_mag",
            "vn_22mm_m1a2_frag_mag",
            "vn_22mm_m17_frag_mag",
            "vn_22mm_m9_heat_mag",
            "vn_22mm_lume_mag",
            "vn_22mm_m22_smoke_mag",
            "vn_22mm_m19_wp_mag",
            "vn_22mm_cs_mag",
            "vn_m1903_mag",
            "vn_m1903_t_mag",
            "vn_22mm_m1a2_frag_mag",
            "vn_22mm_m17_frag_mag",
            "vn_22mm_m9_heat_mag",
            "vn_22mm_lume_mag",
            "vn_22mm_m22_smoke_mag",
            "vn_22mm_m19_wp_mag",
            "vn_22mm_cs_mag",
            "vn_l1a1_30_mag",
            "vn_l1a1_30_t_mag",
            "vn_l1a1_20_mag",
            "vn_l1a1_20_t_mag",
            "vn_l1a1_10_mag",
            "vn_l1a1_10_t_mag",
            "vn_m20a1b1_heat_mag",
            "vn_m20a1b1_wp_mag",
            "vn_m72_mag",
            "vn_rpg7_mag",
            "vn_rpg2_mag",
            "vn_rpg2_fuze_mag",
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

    class advanced_medical {
        condition = "(['support', 'loadout_medical'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
            "vn_m1a1_tommy",
            "vn_m1a1_tommy_so",
            "vn_m2carbine"
        };

        magazines[] = {
            // Weapon magazines
            "vn_m1a1_20_mag",
            "vn_m1a1_20_t_mag",
            "vn_m1a1_30_mag",
            "vn_m1a1_30_t_mag",
            "vn_m1a1_20_mag",
            "vn_m1a1_20_t_mag",
            "vn_m1a1_30_mag",
            "vn_m1a1_30_t_mag",
            "vn_carbine_30_mag",
            "vn_carbine_30_t_mag",
            "vn_carbine_15_mag",
            "vn_carbine_15_t_mag"
            // Flare launcher flares
            // Grenades and explosives
        };

        backpacks[] = {

        };

        items[] = {
            // Accessories
            "vn_o_3x_m84",
            "vn_b_carbine",
            "vn_helper_item_medikit"
            // Uniforms
            // Vests
            // Headgear
            // Equipment
        };
    };

    class rto {
        condition = "(['support', 'loadout_rto'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown";

        weapons[] = {
            "vn_mc10",
            "vn_mpu"
        };

        magazines[] = {
            // Weapon magazines
            "vn_mc10_mag",
            "vn_mc10_t_mag",
            "vn_mpu_mag",
            "vn_mpu_t_mag"
            // Flare launcher flares
            // Grenades and explosives
        };

        backpacks[] = {
            "vn_b_pack_03",
            "vn_b_pack_prc77_01",
            "vn_b_pack_lw_06"
        };

        items[] = {
            // Accessories
            "vn_s_mc10",
            "vn_s_mpu"
            // Uniforms
            // Vests
            // Headgear
            // Equipment
        };
    };
};
