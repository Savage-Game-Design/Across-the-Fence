#define CONDITION_HEAVY_SUPPORT condition = "player getUnitTrait 'vgm_artillery_heavySupport'"

class vn_artillery_settings {
    cost_variable = "";
    // Array - { Always available, `radio_backpacks`, `radio_vehicles`, `player_types`, "vn_artillery" unit trait}
    availability[] = {0, 1, 0, 0, 0};
    unit_trait_required = 1;
    danger_distance = 150;
    delay_max = 0;
    captive = 1;

    radio_backpacks[] = {"vn_b_pack_m41_05", "vn_b_pack_trp_04", "vn_b_pack_trp_04_02", "vn_b_pack_03", "vn_b_pack_03_02", "vn_b_pack_lw_06", "vn_b_pack_prc77_01"};
    radio_vehicles[] = {};
    player_types[] = {};

    // =========================================================================
    // AIRCRAFT
    // =========================================================================
    class aircraft {

        // -----------------------------------------------------------------
        // HE (High Explosive)
        // -----------------------------------------------------------------
        class he {
            displayname = $STR_VN_ARTILLERY_AIRCRAFT_HE_HE_NAME;

            // --- Fox (F-100D, Mk82 x2) - base (no Fire Coordination) ---
            class fox {
                displayname = "$STR_VGM_ARTILLERY_FOX";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                description = "$STR_VGM_ARTILLERY_FOX_DESC";
                condition = "(player getVariable ['vgm_c_skill_casFastMover', false]) && {(player getVariable ['vgm_c_skill_fireCoord', 0]) < 1} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_bomb_500_mk82_he_mag_x1", "vn_bomb_500_mk82_he_mag_x1"};
                vehicleclass = "vn_b_air_f100d_cas";
                cooldown = "[300] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- Fox (F-100D, Mk82 x2) - Fire Coordination (double run) ---
            class fox_fc {
                displayname = "$STR_VGM_ARTILLERY_FOX";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                description = "$STR_VGM_ARTILLERY_FOX_FC_DESC";
                condition = "(player getVariable ['vgm_c_skill_casFastMover', false]) && {(player getVariable ['vgm_c_skill_fireCoord', 0]) >= 1} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_bomb_500_mk82_he_mag_x1", "vn_bomb_500_mk82_he_mag_x1"};
                vehicleclass = "vn_b_air_f100d_cas";
                allow_double = 1;
                cooldown = "[300] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- Sundowner (F-4C, Napalm) - base (no FC2) ---
            class sundowner {
                displayname = "$STR_VGM_ARTILLERY_SUNDOWNER";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_vf111_ca.paa";
                description = "$STR_VGM_ARTILLERY_SUNDOWNER_DESC";
                condition = "(player getVariable ['vgm_c_skill_casFastMover', false]) && {(player getVariable ['vgm_c_skill_fireCoord', 0]) < 2} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_bomb_500_blu1b_fb_mag_x1", ""};
                vehicleclass = "vn_b_air_f4c_cas";
                cooldown = "[300] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- Sundowner (F-4C, Napalm) - Fire Coordination II (double run) ---
            class sundowner_fc {
                displayname = "$STR_VGM_ARTILLERY_SUNDOWNER";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_vf111_ca.paa";
                description = "$STR_VGM_ARTILLERY_SUNDOWNER_FC_DESC";
                condition = "(player getVariable ['vgm_c_skill_casFastMover', false]) && {(player getVariable ['vgm_c_skill_fireCoord', 0]) >= 2} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_bomb_500_blu1b_fb_mag_x1", ""};
                vehicleclass = "vn_b_air_f4c_cas";
                allow_double = 1;
                cooldown = "[300] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- Hobo (F-4C, Gun run) ---
            class hobo {
                displayname = "$STR_VGM_ARTILLERY_HOBO";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1sos_ca.paa";
                description = "$STR_VGM_ARTILLERY_HOBO_DESC";
                condition = "(player getVariable ['vgm_c_skill_casFastMover', false]) && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_m61a1"};
                vehicleclass = "vn_b_air_f4c_cas";
                cooldown = "[300] call vgm_c_fnc_artillery_getCooldown";
            };
        };

