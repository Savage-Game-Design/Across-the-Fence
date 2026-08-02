/*
    File: fn_skill_passives_lastRites.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Adds a scrollwheel action near dead or unconscious enemies.
        50% chance to reveal the nearest site hint.

    Parameter(s):
        _apply - Should skill effect be applied? [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_lastRites
 */

#define INTERROGATE_RANGE 3
#define HINT_SEARCH_RANGE 2000

params ["_apply"];

private _existingActionId = player getVariable ["vgm_c_skill_passives_lastRitesAction", -1];

if (!_apply) exitWith {
    player removeAction _existingActionId;
    player setVariable ["vgm_c_skill_passives_lastRitesAction", -1];
};

if (_existingActionId >= 0) exitWith {};

private _actionId = player addAction [
    localize "STR_VGM_SKILLS_SKILL_LAST_RITES_ACTION",
    {
        params ["_player", "", "_actionId"];

        private _target = cursorObject;
        if (isNull _target) exitWith {};

        // Mark as interrogated
        _target setVariable ["vgm_g_skill_lastRites_interrogated", true, true];

        if (random 1 < 0.5) then {
            // Success: find and reveal nearest site hint
            private _hintsInRange = [getPosATL _player, HINT_SEARCH_RANGE] call vgm_c_fnc_sites_hints_getHintsInRange;

            if (_hintsInRange isNotEqualTo []) then {
                private _hintsSorted = _hintsInRange apply {[_player distance _x, _x]};
                _hintsSorted sort true;
                [_hintsSorted # 0 # 1] call vgm_c_fnc_sites_hints_inspect;
            };

            [localize "STR_VGM_SKILLS_SKILL_LAST_RITES_SUCCESS"] call para_c_fnc_hint;
            format ["Last rites: intel gained from %1", _target] call vgm_g_fnc_logInfo;
        } else {
            [localize "STR_VGM_SKILLS_SKILL_LAST_RITES_FAIL"] call para_c_fnc_hint;
            "Last rites: no intel gained" call vgm_g_fnc_logInfo;
        };
    },
    nil,
    1,
    false,
    true,
    "",
    // Condition: cursor on enemy, dead or unconscious, within range, not yet interrogated
    "private _co = cursorObject; \
    !isNull _co \
    && {side _co != side player} \
    && {!alive _co || {_co call vgm_g_fnc_medical_isUnconscious}} \
    && {player distance _co < INTERROGATE_RANGE} \
    && {!(_co getVariable ['vgm_g_skill_lastRites_interrogated', false])}"
];

player setVariable ["vgm_c_skill_passives_lastRitesAction", _actionId];
