class vgm_radio_operator {
    class aircraft {
        class template {
            // Prevents this template being loaded as a possible aircraft.
            disabled = 1;
            // Name of the aircraft, as shown to the player.
            displayName = "Stringtable key goes here";
            // One of "HELICOPTER" or "PLANE" - specifies the strike logic to use.
            vehicleType = "PLANE";
            // Class of aircraft that's created.
            vehicleClass = "vn_b_air_f4c_cas";
            // Time until the aircraft arrives on-station
            arrivalTimeSecs = 600;
            // Time the aircraft can remain on-station before returning to base.
            onStationTimeSecs = 600;
            // All strikes available to the aircraft while on-station
            class strikes {
                // A single strike. The name will be based on the magazines.
                class my_strike {
                    displayName = "My strike";
                    // The weapons to fire or magazines that are fitted to each Pylon on the aircraft during the strike. All listed weapons are fired.
                    magazines[] = {""};
                    // Numbeere of uses
                    uses = 1;
                };
            };
        };

        class f100d_mk82 {
            displayName = "F100D MK82";
            vehicleType = "PLANE";
            vehicleClass = "vn_b_air_f100d_cas";
            arrivalTimeSecs = 30;
            onStationTimeSecs = 180;
            class strikes {
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"vn_m39a1_v_quad"};
                    uses = 2;
                };
                class rockets {
                    displayName = "Rockets (10lb HE)";
                    magazines[] = {"vn_rocket_ffar_m151_he_x7"};
                    uses = 2;
                };
                class mk82 {
                    displayName = "Bomb (Mk82 500lb)";
                    magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                    uses = 1;
                };
            };
        };

        class f100d_mk82_napalm {
            displayName = "F100D MK82 Napalm";
            vehicleType = "PLANE";
            vehicleClass = "vn_b_air_f100d_cas";
            arrivalTimeSecs = 30;
            onStationTimeSecs = 240;
            class strikes {
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"vn_m39a1_v_quad"};
                    uses = 2;
                };
                class rockets {
                    displayName = "Rockets (10lb HE)";
                    magazines[] = {"vn_rocket_ffar_m151_he_x7"};
                    uses = 2;
                };
                class mk82 {
                    displayName = "Bomb (Mk82 500lb)";
                    magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                    uses = 1;
                };
                class napalm {
                    displayName = "Bomb (Napalm)";
                    magazines[] = {"vn_bomb_750_blu1b_fb_mag_x1"};
                    uses = 1;
                };
            };
        };

        class f4c {
            displayName = "F-4C";
            vehicleType = "PLANE";
            vehicleClass = "vn_b_air_f4c_cas";
            arrivalTimeSecs = 30;
            onStationTimeSecs = 300;
            class strikes {
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"", "vn_gunpod_suu23_v_1200_mag", "vn_gunpod_suu23_v_1200_mag", ""};
                    uses = 2;
                };
                class rockets {
                    displayName = "Rockets (10lb HE)";
                    magazines[] = {"vn_rocket_ffar_m151_he_x7"};
                    uses = 2;
                };
                class mk82 {
                    displayName = "Bomb (Mk82 500lb)";
                    magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                    uses = 1;
                };
                class napalm {
                    displayName = "Bomb (Napalm)";
                    magazines[] = {"vn_bomb_750_blu1b_fb_mag_x1"};
                    uses = 1;
                };
                class cbu {
                    displayName = "Bomb (CBU)";
                    magazines[] = {"vn_rocket_ffar_f4_lau3_m151_he_x57"};
                    uses = 1;
                };
            };
        };

        class f4b {
            displayName = "F-4B";
            vehicleType = "PLANE";
            vehicleClass = "vn_b_air_f4b_navy_cas";
            arrivalTimeSecs = 30;
            onStationTimeSecs = 360;
            class strikes {
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"", "vn_gunpod_suu23_v_1200_mag", "vn_gunpod_suu23_v_1200_mag", ""};
                    uses = 2;
                };
                class rockets {
                    displayName = "Rockets (10lb HE)";
                    magazines[] = {"vn_rocket_ffar_m151_he_x7"};
                    uses = 2;
                };
                class mk82 {
                    displayName = "Bomb (Mk82 500lb)";
                    magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                    uses = 2;
                };
                class napalm {
                    displayName = "Bomb (Napalm)";
                    magazines[] = {"vn_bomb_750_blu1b_fb_mag_x1"};
                    uses = 2;
                };
                class cbu {
                    displayName = "Bomb (CBU)";
                    magazines[] = {"vn_rocket_ffar_f4_lau3_m151_he_x57"};
                    uses = 1;
                };
            };
        };

        class uh1c_gunship {
            displayName = "UH-1C Gunship";
            vehicleType = "HELICOPTER";
            vehicleClass = "vn_b_air_uh1c_02_01";
            arrivalTimeSecs = 120;
            onStationTimeSecs = 480;
            class strikes {
                class minigun {
                    displayName = "Miniguns";
                    magazines[] = {"vn_gunpod_xm21"};
                    uses = 3;
                };
                class rockets {
                    displayName = "Rockets (10lb HE)";
                    magazines[] = {"vn_rocket_ffar_m229_he_x7"};
                    uses = 3;
                };
            };
        };

        class uh1c_heavy_hog {
            displayName = "UH-1C Heavy Hog";
            vehicleType = "HELICOPTER";
            vehicleClass = "vn_b_air_uh1c_05_01";
            arrivalTimeSecs = 120;
            onStationTimeSecs = 600;
            class strikes {
                class grenades {
                    displayName = "40mm grenades (HE)";
                    guidedDispersion = 20;
                    magazines[] = {"vn_m75_v_06"};
                    uses = 3;
                };
                class rockets {
                    displayName = "Rockets (10lb HE)";
                    magazines[] = {"vn_rocket_ffar_m229_he_x7"};
                    uses = 3;
                };
            };
        };

        class uh1c_ara {
            displayName = "UH-1C ARA";
            vehicleType = "HELICOPTER";
            vehicleClass = "vn_b_air_uh1c_06_02";
            arrivalTimeSecs = 120;
            onStationTimeSecs = 720;
            class strikes {
                class rockets_10lb {
                    displayName = "Rockets (10lb HE)";
                    magazines[] = {"vn_rocket_ffar_m229_he_x7"};
                    uses = 3;
                };
                class rockets_17lb {
                    displayName = "Rockets (17lb HE)";
                    magazines[] = {"vn_rocket_ffar_m229_he_x24_01"};
                    uses = 3;
                };
            };
        };

        class ah1g {
            displayName = "AH-1G";
            vehicleType = "HELICOPTER";
            vehicleClass = "vn_b_air_ah1g_09";
            arrivalTimeSecs = 120;
            onStationTimeSecs = 840;
            class strikes {
                class grenades {
                    displayName = "40mm grenades (HE)";
                    magazines[] = {"vn_m129"};
                    uses = 4;
                };
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"vn_gunpod_m195_v_2100_mag"};
                    uses = 4;
                };
                class rockets_10lb {
                    displayName = "Rockets (10lb HE)";
                    magazines[] = {"vn_rocket_ffar_m229_he_x7"};
                    uses = 4;
                };
            };
        };
    };
};