        // -----------------------------------------------------------------
        // GUNSHIP
        // -----------------------------------------------------------------
        class gunship {
            displayname = "$STR_VGM_ARTILLERY_CAT_GUNSHIP";

            // --- Maverick (UH-1C, FFAR x2) - base (no Fire Coordination) ---
            class maverick {
                displayname = "$STR_VGM_ARTILLERY_MAVERICK";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                description = "$STR_VGM_ARTILLERY_MAVERICK_DESC";
                condition = "(player getVariable ['vgm_c_skill_casGunship', false]) && {(player getVariable ['vgm_c_skill_fireCoord', 0]) < 1} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_rocket_ffar_275_he_x7", "vn_rocket_ffar_275_he_x7"};
                vehicleclass = "vn_b_air_uh1c_01_01";
                cooldown = "[240] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- Maverick (UH-1C, FFAR x2) - Fire Coordination (double run) ---
            class maverick_fc {
                displayname = "$STR_VGM_ARTILLERY_MAVERICK";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                description = "$STR_VGM_ARTILLERY_MAVERICK_FC_DESC";
                condition = "(player getVariable ['vgm_c_skill_casGunship', false]) && {(player getVariable ['vgm_c_skill_fireCoord', 0]) >= 1} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_rocket_ffar_275_he_x7", "vn_rocket_ffar_275_he_x7"};
                vehicleclass = "vn_b_air_uh1c_01_01";
                allow_double = 1;
                cooldown = "[240] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- Condor (AH-1G, FFAR x4) - base (no FC2) ---
            class condor {
                displayname = "$STR_VGM_ARTILLERY_CONDOR";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                description = "$STR_VGM_ARTILLERY_CONDOR_DESC";
                condition = "(player getVariable ['vgm_c_skill_casGunship', false]) && {(player getVariable ['vgm_c_skill_fireCoord', 0]) < 2} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_rocket_ffar_275_he_x7", "vn_rocket_ffar_275_he_x7", "vn_rocket_ffar_275_he_x7", "vn_rocket_ffar_275_he_x7"};
                vehicleclass = "vn_b_air_ah1g_04";
                cooldown = "[360] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- Condor (AH-1G, FFAR x4) - Fire Coordination II (double run) ---
            class condor_fc {
                displayname = "$STR_VGM_ARTILLERY_CONDOR";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                description = "$STR_VGM_ARTILLERY_CONDOR_FC_DESC";
                condition = "(player getVariable ['vgm_c_skill_casGunship', false]) && {(player getVariable ['vgm_c_skill_fireCoord', 0]) >= 2} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {"vn_rocket_ffar_275_he_x7", "vn_rocket_ffar_275_he_x7", "vn_rocket_ffar_275_he_x7", "vn_rocket_ffar_275_he_x7"};
                vehicleclass = "vn_b_air_ah1g_04";
                allow_double = 1;
                cooldown = "[360] call vgm_c_fnc_artillery_getCooldown";
            };
        };

        // -----------------------------------------------------------------
        // NICKEL STEEL (AC-119K, requires SOG Nickel Steel)
        // -----------------------------------------------------------------
        class nickel_steel {
            displayname = "$STR_VGM_ARTILLERY_CAT_NICKEL_STEEL";

