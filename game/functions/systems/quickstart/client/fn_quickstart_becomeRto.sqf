/*
    File: fn_quickstart_becomeRto.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-04-01
    Public: No

    Description:
        Instantly sets the player up as an RTO, using a preset loadout and skill set.

    Parameter(s):
    	None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_quickstart_becomeRto;
 */

private _loadout = [
    ["vn_xm177_camo","","","vn_o_4x_m16",["vn_m16_20_t_mag",18],[],""],
    [],
    ["vn_hd","","","",["vn_hd_mag",10],[],""],
    ["vn_b_uniform_sog_02_04",[["vn_helper_item_firstaidkit",8],["vn_m16_20_t_mag",2,18]]],
    ["vn_b_vest_sog_06",[["vn_mine_m14_mag",19,1],["vn_m16_20_t_mag",8,18],["vn_hd_mag",4,10],["vn_m61_grenade_mag",3,1],["vn_mine_m18_mag",2,1]]],
    ["vn_b_pack_lw_06",[["vn_helper_item_firstaidkit",2],["vn_m61_grenade_mag",5,1],["vn_mine_satchel_remote_02_mag",3,1],["vn_mine_m14_mag",31,1],["vn_m16_20_t_mag",6,18],["vn_hd_mag",2,10],["vn_m34_grenade_mag",2,1]]],
    "vn_b_boonie_04_04",
    "",
    ["vn_m19_binocs_grn","","","",[],[],""],
    ["vn_b_item_map","","vn_b_item_radio_urc10","vn_b_item_compass","vn_b_item_watch",""]
];

private _skills = [["rto","training_rto"],["rto","emergency_radio"],["rto","cas_fast_mover_level_1"],["rto","cas_fast_mover_level_2"],["rto","cas_fast_mover_level_3"],["rto","cas_gunship_level_3"],["rto","cas_gunship_level_2"],["rto","cas_gunship_level_1"],["rto","fireship"],["rto","shadow"],["rto","long_antenna"],["rto","strobe_marker"],["rto","cas_fast_mover_level_4"],["rto","cas_gunship_level_4"],["combat","ammoPouch"],["combat","noRestraint"],["combat","bulletHose"],["combat","shootAndScoot"]];

[_loadout, _skills] call vgm_c_fnc_quickstart_setLoadoutAndSkills;
