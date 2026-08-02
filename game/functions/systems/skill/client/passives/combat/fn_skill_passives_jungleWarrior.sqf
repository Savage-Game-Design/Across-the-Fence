/*
    File: fn_skill_passives_jungleWarrior.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        When known, canteens restore stamina.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_jungleWarrior
 */

params ["_known"];

if (!_known) exitWith {
    player removeAction (player getVariable ["vgm_c_skill_jungleWarrior_canteenAction", -1]);
    player setVariable ["vgm_c_skill_jungleWarrior_canteenAction", -1];
};

// Canteen action - restores stamina, consumes one canteen from inventory
private _canteenAction = player addAction [
    localize "STR_VGM_SKILLS_SKILL_JUNGLE_WARRIOR_ACTION_CANTEEN",
    {
        params ["_target", "_caller"];

        // Find first canteen in inventory
        // Check items first, then magazines (canteen classification varies)
        private _idx = (items _caller) findIf {_x == "vn_prop_drink_04"};
        if (_idx == -1) then {_idx = (magazines _caller) findIf {_x == "vn_prop_drink_04"}};
        if (_idx == -1) exitWith {};

        _caller removeItem "vn_prop_drink_04";
        _caller removeMagazine "vn_prop_drink_04";
        _caller setFatigue 0;

        format ["Jungle Warrior: Canteen used by %1", name _caller] call vgm_g_fnc_logInfo;
    },
    [],
    1.5,
    false,
    true,
    "",
    "'vn_prop_drink_04' in (items _target + magazines _target)",
    5
];
player setVariable ["vgm_c_skill_jungleWarrior_canteenAction", _canteenAction];