            // --- AC-119K Orbit ---
            class ac119_orbit {
                displayname = "$STR_VGM_ARTILLERY_AC119_ORBIT";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1sos_ca.paa";
                description = "$STR_VGM_ARTILLERY_AC119_ORBIT_DESC";
                condition = "(player getVariable ['vgm_c_skill_ac119Orbit', false]) && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {};
                vehicleclass = "";
                function = "vnx_fnc_artillery_ac119_orbit";
                divergence = -1000;
                cooldown = "[600] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- AC-119K Bomb Run ---
            class ac119_bomb {
                displayname = "$STR_VGM_ARTILLERY_AC119_BOMB";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1sos_ca.paa";
                description = "$STR_VGM_ARTILLERY_AC119_BOMB_DESC";
                condition = "(player getVariable ['vgm_c_skill_ac119Bomb', false]) && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {};
                vehicleclass = "";
                function = "vnx_fnc_artillery_ac119_bomb";
                divergence = -250;
                cooldown = "[600] call vgm_c_fnc_artillery_getCooldown";
            };
        };

        // -----------------------------------------------------------------
        // ILLUMINATION
        // -----------------------------------------------------------------
        class illumination {
            displayname = $STR_VN_ARTILLERY_AIRCRAFT_ILLUMINATION_ILLUMINATION_NAME;

            // --- Fireship: Gnat (UH-1D Flare ship) ---
            class gnat {
                displayname = $STR_VN_ARTILLERY_AIRCRAFT_ILLUMINATION_GNAT_NAME;
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                description = $STR_VN_ARTILLERY_AIRCRAFT_ILLUMINATION_GNAT_DESCRIPTION;
                condition = "(player getVariable ['vgm_c_skill_fireship', false]) && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {};
                vehicleclass = "vn_b_air_uh1d_02_03";
                allow_double = 1;
                cooldown = "40";
                illumination = 1;
            };

            // --- Shadow: Dawn illumination (night only) ---
            class shadow {
                displayname = "$STR_VGM_ARTILLERY_SHADOW";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                description = "$STR_VGM_ARTILLERY_SHADOW_DESC";
                condition = "(daytime >= 18 || daytime <= 6) && {player getVariable ['vgm_c_skill_shadow', false]} && {(backpack player) in ['vn_b_pack_m41_05','vn_b_pack_trp_04','vn_b_pack_trp_04_02','vn_b_pack_03','vn_b_pack_03_02','vn_b_pack_lw_06','vn_b_pack_prc77_01']}";

                magazines[] = {};
                vehicleclass = "vn_b_air_uh1d_02_03";
                cooldown = "[600] call vgm_c_fnc_artillery_getCooldown";
                illumination = 1;
            };
        };

        // -----------------------------------------------------------------
        // SPECIAL (Active skill window, uses `function` attribute)
        // -----------------------------------------------------------------
        class special {
            displayname = "$STR_VGM_ARTILLERY_CAT_SPECIAL";

            // --- Arclight (B-52 carpet bomb) - base divergence ---
            class arclight {
                displayname = "$STR_VGM_ARTILLERY_ARCLIGHT";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                description = "$STR_VGM_ARTILLERY_ARCLIGHT_DESC";
                condition = "(player getVariable ['vgm_c_skill_arclight_active', false]) && {(player getVariable ['vgm_c_skill_precisionStrike', 0]) < 1}";

                magazines[] = {};
                vehicleclass = "";
                cooldown = "60";
                function = "vn_fnc_artillery_arc_light";
                divergence = 200;
            };

            // --- Arclight - Precision Strike I (120m divergence) ---
            class arclight_ps1 {
                displayname = "$STR_VGM_ARTILLERY_ARCLIGHT";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                description = "$STR_VGM_ARTILLERY_ARCLIGHT_PS1_DESC";
                condition = "(player getVariable ['vgm_c_skill_arclight_active', false]) && {(player getVariable ['vgm_c_skill_precisionStrike', 0]) == 1}";

                magazines[] = {};
                vehicleclass = "";
                cooldown = "60";
                function = "vn_fnc_artillery_arc_light";
                divergence = 120;
            };

