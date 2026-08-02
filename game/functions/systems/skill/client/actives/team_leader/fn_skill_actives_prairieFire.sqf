/*
    File: fn_skill_actives_prairieFire.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        A random CAS aircraft arrives on station immediately with loiter time.
        Player can call airstrikes using their handheld radio. Sends request
        to server to spawn a CAS aircraft from the available pool.

    Parameter(s):
        _unit - Unit activating skill [UNIT]
        _skill - Skill being activated [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [player, _skill] call vgm_c_fnc_skill_actives_prairieFire
 */

params ["_unit", "_skill"];

private _duration = _skill get "duration";

["Team Leader/Prairie Fire skill activated"] call vgm_g_fnc_logInfo;

// Request CAS aircraft from server
[_unit, _duration] remoteExecCall ["vgm_s_fnc_skill_prairieFire_spawnCAS", 2];
