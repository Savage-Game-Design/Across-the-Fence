/*
    File: fn_quickstart_becomePointman.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-04-01
    Public: No

    Description:
        Instantly sets the player up as a pointman, using a preset loadout and skill set.

    Parameter(s):
    	None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_quickstart_becomePointman;
 */

private _loadout = [
    ["vn_m45_camo","vn_s_m45_camo","","",["vn_m45_t_mag",36],[],""],
    [],
    ["vn_m79_p","","","",["vn_40mm_m381_he_mag",1],["vn_40mm_m576_buck_mag",1],""],
    ["vn_b_uniform_sog_01_03",[["vn_helper_item_firstaidkit",6],["vn_b_item_trapkit",1],["vn_m45_t_mag",1,36]]],
    ["vn_b_vest_sog_04",[["vn_b_item_toolkit_weightless",1],["vn_mine_m14_mag",15,1],["vn_m61_grenade_mag",3,1],["vn_m45_t_mag",4,36],["vn_40mm_m381_he_mag",12,1]]],
    ["vn_b_pack_04",[["vn_helper_item_firstaidkit",4],["vn_m61_grenade_mag",4,1],["vn_mine_satchel_remote_02_mag",1,1],["vn_m34_grenade_mag",3,1],["vn_m45_t_mag",12,36],["vn_mine_m18_range_mag",3,1],["vn_40mm_m381_he_mag",6,1]]],
    "vn_b_helmet_sog_01",
    "",
    ["vn_camera_01","","","",[],[],""],
    ["vn_b_item_map","","vn_b_item_radio_urc10","vn_b_item_compass","vn_b_item_watch",""]
];

private _skills = [["pointman","training_pointman"],["pointman","in_the_zone"],["pointman","taking_notes"],["pointman","stones_throw"],["pointman","clear_lens"],["pointman","friend_or_foe"],["pointman","tactical_sense"],["pointman","ground_sign"],["combat","specialisation_scout"],["teamLeader","fire_direction"],["combat","strongHands"],["combat","ammoPouch"],["combat","stablePlatform"],["combat","grassCutter"],["combat","loadedForBear"],["medic","keep_calm"],["medic","green_hornet"]];

[_loadout, _skills] call vgm_c_fnc_quickstart_setLoadoutAndSkills;