            // --- Arclight - Precision Strike II (80m divergence) ---
            class arclight_ps2 {
                displayname = "$STR_VGM_ARTILLERY_ARCLIGHT";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                description = "$STR_VGM_ARTILLERY_ARCLIGHT_PS2_DESC";
                condition = "(player getVariable ['vgm_c_skill_arclight_active', false]) && {(player getVariable ['vgm_c_skill_precisionStrike', 0]) >= 2}";

                magazines[] = {};
                vehicleclass = "";
                cooldown = "60";
                function = "vn_fnc_artillery_arc_light";
                divergence = 80;
            };

            // --- Big Blue (BLU-82 + LZ creation) - base divergence ---
            class big_blue {
                displayname = "$STR_VGM_ARTILLERY_BIG_BLUE";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1sos_ca.paa";
                description = "$STR_VGM_ARTILLERY_BIG_BLUE_DESC";
                condition = "(player getVariable ['vgm_c_skill_bigBlue_active', false]) && {(player getVariable ['vgm_c_skill_precisionStrike', 0]) < 1}";

                magazines[] = {};
                vehicleclass = "";
                cooldown = "60";
                function = "vn_fnc_artillery_commando_vault";
                divergence = -45;
            };

            // --- Big Blue - Precision Strike I (-30 divergence) ---
            class big_blue_ps1 {
                displayname = "$STR_VGM_ARTILLERY_BIG_BLUE";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1sos_ca.paa";
                description = "$STR_VGM_ARTILLERY_BIG_BLUE_PS1_DESC";
                condition = "(player getVariable ['vgm_c_skill_bigBlue_active', false]) && {(player getVariable ['vgm_c_skill_precisionStrike', 0]) == 1}";

                magazines[] = {};
                vehicleclass = "";
                cooldown = "60";
                function = "vn_fnc_artillery_commando_vault";
                divergence = -30;
            };

            // --- Big Blue - Precision Strike II (-20 divergence) ---
            class big_blue_ps2 {
                displayname = "$STR_VGM_ARTILLERY_BIG_BLUE";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1sos_ca.paa";
                description = "$STR_VGM_ARTILLERY_BIG_BLUE_PS2_DESC";
                condition = "(player getVariable ['vgm_c_skill_bigBlue_active', false]) && {(player getVariable ['vgm_c_skill_precisionStrike', 0]) >= 2}";

                magazines[] = {};
                vehicleclass = "";
                cooldown = "60";
                function = "vn_fnc_artillery_commando_vault";
                divergence = -20;
            };
        };

        // -----------------------------------------------------------------
        // EMERGENCY (No backpack required, 50% higher cooldowns)
        // -----------------------------------------------------------------
        class emergency {
            displayname = "$STR_VGM_ARTILLERY_CAT_EMERGENCY";

            // --- Emergency HE (F-100D, Mk82 x1) ---
            class emergency_he {
                displayname = "$STR_VGM_ARTILLERY_EMERGENCY_HE";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                description = "$STR_VGM_ARTILLERY_EMERGENCY_HE_DESC";
                condition = "player getVariable ['vgm_c_skill_emergencyRadio', false]";

                magazines[] = {"vn_bomb_500_mk82_he_mag_x1"};
                vehicleclass = "vn_b_air_f100d_cas";
                cooldown = "[450] call vgm_c_fnc_artillery_getCooldown";
            };

            // --- Emergency Illumination (UH-1D Flare ship) ---
            class emergency_illum {
                displayname = "$STR_VGM_ARTILLERY_EMERGENCY_ILLUM";
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                description = "$STR_VGM_ARTILLERY_EMERGENCY_ILLUM_DESC";
                condition = "player getVariable ['vgm_c_skill_emergencyRadio', false]";

                magazines[] = {};
                vehicleclass = "vn_b_air_uh1d_02_03";
                cooldown = "[60] call vgm_c_fnc_artillery_getCooldown";
                illumination = 1;
            };
        };
    };

    class artillery {};
    class resupply {};
};
