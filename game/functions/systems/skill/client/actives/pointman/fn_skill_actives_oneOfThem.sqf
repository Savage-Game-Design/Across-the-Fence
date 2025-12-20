/*
    File: fn_skill_actives_oneOfThem.sqf
    Author: Savage Game Design
    Date: 2025-08-18
    Last Update: 2025-12-14
    Public: No

    Description:
        Prevents the player being spotted by enemies when:
        - They're wearing an enemy helmet
        - Walking
        - Not already detected by the enemy

    Parameter(s):
        _isActive - If skill should be activated or detactivated [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        [true] call vgm_c_fnc_skill_actives_oneOfThem
 */

params ["_isActive"];

if (!_isActive) exitWith {
    removeMissionEventHandler ["EachFrame", vgm_c_skill_actives_oneOfThemEh];
    [player, "stealthUndetectable", "skill_actives_oneOfThem"] call vgm_c_fnc_statusEffect_remove;
};

vgm_c_skill_actives_oneOfThem_lastState = [];

private _ehId = addMissionEventHandler ["EachFrame", {
    private _isWalking = animationState player select [9, 3] in ["wlk", "stp"];
    private _headgear = headgear player;
    private _state = [_isWalking, _headgear];

    if (_state isEqualTo vgm_c_skill_actives_oneOfThem_lastState) exitWith {};
    vgm_c_skill_actives_oneOfThem_lastState = _state;

    private _wearingEnemyHeadgear = "vn_o_" in _headgear || "vnx_o_" in _headgear || _headgear isEqualTo "vn_b_helmet_sog_01";

    if (_isWalking && _wearingEnemyHeadgear) exitWith {
        [player, "stealthUndetectable", "skill_actives_oneOfThem"] call vgm_c_fnc_statusEffect_set;
    };

    [player, "stealthUndetectable", "skill_actives_oneOfThem"] call vgm_c_fnc_statusEffect_remove;
}];

vgm_c_skill_actives_oneOfThemEh = _ehId;
