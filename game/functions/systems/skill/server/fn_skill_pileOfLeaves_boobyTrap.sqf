/*
    File: fn_skill_pileOfLeaves_boobyTrap.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for the Pile of Leaves booby-trap action.
        Marks the body as trapped, awards setup XP, then spawns a monitor
        loop that:
          Phase 1 (25m) — fires a player_distraction locEvent once to lure
                          nearby OPFOR to investigate the body.
          Phase 2 (3m)  — detonates a grenade explosion when OPFOR reach
                          the body, killing/wounding investigators.

    Parameter(s):
        _body   - The dead enemy unit rigged as bait [OBJECT]
        _caller - The player who set the trap [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_pileOfLeaves_boobyTrap", 2]
 */

if (!isServer) exitWith {};

params ["_body", "_caller"];

_body setVariable ["vgm_g_boobyTrapped", true, true];

// Award XP for setting the trap
[_caller, 25] call vgm_s_fnc_leveling_addExperience;

format ["Pile of Leaves: %1 booby-trapped body %2 at %3", name _caller, typeOf _body, getPos _body] call vgm_g_fnc_logInfo;

// --- Monitor loop ---
[_body, _caller] spawn {
    params ["_body", "_caller"];

    private _pos = getPosATL _body;
    private _investigationSent = false;

    while {!isNull _body} do {
        sleep 3;
        if (isNull _body) exitWith {};

        private _pos = getPosATL _body;

        // Phase 1 — Lure (25m radius, fires once)
        if (!_investigationSent) then {
            private _nearby = _pos nearEntities ["CAManBase", 25];
            private _opfor = _nearby select {side _x == east && alive _x};

            if (count _opfor > 0) then {
                private _nearest = _opfor select 0;
                private _eventGroup = (group _nearest) getVariable ["vgm_g_missionId", "dangerReports"];

                [
                    _eventGroup,
                    AGLtoASL _pos,
                    50,
                    "player_distraction",
                    []
                ] call vgm_g_fnc_locEvents_triggerEvent;

                _investigationSent = true;
                format ["Pile of Leaves Trap: Lure fired at %1 (event group: %2)", _pos, _eventGroup] call vgm_g_fnc_logInfo;
            };
        };

        // Phase 2 — Detonation (3m radius)
        private _close = _pos nearEntities ["CAManBase", 3];
        private _opforClose = _close select {side _x == east && alive _x};

        if (count _opforClose > 0) exitWith {
            // Detonate
            "vn_m61_grenade_ammo" createVehicle (_pos vectorAdd [0, 0, 0.3]);

            // Award kill XP
            [_caller, 50] call vgm_s_fnc_leveling_addExperience;

            deleteVehicle _body;
            format ["Pile of Leaves Trap: Detonated at %1 — %2 OPFOR in blast radius", _pos, count _opforClose] call vgm_g_fnc_logInfo;
        };
    };
};
