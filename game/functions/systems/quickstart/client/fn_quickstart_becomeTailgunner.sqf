/*
    File: fn_quickstart_becomeTailgunner.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-04-01
    Public: No

    Description:
        Instantly sets the player up as a tailgunner, using a preset loadout and skill set.

    Parameter(s):
    	None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_quickstart_becomeTailgunner;
 */

private _loadout = [
    ["vn_m16_camo","vn_s_m16","","",["vn_m16_20_t_mag",18],[],""],
    [],
    ["vn_m79_p","","","",["vn_40mm_m381_he_mag",1],["vn_40mm_m576_buck_mag",1],""],
    ["vn_b_uniform_sog_02_06",[["vn_helper_item_firstaidkit",8],["vn_b_item_toolkit_weightless",1],["vn_m16_20_t_mag",2,18]]],
    ["vn_b_vest_sog_03",[["vn_mine_m14_mag",42,1],["vn_m61_grenade_mag",2,1],["vn_40mm_m381_he_mag",3,1],["vn_m16_20_t_mag",4,18]]],
    ["vn_b_pack_trp_03",[["vn_helper_item_firstaidkit",2],["vn_m61_grenade_mag",4,1],["vn_mine_satchel_remote_02_mag",1,1],["vn_mine_m14_mag",20,1],["vn_m34_grenade_mag",2,1],["vn_m16_20_t_mag",10,18],["vn_40mm_m381_he_mag",10,1],["vn_mine_m18_wp_mag",3,1]]],
    "vn_b_boonie_02_09",
    "",
    ["vn_camera_01","","","",[],[],""],
    ["vn_b_item_map","","vn_b_item_radio_urc10","vn_b_item_compass","vn_b_item_watch",""]
];

private _skills = [["combat","specialisation_rifleman"],["combat","field_modification_1"],["combat","field_modification_2"],["combat","stablePlatform"],["combat","strongHands"],["combat","ammoPouch"],["combat","noRestraint"],["combat","grassCutter"],["combat","reconByFire"],["combat","chemical_grenades"],["combat","loadedForBear"],["combat","battleFocus"],["combat","steelRain"],["medic","keep_calm"],["pointman","ground_sign"],["pointman","in_the_zone"]];

[_loadout, _skills] call vgm_c_fnc_quickstart_setLoadoutAndSkills;
