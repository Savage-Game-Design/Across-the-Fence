/*
    File: fn_radioJamming_detonateSatchel.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Server handler for satchel charge detonation on an antenna tower.
        Called via remoteExecCall from the client after the hold action completes.
        Waits 10 seconds (fuse timer), creates an explosion, and destroys
        the antenna. Awards XP based on whether it was a jammer or not.

    Parameter(s):
        _target - The antenna tower object [OBJECT]
        _caller - The player who planted the charge [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_radioJamming_detonateSatchel", 2]
*/

if (!isServer) exitWith {};

params ["_target", "_caller"];

if (!alive _target) exitWith {};

// Mark as satchel-destroyed to prevent double XP from combat Killed EH
_target setVariable ["vgm_satchel_destroyed", true, true];

// 10-second fuse
[_target, _caller] spawn {
    params ["_target", "_caller"];

    sleep 10;

    if (!alive _target) exitWith {};

    // Create explosion at the antenna position
    private _pos = getPos _target;
    private _explosion = createVehicle ["HelicopterExploBig", _pos, [], 0, "CAN_COLLIDE"];

    // Destroy the antenna (triggers existing Killed EH which also destroys sibling)
    _target setDamage [1, true, _caller];

    // Award XP: 75 for jammer, 50 for regular transmitter
    private _isJammer = _target getVariable ["vgm_radioJammer_isJamming", false];
    private _xp = if (_isJammer) then { 75 } else { 50 };
    [_caller, _xp] call vgm_s_fnc_leveling_addExperience;

    // Raise alertness (explosion is loud)
    private _allMissions = values (missionNamespace getVariable ["vgm_s_missions_allMissions", createHashMap]);
    private _directorData = createHashMap;

    {
        private _mDir = _x getOrDefault ["directorData", createHashMap];
        if !(_mDir isEqualTo createHashMap) exitWith {
            _directorData = _mDir;
        };
    } forEach _allMissions;

    if !(_directorData isEqualTo createHashMap) then {
        [_directorData, 10] call vgm_s_fnc_director_addAlertness;
    };

    format [
        "Satchel: %1 destroyed %2 at %3 (+%4 XP, jammer: %5)",
        name _caller, typeOf _target, _pos, _xp, _isJammer
    ] call vgm_g_fnc_logInfo;
};
