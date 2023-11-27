#define CONDITION_HEAVY_SUPPORT condition = "(['support', 'heavySupport'] call vgm_g_fnc_skills_getByPath) call vgm_g_fnc_skills_isKnown"

class vn_artillery_settings {
    // Add your NUMBER variable that will be used as a cost variable - leave empty if you don't want the cost to matter.
    cost_variable = "";
    // Array - { Always available, `radio_backpacks`, `radio_vehicles`, `player_types`, "vn_artillery" unit trait}
    // Make the first true for the radio to be always available
    availability[] = {0, 1, 0, 0, 0};
    // If enabled the "vn_artillery" unit trait is always required to use the radio support, additionaly to `availability` settings.
    unit_trait_required = 1;
    // Distance from the edge of a blacklisted marker that a artillery/aircraft cannot be called in.
    danger_distance = 150;
    // Maximum delay for the support to arrive, regardless of the time calculated from distance to support module.
    delay_max = 30;
    // Determines if the support planes/helicopters will be set to captive.
    captive = 1;

    radio_backpacks[] = {"vn_b_pack_03", "vn_b_pack_prc77_01", "vn_b_pack_lw_06"};
    radio_vehicles[] = {};
    player_types[] = {};

    // Planes
    class aircraft {
        class he {
            displayname = $STR_VN_ARTILLERY_AIRCRAFT_HE_HE_NAME;

            class rambler {
                displayname = $STR_VN_ARTILLERY_AIRCRAFT_CLUSTER_RAMBLER_NAME;
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                description = $STR_VN_ARTILLERY_AIRCRAFT_HE_VESPA_DESCRIPTION;
                CONDITION_HEAVY_SUPPORT;

                magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                vehicleclass = "vn_b_air_f4c_cas";
                cooldown = "5 * 60";
            };
            class sundowner {
                displayname = $STR_VN_ARTILLERY_AIRCRAFT_HE_SUNDOWNER_NAME;
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_vf111_ca.paa";
                description = $STR_VN_ARTILLERY_AIRCRAFT_HE_SUNDOWNER_DESCRIPTION;
                CONDITION_HEAVY_SUPPORT;

                magazines[] = {"vn_bomb_500_blu1b_fb_mag_x1", ""};
                vehicleclass = "vn_b_air_f4c_cas";
                allow_double = 1;
                cooldown = "5 * 60";
            };
            class hobo {
                displayname = $STR_VN_ARTILLERY_AIRCRAFT_HE_HOBO_NAME;
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1sos_ca.paa";
                description = $STR_VN_ARTILLERY_AIRCRAFT_HE_HOBO_DESCRIPTION;
                CONDITION_HEAVY_SUPPORT;

                magazines[] = {"vn_m61a1"};
                vehicleclass = "vn_b_air_f4c_cas";
                cooldown = "5 * 60";
            };
        };

        class cluster {
            displayname = $STR_VN_ARTILLERY_AIRCRAFT_CLUSTER_CLUSTER_NAME;

            class rambler {
                displayname = $STR_VN_ARTILLERY_AIRCRAFT_CLUSTER_RAMBLER_NAME;
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                description = $STR_VN_ARTILLERY_AIRCRAFT_CLUSTER_RAMBLER_DESCRIPTION;
                CONDITION_HEAVY_SUPPORT;

                magazines[] = {"vn_bomb_f4_out_500_mk20_cb_mag_x1", "vn_bomb_f4_out_500_mk20_cb_mag_x1"};
                vehicleclass = "vn_b_air_f4c_cas";
                allow_double = 1;
                cooldown = "8 * 60";
            };
        };

        class illumination {
            displayname = $STR_VN_ARTILLERY_AIRCRAFT_ILLUMINATION_ILLUMINATION_NAME;

            class gnat {
                displayname = $STR_VN_ARTILLERY_AIRCRAFT_ILLUMINATION_GNAT_NAME;
                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                description = $STR_VN_ARTILLERY_AIRCRAFT_ILLUMINATION_GNAT_DESCRIPTION;

                magazines[] = {};
                vehicleclass = "vn_b_air_uh1d_02_03";
                allow_double = 1;
                cooldown = "2 * 60";
                illumination = 1;
            };
        };
    };

    class artillery {};
    class resupply {};
};
