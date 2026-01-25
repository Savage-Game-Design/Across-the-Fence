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

        class f100d_mk82_1 {
            displayName = "F100D MK82";
            vehicleType = "PLANE";
            vehicleClass = "vn_b_air_f100d_cas";
            arrivalTimeSecs = 30;
            onStationTimeSecs = 180;
            class strikes {
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"vn_m39a1_v_twin"};
                    uses = 2;
                };
                class rockets {
                    displayName = "Rockets";
                    magazines[] = {"vn_rocket_ffar_f4_lau3_m229_he_x19"};
                    uses = 2;
                };
                class mk82 {
                    displayName = "Mk82 500lb bomb";
                    magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                    uses = 1;
                };
            };
        };

        class f100d_mk82_2 {
            displayName = "F100D MK82 2";
            vehicleType = "PLANE";
            vehicleClass = "vn_b_air_f100d_cas";
            arrivalTimeSecs = 30;
            onStationTimeSecs = 180;
            class strikes {
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"vn_m39a1_v_twin"};
                    uses = 2;
                };
                class rockets {
                    displayName = "Rockets";
                    magazines[] = {"vn_rocket_ffar_f4_lau3_m229_he_x19"};
                    uses = 2;
                };
                class mk82 {
                    displayName = "Mk82 500lb bomb";
                    magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                    uses = 1;
                };
            };
        };

        class f100d_mk82_3 {
            displayName = "F100D MK82 3";
            vehicleType = "PLANE";
            vehicleClass = "vn_b_air_f100d_cas";
            arrivalTimeSecs = 30;
            onStationTimeSecs = 180;
            class strikes {
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"vn_m39a1_v_twin"};
                    uses = 2;
                };
                class rockets {
                    displayName = "Rockets";
                    magazines[] = {"vn_rocket_ffar_f4_lau3_m229_he_x19"};
                    uses = 2;
                };
                class mk82 {
                    displayName = "Mk82 500lb bomb";
                    magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                    uses = 1;
                };
            };
        };

        class f100d_mk82_4 {
            displayName = "F100D MK82 4";
            vehicleType = "PLANE";
            vehicleClass = "vn_b_air_f100d_cas";
            arrivalTimeSecs = 30;
            onStationTimeSecs = 180;
            class strikes {
                class cannon {
                    displayName = "20mm cannon";
                    magazines[] = {"vn_m39a1_v_twin"};
                    uses = 2;
                };
                class rockets {
                    displayName = "Rockets";
                    magazines[] = {"vn_rocket_ffar_f4_lau3_m229_he_x19"};
                    uses = 2;
                };
                class mk82 {
                    displayName = "Mk82 500lb bomb";
                    magazines[] = {"vn_bomb_500_mk82_he_mag_x1","vn_bomb_500_mk82_he_mag_x1"};
                    uses = 1;
                };
            };
        };

        class testing_plane_2 {
            displayName = $STR_VN_V_PLANE_F4C_CAS_DN;
            vehicleType = "PLANE";// One of "HELICOPTER" or "PLANE"
            vehicleClass = "vn_b_air_f4c_cas";
            arrivalTimeSecs = 15;
            onStationTimeSecs = 180;
            class strikes {
                class m61a1 {
                    displayName = "M61A1";
                    magazines[] = {"vn_m61a1"};
                    uses = 2;
                };
            };
        };

        class testing_plane {
            displayName = $STR_VN_V_PLANE_F4C_CAS_DN;
            vehicleType = "PLANE";// One of "HELICOPTER" or "PLANE"
            vehicleClass = "vn_b_air_f4c_cas";
            arrivalTimeSecs = 15;
            onStationTimeSecs = 180;
            class strikes {
                class m61a1 {
                    displayName = "M61A1";
                    magazines[] = {"vn_m61a1"};
                    uses = 2;
                };
            };
        };
    };
};
