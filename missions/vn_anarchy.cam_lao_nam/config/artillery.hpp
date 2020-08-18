class vn_artillery_settings
{
        // Add your NUMBER variable that will be used as a cost variable - leave empty if you don't want the cost to matter.
        cost_variable = "";
        // Array - { Always available, `radio_backpacks`, `radio_vehicles`, `player_types`, "vn_artillery" unit trait}
        // Make the first true for the radio to be always avaliable
        availability[] = {0, 1, 1, 0, 0};
        unit_trait_required = 1;
        radio_backpacks[] = {"vn_o_pack_t884_01", "vn_o_pack_t884_ish54_01_pl", "vn_o_pack_t884_m1_01_pl", "vn_o_pack_t884_m38_01_pl", "vn_o_pack_t884_ppsh_01_pl", "vn_b_pack_prc77_01_m16_pl", "vn_b_pack_03_m3a1_pl", "vn_b_pack_03_xm177_pl", "vn_b_pack_03_type56_pl", "vn_b_pack_03", "vn_b_pack_prc77_01", "vn_b_pack_trp_04", "vn_b_pack_trp_04_02", "vn_b_pack_03", "vn_b_pack_03_02"};
        radio_vehicles[] = {"vn_b_boat_05_01", "vn_b_wheeled_m54_03", "vn_b_wheeled_m151_01", "vn_b_wheeled_m54_02", "vn_b_wheeled_m54_01", "vn_b_wheeled_m54_mg_02", "vn_i_air_ch34_02_01", "vn_i_air_ch34_01_02", "vn_i_air_ch34_02_02"};
        player_types[] = {"vn_b_men_sog_05", "vn_b_men_sog_17", "vn_b_men_army_08", "vn_o_men_nva_dc_13", "vn_o_men_nva_65_27", "vn_o_men_nva_65_13", "vn_o_men_nva_27", "vn_o_men_nva_13", "vn_o_men_nva_marine_13", "vn_o_men_nva_navy_13", "vn_o_men_vc_local_27", "vn_o_men_vc_local_13", "vn_o_men_vc_regional_13"};
        // Planes
        class aircraft
        {
                class he
                {
                        displayname = "High-Explosive";
                        class commando_vault
                        {
                                displayname = "Commando Vault";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_29tas_ca.paa";
                                description = "A 15,000-pound BLU-82 airdropped from a transport aircraft. Nicknamed 'Daisy Cutter' and known for it's ability to flatten a section of forest into a helicopter landing zone.";
                                function = "vn_fnc_artillery_commando_vault";
                                divergence = -45;
                                cooldown = (60*5);
                                cost = 50;
                        };
                        class arc_light
                        {
                                displayname = "Arc Light";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_69bs_ca.paa";
                                description = "Military bombing aircraft flying in the stratosphere drop a carpet bombing run of 20x 750lb M117 demolition bombs over the target area. Impossible to hear or spot from the ground, these aircraft devastate anything within range.";
                                function = "vn_fnc_artillery_arc_light";
                                divergence = 200;
                                cooldown = (60*5);
                                cost = 50;
                        };
                        class vespa
                        {
                                displayname = "Vespa";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "A fast strike of 2x Mk82 500lb bombs from an F-4 aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "B_Plane_CAS_01_dynamicLoadout_F";
                                cooldown = (60*5);
                                cost = 10;
                        };
                        class sundowner
                        {
                                displayname = "Sundowner";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_vf111_ca.paa";
                                description = "A strike of 2x BLU/1B Napalm bombs dropped from an F-4 aircraft. A heavy payload of 2x F-4 aircraft and 4x BLU/1B Napalm bombs is also avaliable.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "B_Plane_CAS_01_dynamicLoadout_F";
                                allow_double = 1;
                                cooldown = (60*5);
                                cost = 15;
                        };
                        class snake
                        {
                                displayname = "Snake";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "125mm high-explosive rockets fired from an F-4 aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "B_Plane_CAS_01_dynamicLoadout_F";
                                cooldown = (60*5);
                                cost = 10;
                        };
                        class showtime
                        {
                                displayname = "Showtime";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "20mm high-explosive Gunpod fired from an F-4 aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "B_Plane_CAS_01_dynamicLoadout_F";
                                cooldown = (60*5);
                                cost = 6;
                        };
                        class hobo
                        {
                                displayname = "Hobo";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1sos_ca.paa";
                                description = "Close air support provided by an A-1H aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "B_Plane_CAS_01_dynamicLoadout_F";
                                cooldown = (60*5);
                                cost = 6;
                        };
                        class condor
                        {
                                displayname = "Condor";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "14x Rockets 70mm high-explosive fired from a AH-1G aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                cooldown = (5*60);
                                cost = 6;
                        };
                        class blue_max
                        {
                                displayname = "Blue Max";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_1cav_ca.paa";
                                description = "302 M129 40mm high-explosive grenades fired from a AH-1G aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                cooldown = (5*60);
                                cost = 4;
                        };
                        class dragon
                        {
                                displayname = "Dragon";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a477_ca.paa";
                                description = "48x Rockets 70mm high-explosive fired from a UH-1C aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                cooldown = (5*60);
                                cost = 16;
                        };
                        class griffin_02
                        {
                                displayname = "Griffin";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_c477_ca.paa";
                                description = "M129 40mm high-explosive grenades fired from a UH-1C aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 3;
                        };
                };
                class cluster
                {
                        displayname = "Cluster Bombs";
                        class rambler
                        {
                                displayname = "Rambler";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_433tfs_ca.paa";
                                description = "2x 500lb Mk20 Rockeye cluster bombs fired from an F-4 aircraft. A heavy payload of 2x F-4 aircraft and 4x 500lb Mk20 Rockeye cluster bombs is also avaliable.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "B_Plane_CAS_01_dynamicLoadout_F";
                                allow_double = 1;
                                cost = 20;
                        };
                };
                class flechette
                {
                        displayname = "Flechette";
                        class combat
                        {
                                displayname = "Combat";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "70mm Flechette rockets fired from an F-4 aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "B_Plane_CAS_01_dynamicLoadout_F";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 8;
                        };
                        class banshee
                        {
                                displayname = "Banshee";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_29tas_ca.paa";
                                description = "70mm Flechette rockets fired from an AH-1G aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 6;
                        };
                        class scarface
                        {
                                displayname = "Scarface";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_vmo3_co.paa";
                                description = "70mm Flechette rockets fired from an UH-1C aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 12;
                        };
                };
                class heat
                {
                        displayname = "High-Explosive Anti-Tank";
                        class eagle_claw
                        {
                                displayname = "Eagle Claw";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_hml367_ca.paa";
                                description = "14x 70mm high-explosive anti-tank rockets fired from an AH-1G aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 6;
                        };
                };
                class minigun
                {
                        displayname = "Minigun";
                        class hawk
                        {
                                displayname = "Hawk";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_d101_ca.paa";
                                description = "2x Miniguns fired from a AH-1G aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 4;
                        };
                        class griffin
                        {
                                displayname = "Griffin";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_c477_ca.paa";
                                description = "M195 20mm Vulcan fired from a AH-1G aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 6;
                        };
                        class toro
                        {
                                displayname = "Toro";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_c477_ca.paa";
                                description = "M134 minigun fired from a AH-1G aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 2;
                        };
                        class croc
                        {
                                displayname = "Croc";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_g119_ca.paa";
                                description = "Twin miniguns fired from a UH-1C aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 4;
                        };
                        class green_hornet
                        {
                                displayname = "Green Hornet";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_20sos_ca.paa";
                                description = "Twin M134 miniguns fired from a UH-1F aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = (5*60);
                                cost = 2;
                        };
                };
                class illumination
                {
                        displayname = "Illumination";
                        class gnat
                        {
                                displayname = "Gnat";
                                icon = "vn\ui_f_vietnam\data\decals\vn_callsign_src_a101_ca.paa";
                                description = "Illumination flares dropped from a UH-1D aircraft.";
                                magazines[] = {"vn_missile_agm45_mag_x1"};
                                vehicleclass = "vn_air_ah1g_01";
                                allow_double = 1;
                                cooldown = 0;
                                illumination = 1;
                                cost = 0;
                        };
                };
        };
        class artillery
        {
                class illumination
                {
                        displayname = "Illumination";
                        class baker_1
                        {
                                displayname = "Baker 1";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "4x M314 105mm Illumination flares fired from a M-101 105mm Howitzer battery. Illumination lasts 3 minutes.";
                                ammo[] = {"vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo"};
                                allow_double = 1;
                                cooldown = (0);
                                divergence = 150;
                                count = 1;
                                illumination = 1;
                        };
                        class mike_1
                        {
                                displayname = "Mike 1";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "6x M301 81mm Illumination flares fired from a M29 81mm mortar battery. Illumination lasts 4.5 minutes.";
                                ammo[] = {"vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo"};
                                allow_double = 1;
                                cooldown = (0);
                                divergence = 150;
                                count = 1;
                                illumination = 1;
                        };
                        class easy_1
                        {
                                displayname = "Easy 1";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "8x M38 60mm Illumination flares fired from a M2 60mm mortar battery. Illumination lasts 6 minutes.";
                                ammo[] = {"vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo","vn_flare_plane_med_w_ammo"};
                                allow_double = 1;
                                cooldown = (0);
                                divergence = 150;
                                count = 1;
                                illumination = 1;
                        };
                };
                class wp
                {
                        displayname = "White Phosphorus";
                        class baker_2
                        {
                                displayname = "Baker 2";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "4x M60 105mm White Phosphorus rounds fired from a M-101 105mm Howitzer battery.";
                                ammo[] = {"vn_shell_105mm_m60_wp_ammo","vn_shell_105mm_m60_wp_ammo","vn_shell_105mm_m60_wp_ammo","vn_shell_105mm_m60_wp_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 10;
                        };
                        class mike_2
                        {
                                displayname = "Mike 2";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "6x M57 81mm White Phosphorus rounds fired from a M29 81mm mortar battery.";
                                ammo[] = {"vn_shell_81mm_m57_wp_ammo","vn_shell_81mm_m57_wp_ammo","vn_shell_81mm_m57_wp_ammo","vn_shell_81mm_m57_wp_ammo","vn_shell_81mm_m57_wp_ammo","vn_shell_81mm_m57_wp_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 8;
                        };
                        class easy_2
                        {
                                displayname = "Easy 2";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "8x M302 60mm White Phosphorus rounds fired from a M2 60mm mortar battery.";
                                ammo[] = {"vn_shell_60mm_m302_wp_ammo","vn_shell_60mm_m302_wp_ammo","vn_shell_60mm_m302_wp_ammo","vn_shell_60mm_m302_wp_ammo","vn_shell_60mm_m302_wp_ammo","vn_shell_60mm_m302_wp_ammo","vn_shell_60mm_m302_wp_ammo","vn_shell_60mm_m302_wp_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 4;
                        };
                };
                class he
                {
                        displayname = "High-Explosive";
                        class baker_3
                        {
                                displayname = "Baker 3";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "4x M1 105mm High-Explosive rounds fired from a M-101 105mm Howitzer battery.";
                                ammo[] = {"vn_shell_105mm_m1_he_ammo","vn_shell_105mm_m1_he_ammo","vn_shell_105mm_m1_he_ammo","vn_shell_105mm_m1_he_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 16;
                        };
                        class mike_3: baker_3
                        {
                                displayname = "Mike 3";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "6x M43 81mm High-Explosive rounds fired from a M29 81mm mortar battery.";
                                ammo[] = {"vn_shell_81mm_m43_he_ammo","vn_shell_81mm_m43_he_ammo","vn_shell_81mm_m43_he_ammo","vn_shell_81mm_m43_he_ammo","vn_shell_81mm_m43_he_ammo","vn_shell_81mm_m43_he_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 12;
                        };
                        class easy_3: baker_3
                        {
                                displayname = "Easy 3";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "8x M49A2 60mm High-Explosive rounds fired from a M2 60mm mortar battery.";
                                ammo[] = {"vn_shell_60mm_m49a2_he_ammo","vn_shell_60mm_m49a2_he_ammo","vn_shell_60mm_m49a2_he_ammo","vn_shell_60mm_m49a2_he_ammo","vn_shell_60mm_m49a2_he_ammo","vn_shell_60mm_m49a2_he_ammo","vn_shell_60mm_m49a2_he_ammo","vn_shell_60mm_m49a2_he_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 8;
                        };
                };
                class chemical
                {
                        displayname = "Chemical";
                        class baker_4
                        {
                                displayname = "Baker 4";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "4x M60 105mm Chemical rounds fired from a M-101 105mm Howitzer battery.";
                                ammo[] = {"vn_shell_105mm_m60_chem_ammo","vn_shell_105mm_m60_chem_ammo","vn_shell_105mm_m60_chem_ammo","vn_shell_105mm_m60_chem_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 8;
                        };
                        class mike_4: baker_4
                        {
                                displayname = "Mike 4";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "6x M57 81mm Chemical rounds fired from a M29 81mm mortar battery.";
                                ammo[] = {"vn_shell_81mm_m57_fs_ammo","vn_shell_81mm_m57_fs_ammo","vn_shell_81mm_m57_fs_ammo","vn_shell_81mm_m57_fs_ammo","vn_shell_81mm_m57_fs_ammo","vn_shell_81mm_m57_fs_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 6;
                        };
                };
                class frag
                {
                        displayname = "Fragmentation";
                        class baker_5
                        {
                                displayname = "Baker 5";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "4x M546 105mm Fragmentation rounds fired from a M-101 105mm Howitzer battery.";
                                ammo[] = {"vn_shell_105mm_m546_frag_ammo","vn_shell_105mm_m546_frag_ammo","vn_shell_105mm_m546_frag_ammo","vn_shell_105mm_m546_frag_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 8;
                        };
                };
                class airburst
                {
                        displayname = "Airburst";
                        class baker_6
                        {
                                displayname = "Baker 6";
                                //icon = "vn\ui_f_vietnam\data\decals\";
                                description = "4x M1 105mm Airburst rounds fired from a M-101 105mm Howitzer battery.";
                                ammo[] = {"vn_shell_105mm_m1_ab_ammo","vn_shell_105mm_m1_ab_ammo","vn_shell_105mm_m1_ab_ammo","vn_shell_105mm_m1_ab_ammo"};
                                allow_double = 1;
                                cooldown = (60*5);
                                divergence = 50;
                                count = 1;
                                cost = 16;
                        };
                };
        };
};
