/*
    File: fn_skill_targetFolder_revealIntel.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server-side Target Folder intel reveal. Checks all mission players for
        their Target Folder trait level and sends appropriate intel markers to
        qualifying clients.

        Level 1+: Trail signs (approximate markers in a ring around sites)
        Level 2+: Activity areas (approximate site positions, offset 100-200m)
        Level 3+: Site location hints (more precise, offset 25-75m)

    Parameter(s):
        _mission - Mission hashmap [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_skill_targetFolder_revealIntel
 */

if (!isServer) exitWith {};

params ["_mission"];

private _players = [_mission] call vgm_s_fnc_missions_getPlayers;
if (count _players == 0) exitWith {};

private _missionPublic = _mission get "public";
private _targetZone = _missionPublic get "targetZone";
private _sites = [_targetZone] call vgm_s_fnc_missions_zones_getSites;

if (count _sites == 0) exitWith {};

// Get zone marker for position clamping
private _zone = _mission call vgm_g_fnc_missions_getZoneMarker;

{
    private _player = _x;
    private _level = _player getVariable ["vgm_g_skill_targetFolder", 0];
    if (_level < 1) then { continue };

    private _intelData = [];

    // Level 1+: Trail sign positions in the hint ring around each site
    {
        private _sitePos = _x get "pos";
        private _count = 1 + floor random 2;
        for "_i" from 1 to _count do {
            private _validPos = [];
            for "_p" from 0 to 10 do {
                private _pos = [_sitePos, 400, 100] call vgm_g_fnc_randomPosInRing;
                if (_pos inArea _zone) exitWith { _validPos = _pos };
            };
            if !(_validPos isEqualTo []) then {
                _intelData pushBack ["trail", _validPos];
            };
        };
    } forEach _sites;

    // Level 2+: Approximate site area positions (offset 100-200m)
    if (_level >= 2) then {
        {
            private _sitePos = _x get "pos";
            private _validPos = [];
            for "_p" from 0 to 10 do {
                private _pos = [_sitePos, 200, 100] call vgm_g_fnc_randomPosInRing;
                if (_pos inArea _zone) exitWith { _validPos = _pos };
            };
            if !(_validPos isEqualTo []) then {
                _intelData pushBack ["area", _validPos];
            };
        } forEach _sites;
    };

    // Level 3+: More precise site positions (offset 25-75m)
    if (_level >= 3) then {
        {
            private _sitePos = _x get "pos";
            private _validPos = [];
            for "_p" from 0 to 10 do {
                private _pos = [_sitePos, 75, 25] call vgm_g_fnc_randomPosInRing;
                if (_pos inArea _zone) exitWith { _validPos = _pos };
            };
            if !(_validPos isEqualTo []) then {
                _intelData pushBack ["site", _validPos];
            };
        } forEach _sites;
    };

    [_intelData] remoteExecCall ["vgm_c_fnc_skill_targetFolder_showMarkers", _player];

    format ["Target Folder: Sent level %1 intel (%2 markers) to %3", _level, count _intelData, name _player] call vgm_g_fnc_logInfo;
} forEach _players;
