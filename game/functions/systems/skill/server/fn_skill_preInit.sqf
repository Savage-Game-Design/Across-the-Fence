/*
    File: fn_skill_passives_preInit.sqf
    Author: Savage Game Design
    Date: 2023-09-24
    Last Update: 2023-10-07
    Public: No

    Description:
        Server preInit function for skill implementations.
 */

if (!isServer) exitWith {};

// TODO we could consider moving this to some AI related component later on
addMissionEventHandler ["EntityCreated", {
    params ["_unit"];
    if (
        !(_unit isKindOf "CAManBase")
        || {side _unit isEqualTo side vgm_core_lobbyGroup}
    ) exitWith {};

    _unit addEventHandler ["Suppressed", {
        params ["_unit"];

        call vgm_s_skill_relaySuppression;
        call vgm_s_skill_multiplySuppression;

        _unit setVariable ["vgm_s_skill_lastSuppression", getSuppression _unit];
    }];
}];

vgm_s_skill_relaySuppression = {
    params ["_unit", "", "_shooter"];

    private _threats = _unit getVariable "vgm_s_skill_threats";
    if (
        !(_shooter getVariable ["vgm_g_skill_passives_recon_followTheTracers", false])
        || {_shooter in _threats}
    ) exitWith {};

    if (isNil "_threats") then {
        _threats = [];
        _unit setVariable ["vgm_s_skill_threats", _threats];

        // TODO make this unscheduled
        [_threats, _unit] spawn {
            params ["_threats", "_unit"];
            waitUntil {getSuppression _unit <= 0};
            isNil { // make array clear and event send atomic
                _unit setVariable ["vgm_s_skill_threats", nil];
                // send event to all players that suppressed the unit
                ["vgm_unit_suppressEnd", _unit, _threats] call para_g_fnc_event_triggerTargets;
            };
        };
    };

    _threats pushBack _shooter;
    ["vgm_unit_suppressStart", _unit, _shooter] call para_g_fnc_event_triggerTargets;
};

vgm_s_skill_multiplySuppression = {
    params ["_unit", "", "_shooter"];

    if (
        !(_shooter getVariable ["vgm_g_skill_passives_fireSupport_heavySuppresion", false])
    ) exitWith {};

    private _lastSuppression = _unit getVariable ["vgm_s_skill_lastSuppression", 0];
    private _currentSuppression = getSuppression _unit;
    // the first shot after suppression faded down below saved value will be ignored
    // otherwise it would cause negative "gain"
    if (_currentSuppression < _lastSuppression) exitWith {};

    private _gainedSupression = _currentSuppression - _lastSuppression;
    _unit setSuppression (_currentSuppression + (_gainedSupression / 2));
};
