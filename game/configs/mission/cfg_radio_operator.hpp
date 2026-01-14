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
                    // The weapons to fire or magazines that are fitted to each Pylon on the aircraft during the strike. All listed weapons are fired.
                    magazines[] = {""};
                    // Numbeere of uses
                    uses = 1;
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
                    magazines[] = {"vn_m61a1"};
                    uses = 2;
                };
            };
        };
    };
};
