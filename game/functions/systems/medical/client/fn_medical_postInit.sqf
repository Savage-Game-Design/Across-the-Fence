/*
    File: fn_medical_postInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2026-03-05
    Public: No

    Description:
        Client postInit for medical component.
        Initializes VGM wound/debuff system, then starts SOG Advanced Revive
        event handlers. VGM tracks wounds; SOG handles incapacitation/revive.
 */

if (!hasInterface) exitWith {};

player call vgm_c_fnc_medical_unitInit;

// add the actions on players that were present before we joined and ourselves
{
    ["vgm_medical_addAction", _x] call para_g_fnc_event_triggerLocal;
} forEach (allPlayers select {!(_x isKindOf "VirtualMan_F")});

// bleeding status effect
["bleeding", {call vgm_c_fnc_medical_statusEffectBleeding}] call vgm_c_fnc_statusEffect_create;

// will update current injury effects on status effect change
["injuryEffectImmunity", {call vgm_c_fnc_medical_injuryEffects_statusEffectImmunity}] call vgm_c_fnc_statusEffect_create;

// will not change state of any existing effects
["limbInjuryEffectResistance", {
    params ["_unit", "_inEffect"];
    _unit setVariable ["vgm_c_medical_limbInjuryEffectResistant", _inEffect];
}] call vgm_c_fnc_statusEffect_create;

[] call vgm_c_fnc_medical_feedback_init;
[] call vgm_c_fnc_medical_injuryEffects_init;

// --- SOG SAM + Revive Audio: Initialize voice hash and conversation audio ---
// Must run on each client so vn_fnc_revive_conversation can play voice lines.
// Calls vn_fnc_sam_globals internally (sets up vn_sam_voiceHash).
[] call vn_fnc_revive_setup_audio;

// --- SOG Advanced Revive: Initialize event handlers (script-based, no module) ---
// Must run AFTER VGM unitInit so VGM's HandleDamage EH has a lower index (runs first).
// SOG's addEventHandlers uses waitUntil {time > 1} internally, so it MUST be spawned
// (scheduled context). Using call would skip the entire body since waitUntil acts as
// if-check in unscheduled context and time <= 1 during postInit.
[] spawn vn_fnc_revive_addEventHandlers;
[] spawn vn_fnc_revive_actions;

// --- SOG Ã¢â€ â€ VGM state sync loop ---
// Polls SOG's vn_revive_incapacitated and fires VGM's vgm_medical_unconscious event
// so Playing Possum and other VGM subscribers react to SOG state changes.
// On revive (incap Ã¢â€ â€™ not incap): clears all wounds if medic revived, else reduces by 1.
[] spawn {
    private _lastState = false;
    while {true} do {
        sleep 0.5;
        if (!alive player) then {continue};

        private _sogState = player getVariable ["vn_revive_incapacitated", false];
        if (_sogState != _lastState) then {
            _lastState = _sogState;
            player setVariable ["vgm_g_medical_isUnconscious", _sogState, true];
            ["vgm_medical_unconscious", [player, _sogState]] call para_g_fnc_event_triggerServerAndLocal;

            // On revive: reset wounds based on reviver type
            if (!_sogState) then {
                // Find the closest unit (player or AI squad member) within 5m as the likely reviver
                private _candidates = allPlayers select {
                    alive _x && _x != player && _x distance player < 5
                };
                // Remove duplicates (player might be in both lists)
                _candidates = _candidates arrayIntersect _candidates;
                private _reviver = objNull;
                if (_candidates isNotEqualTo []) then {
                    _candidates = [_candidates, [], {_x distance player}, "ASCEND"] call BIS_fnc_sortBy;
                    _reviver = _candidates select 0;
                };

                private _medicRevive = !isNull _reviver && {
                    _reviver getUnitTrait "Medic" || _reviver getVariable ["isMedic", false]
                };
                private _bodyParts = ["head", "arms", "torso", "legs"];

                {
                    private _wound = player getVariable [format ["vgm_g_medical_wound$%1", _x], 0];
                    if (_wound > 0) then {
                        private _removeAmount = [1, _wound] select _medicRevive;
                        [player, _x, _removeAmount] call vgm_c_fnc_medical_removeWound;
                    };
                } forEach _bodyParts;

                private _healType = ["non-medic (-1)", "medic (full)"] select _medicRevive;
                format ["Revive wound reset: %1 by %2 (%3)", name player, _reviver, _healType] call vgm_g_fnc_logInfo;
            };
        };
    };
};
