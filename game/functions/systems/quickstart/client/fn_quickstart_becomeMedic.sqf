/*
    File: fn_quickstart_becomeMedic.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-04-01
    Public: No

    Description:
        Instantly sets the player up as a medic, using a preset loadout and skill set.

    Parameter(s):
    	None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_quickstart_becomeMedic;
 */

private _loadout = [
    ["vn_xm177_stock_camo","","","",["vn_m16_20_t_mag",18],[],""],
    [],
    ["vn_hd","","","",["vn_hd_mag",10],[],""],
    ["vn_b_uniform_sog_02_01",[["vn_helper_item_medikit",1],["vn_m16_20_t_mag",2,18],["vn_m61_grenade_mag",3,1],["vn_m34_grenade_mag",1,1]]],
    ["vn_b_vest_sog_02",[["vn_mine_m14_mag",10,1],["vn_hd_mag",4,10],["vn_m16_20_t_mag",4,18],["vn_mine_m18_range_mag",3,1],["vn_m18_purple_mag",3,1]]],
    ["vn_b_pack_trp_02",[["vn_m61_grenade_mag",8,1],["vn_mine_satchel_remote_02_mag",1,1],["vn_mine_m14_mag",10,1],["vn_hd_mag",8,10],["vn_m34_grenade_mag",3,1],["vn_m16_20_t_mag",10,18],["vn_m7_grenade_mag",5,1]]],
    "vn_b_headband_01",
    "",
    ["vn_camera_01","","","",[],[],""],
    ["vn_b_item_map","","vn_b_item_radio_urc10","vn_b_item_compass","vn_b_item_watch",""]
];

private _skills = [["medic","training_medic"],["medic","combat_doc_1"],["medic","combat_doc_2"],["medic","he_aint_heavy"],["medic","combat_doc_3"],["medic","ive_seen_worse"],["medic","green_hornet_pack"],["medic","combat_doc_4"],["medic","pack_the_wound"],["medic","its_only_a_flesh_wound"],["combat","specialisation_rifleman"],["medic","green_hornet"],["combat","strongHands"],["combat","ammoPouch"],["combat","stablePlatform"],["combat","grassCutter"],["medic","keep_calm"],["combat","noRestraint"]];

[_loadout, _skills] call vgm_c_fnc_quickstart_setLoadoutAndSkills;
