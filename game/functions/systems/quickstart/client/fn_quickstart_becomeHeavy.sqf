/*
    File: fn_quickstart_becomeHeavy.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-05-09
    Public: No

    Description:
        Instantly sets the player up as a heavy, using a preset loadout and skill set.

    Parameter(s):
    	None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_quickstart_becomeHeavy;
 */

private _loadout = [
    ["vn_rpd_shorty_01","","","",["vn_rpd_125_mag",125],[],""],
    [],
    ["vn_m1911","vn_s_m1911","","",["vn_m1911_mag",7],[],""],
    ["vn_b_uniform_sog_01_04",[["vn_helper_item_firstaidkit",7],["vn_m1911_mag",4,7]]],
    ["vn_b_vest_sog_05",[["vn_m61_grenade_mag",2,1],["vn_rpd_125_mag",3,125],["vn_mine_m14_mag",1,1]]],
    ["vn_b_pack_02",[["vn_helper_item_firstaidkit",3],["vn_m61_grenade_mag",4,1],["vn_m1911_mag",8,7],["vn_mine_m14_mag",15,1],["vn_m34_grenade_mag",2,1],["vn_rpd_125_mag",3,125],["vn_mine_m18_wp_mag",1,1]]],
    "vn_b_boonie_09_09",
    "",
    ["vn_camera_01","","","",[],[],""],
    ["vn_b_item_map","","vn_b_item_radio_urc10","vn_b_item_compass_sog","vn_b_item_watch",""]
];

private _skills = [["combat","specialisation_machinegunner"],["combat","strongHands"],["combat","ammoPouch"],["combat","noRestraint"],["combat","grassCutter"],["combat","treeCutter"],["combat","reconByFire"],["combat","loadedForBear"],["combat","stablePlatform"],["combat","battleFocus"],["combat","field_modification_1"],["combat","field_modification_2"],["combat","field_modification_3"],["pointman","ground_sign"],["medic","training_medic"],["medic","keep_calm"],["medic","he_aint_heavy"],["medic","green_hornet"],["medic","leg_pockets"],["combat","field_modification_4"]];

[_loadout, _skills] call vgm_c_fnc_quickstart_setLoadoutAndSkills;
