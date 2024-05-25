/*
    File: fn_skill_passives_preInit.sqf
    Author: Savage Game Design
    Date: 2023-09-14
    Last Update: 2023-09-24
    Public: No

    Description:
        Client preInit function for skill passives implementations.
 */

if (!hasInterface) exitWith {};

["vgm_mission_deploy_local", {
    params ["_mission"];

    format ["Applying Rifleman/Born Leader for mission: %1", _mission] call vgm_g_fnc_logDebug;

    private _group = _mission get "group";

    private _fnc_onUnitJoined = {
        params ["", "_unit"];
        if (_unit getVariable ["vgm_g_skill_actives_bornLeader", false]) then {
            format ["Rifleman/Born Leader player in mission: %1", getPlayerID _unit] call vgm_g_fnc_logDebug;

            [player, "skillCooldown", format ["skill_born_leader_%1", getPlayerId _unit], -0.2] call vgm_c_fnc_coefficient_set;
        };
    };
    private _fnc_onUnitLeft = {
        params ["", "_unit"];
        [player, "skillCooldown", format ["skill_born_leader_%1", getPlayerId _unit]] call vgm_c_fnc_coefficient_remove;
    };

    // apply retroactively for players in the group
    {[nil, _x] call _fnc_onUnitJoined} forEach units _group;

    _group addEventHandler ["UnitJoined", _fnc_onUnitJoined];
    _group addEventHandler ["UnitLeft", _fnc_onUnitLeft];

}] call para_g_fnc_event_subscribeLocal;
