/*
    File: fn_skill_passives_ronCall.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-06
    Public: No

    Description:
        Remain Overnight (RON) perk for Team Leaders.
        Adds a wheel menu action (key 6) that initiates a RON vote among
        all players. Available only at night while on mission.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_ronCall
 */

params ["_known"];

if (!hasInterface) exitWith {};

if (!_known) exitWith {
    // Remove the wheel menu action if it was added
    private _idx = player getVariable ["vgm_c_skill_ronCall_wheelIdx", -1];
    if (_idx >= 0) then {
        para_c_wheel_menu_actions_always deleteAt _idx;
        player setVariable ["vgm_c_skill_ronCall_wheelIdx", -1];
    };
};

// Add wheel menu action for RON
private _action = createHashMapFromArray [
    ["condition", {
        vgm_mission_onMission
        && {leader player == player}
        && {!( missionNamespace getVariable ["vgm_s_ron_active", false])}
        && {!( missionNamespace getVariable ["vgm_s_ron_voteInProgress", false])}
        && {
            private _hour = date select 3;
            private _time = _hour + ((date select 4) / 100);
            _time >= 18 || _time < 5.15
        }
    }],
    ["iconPath", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa"],
    ["function", "vgm_c_fnc_ron_trigger"],
    ["text", localize "STR_VGM_RON_ACTION"],
    ["spawnFunction", true]
];

private _idx = count para_c_wheel_menu_actions_always;
para_c_wheel_menu_actions_always pushBack _action;
player setVariable ["vgm_c_skill_ronCall_wheelIdx", _idx];
