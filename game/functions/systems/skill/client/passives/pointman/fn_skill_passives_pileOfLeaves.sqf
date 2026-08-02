/*
    File: fn_skill_passives_pileOfLeaves.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Hiding bodies delays enemy alert. Adds a "Hide Body" action on dead
        enemy units. When used, the body is hidden and the associated alertness
        increase is suppressed. Also adds a "Booby Trap Body" action that
        consumes a hand grenade and rigs the body as bait — when OPFOR
        investigate, the trap detonates.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_pileOfLeaves
 */

#define HIDE_DURATION 3
#define TRAP_DURATION 4

params ["_known"];

if (!_known) exitWith {
    // Remove any stacked handlers (applyOnRespawn can re-register before the old one is cleaned)
    if (!isNil "vgm_c_skill_passives_pileOfLeaves_killedEh") then {
        removeMissionEventHandler ["EntityKilled", vgm_c_skill_passives_pileOfLeaves_killedEh];
    };
    player setVariable ["vgm_c_skill_pileOfLeaves_active", false];
};

player setVariable ["vgm_c_skill_pileOfLeaves_active", true];

// When an enemy is killed nearby, add "Hide Body" and "Booby Trap Body" actions
vgm_c_skill_passives_pileOfLeaves_killedEh = addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator"];

    // Guard: skill must be active (prevents stale handlers from leaking)
    if !(player getVariable ["vgm_c_skill_pileOfLeaves_active", false]) exitWith {};

    // Only for enemy infantry
    if (!(_unit isKindOf "CAManBase")) exitWith {};
    if (side _unit == side player) exitWith {};
    if (player distance _unit > 100) exitWith {};

    // --- Hide Body ---
    [
        _unit,
        localize "STR_VGM_SKILLS_SKILL_PILE_OF_LEAVES_ACTION",
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
        "_this distance _target < 3 && !(_target getVariable [""vgm_g_bodyActionTaken"", false])",
        "_caller distance _target < 3",
        {},
        {},
        {
            params ["_target", "_caller"];

            _target setVariable ["vgm_g_bodyActionTaken", true, true];

            // Hide the body
            [_target, true] remoteExec ["hideObjectGlobal", 2];
            [_target, false] remoteExec ["enableSimulationGlobal", 2];

            // Notify server to suppress alertness from this kill
            [_target] remoteExecCall ["vgm_s_fnc_skill_pileOfLeaves_hideBody", 2];

            format ["Pile of Leaves: Body hidden by %1", name _caller] call vgm_g_fnc_logInfo;
        },
        {},
        [],
        HIDE_DURATION,
        0,
        true,
        false
    ] call BIS_fnc_holdActionAdd;

    // --- Booby Trap Body ---
    [
        _unit,
        localize "STR_VGM_SKILLS_SKILL_PILE_OF_LEAVES_TRAP_ACTION",
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff_ca.paa",
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff_ca.paa",
        "_this distance _target < 3 && !(_target getVariable [""vgm_g_bodyActionTaken"", false])",
        "_caller distance _target < 3",
        {},
        {},
        {
            params ["_target", "_caller"];

            // Check for a hand grenade
            private _grenadeTypes = [
                "vn_m61_grenade_mag",
                "vn_m67_grenade_mag",
                "vn_m34_grenade_mag",
                "vn_v40_grenade_mag",
                "vn_m14_grenade_mag",
                "vn_m14_early_grenade_mag"
            ];
            private _playerMags = magazines _caller;
            private _grenade = "";
            {
                if (_x in _playerMags) exitWith { _grenade = _x; };
            } forEach _grenadeTypes;

            if (_grenade isEqualTo "") exitWith {
                hint localize "STR_VGM_SKILLS_SKILL_PILE_OF_LEAVES_TRAP_NEED_GRENADE";
            };

            // Consume the grenade
            _caller removeMagazine _grenade;

            // Lock out the other action
            _target setVariable ["vgm_g_bodyActionTaken", true, true];

            // Tell server to start the monitor
            [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_pileOfLeaves_boobyTrap", 2];

            hint localize "STR_VGM_SKILLS_SKILL_PILE_OF_LEAVES_TRAP_DONE";
            format ["Pile of Leaves: Body booby-trapped by %1", name _caller] call vgm_g_fnc_logInfo;
        },
        {},
        [],
        TRAP_DURATION,
        0,
        true,
        false
    ] call BIS_fnc_holdActionAdd;
}];
