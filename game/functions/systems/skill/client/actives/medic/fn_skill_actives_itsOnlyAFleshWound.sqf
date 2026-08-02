/*
    File: fn_skill_actives_itsOnlyAFleshWound.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-05
    Public: No

    Description:
        Activates the "It's only a flesh wound" skill.
        Completely heals the targeted player: removes all wounds,
        stops bleeding, and revives if incapacitated (via SOG revive).

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_itsOnlyAFleshWound
 */

params ["", "_skill"];

private _target = cursorTarget;
if (isNull _target || {!isPlayer _target}) exitWith {
    "It's only a flesh wound: no valid target" call vgm_g_fnc_logWarning;
};

format ["It's only a flesh wound skill activated on %1", name _target] call vgm_g_fnc_logInfo;

// Remove all VGM wounds, stop bleeding - on target's machine
{
    [_target, _x, 3] remoteExecCall ["vgm_c_fnc_medical_removeWound", _target];
} forEach ["head", "arms", "torso", "legs"];

[_target, "bleeding", "medical"] remoteExecCall ["vgm_c_fnc_statusEffect_remove", _target];

// Revive via SOG if incapacitated — entire revive block runs on the target's machine
if (_target call vgm_g_fnc_medical_isUnconscious) then {
    [[_target], {
        params ["_unit"];
        _unit setVariable ["vn_revive_incapacitated", false, true];
        _unit setVariable ["vn_revive_bleeding", false, true];
        _unit setVariable ["vn_revive_downed", false, true];
        _unit setVariable ["vn_revive_respawn_action", false, true];
        _unit setVariable ["vn_revive_withstand_action", false, true];
        _unit setVariable ["vn_revive_carried", false, true];
        _unit setVariable ["vn_revive_dragged", false, true];
        _unit setVariable ["vn_revive_incapacitated_mobile", false];
        _unit setUnconscious false;
        [_unit, true, false] remoteExec ["vn_fnc_revive_actions_local", 0, true];

        [_unit] spawn {
            params ["_u"];
            sleep 1;
            [_u] call vn_fnc_revive_fix_movement;
            sleep 9;
            _u setCaptive false;
        };
    }] remoteExec ["call", _target];
};

[format [localize "STR_VGM_SKILLS_SKILL_ITS_ONLY_A_FLESH_WOUND_ACTIVATED", name _target]] call para_c_fnc_hint;
