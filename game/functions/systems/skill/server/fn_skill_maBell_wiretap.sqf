/*
    File: fn_skill_maBell_wiretap.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for Ma Bell wiretap action. Awards bonus XP
        and marks the transmitter as tapped.

    Parameter(s):
        _target - The transmitter tower that was tapped [OBJECT]
        _caller - The player who installed the wiretap [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_maBell_wiretap", 2]
 */

if (!isServer) exitWith {};

params ["_target", "_caller"];

_target setVariable ["vgm_maBell_tapped", true, true];
[_caller, 75] call vgm_s_fnc_leveling_addExperience;

format ["Ma Bell: %1 wiretapped transmitter at %2", name _caller, getPos _target] call vgm_g_fnc_logInfo;
