/*
    File: fn_quickstart_becomeTeamLeader.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-05-09
    Public: No

    Description:
        Instantly sets the player up as a team leader, using a preset loadout and skill set.

    Parameter(s):
    	None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_quickstart_becomeTeamLeader;
 */

private _loadout = [
    ["vn_xm177_m203_camo","","","",["vn_m16_20_t_mag",18],["vn_40mm_m381_he_mag",1],""],
    [],
    ["vn_hp","vn_s_hp","","",["vn_hp_mag",13],[],""],
    ["vn_b_uniform_sog_02_04",[["vn_helper_item_firstaidkit",8],["vn_b_item_toolkit_weightless",1],["vn_m16_20_t_mag",2,18]]],
    ["vn_b_vest_sog_01",[["vn_m67_grenade_mag",3,1],["vn_mine_m14_mag",6,1],["vn_mine_m18_wp_range_mag",2,1],["vn_hp_mag",5,13],["vn_40mm_m381_he_mag",10,1],["vn_m16_20_t_mag",5,18]]],
    ["vn_b_pack_01",[["vn_helper_item_firstaidkit",2],["vn_mine_m18_fuze10_mag",2,1],["vn_m67_grenade_mag",4,1],["vn_mine_m14_mag",14,1],["vn_hp_mag",1,13],["vn_40mm_m381_he_mag",39,1],["vn_m16_20_t_mag",7,18]]],
    "vn_b_bandana_04",
    "",
    ["vn_camera_01","","","",[],[],""],
    ["vn_b_item_map","","vn_b_item_radio_urc10","vn_b_item_compass_sog","vn_b_item_watch",""]
];

private _skills = [["teamLeader","training_team_leader"],["teamLeader","fire_direction"],["teamLeader","kickoff_time"],["teamLeader","sanctuary"],["teamLeader","ditch_rucks"],["teamLeader","get_it_together"],["teamLeader","team_awareness"],["teamLeader","rally_point"],["teamLeader","roll_call"],["teamLeader","one_team"],["pointman","ground_sign"],["pointman","sense_of_scale"],["pointman","clear_lens"],["combat","specialisation_grenadier"]];

[_loadout, _skills] call vgm_c_fnc_quickstart_setLoadoutAndSkills;
