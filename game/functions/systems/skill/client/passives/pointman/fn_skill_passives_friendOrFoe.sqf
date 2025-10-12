/*
    File: fn_skill_passives_friendOrFoe.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2025-10-12
    Public: No

    Description:
        When known, increases the spot time while the player is wearing enemy headgear.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_senseOfScale
 */

params ["_known"];

if (!_known) exitWith {
    removeMissionEventHandler ["EachFrame", vgm_c_skill_passives_friendOrFoeEh];
    [player, "stealthSpotTimeMultiplier", "skill_passives_friendOrFoe"] call vgm_c_fnc_coefficient_remove;
};

vgm_c_skill_passives_friendOrFoe_lastHeadgear = "";

private _ehId = addMissionEventHandler ["EachFrame", {
    private _headgear = headgear player;
    if (_headgear isEqualTo vgm_c_skill_passives_friendOrFoe_lastHeadgear) exitWith {};
    vgm_c_skill_passives_friendOrFoe_lastHeadgear = _headgear;

    if !("vn_o_" in _headgear || "vnx_o_" in _headgear || _headgear isEqualTo "vn_b_helmet_sog_01") exitWith {
        [player, "stealthSpotTimeMultiplier", "skill_passives_friendOrFoe"] call vgm_c_fnc_coefficient_remove;
    };

    // +3 results in a spot time 4x the original. When making changes to this, please check how balanced it is in-game.
    [player, "stealthSpotTimeMultiplier", "skill_passives_friendOrFoe", +3, true] call vgm_c_fnc_coefficient_set;
}];

vgm_c_skill_passives_friendOrFoeEh = _ehId;
