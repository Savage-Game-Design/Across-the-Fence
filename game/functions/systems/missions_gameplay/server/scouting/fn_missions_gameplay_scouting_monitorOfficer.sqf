/*
    File: fn_missions_gameplay_scouting_monitorOfficer.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Server-side monitoring loop for a PAVN officer spawned at a scouting
        mission site. Tracks officer state: alive -> unconscious -> extracted
        or killed. Awards bonus XP via scouting netmap flags.

    Parameter(s):
        _missionId - Mission ID [NUMBER]
        _officer   - The PAVN officer unit [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_missionId, _officer] spawn vgm_s_fnc_missions_gameplay_scouting_monitorOfficer
 */

params ["_missionId", "_officer"];

private _captured = false;

while { true } do {
    sleep 2;

    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_mission") exitWith {};
    if ((_mission get "public" get "status") != "IN PROGRESS") exitWith {};

    // Officer killed
    if (!alive _officer) exitWith {
        private _scoutingData = [_missionId, "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
        [_scoutingData, "officerKilled", true] call para_s_fnc_netmap_set;

        // Notify players on the mission
        private _playerGroup = _mission get "public" get "group";
        ["Scouting Officer: Officer killed for mission %1", _missionId] call vgm_g_fnc_logInfo;

        private _msg = "<t size='1.2' color='#E74C3C'>PAVN Officer Eliminated</t><br/><t size='0.9'>Bonus intel awarded</t>";
        [parseText _msg] remoteExecCall ["hint", _playerGroup];
    };

    // Officer knocked unconscious
    if (!_captured && { _officer getVariable ["vgm_scouting_officer_unconscious", false] }) then {
        _captured = true;

        private _scoutingData = [_missionId, "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
        [_scoutingData, "officerCaptured", true] call para_s_fnc_netmap_set;

        private _playerGroup = _mission get "public" get "group";
        ["Scouting Officer: Officer captured for mission %1", _missionId] call vgm_g_fnc_logInfo;

        private _msg = "<t size='1.2' color='#82E0AA'>PAVN Officer Captured</t><br/><t size='0.9' color='#D4AC0D'>Extract him for bonus intel</t>";
        [parseText _msg] remoteExecCall ["hint", _playerGroup];
    };

    // Officer extracted (in heli or on STABO)
    if (_captured) then {
        private _playerGroup = _mission get "public" get "group";
        private _extractHeli = _playerGroup getVariable ["vgm_missions_extraction_helicopter", objNull];
        private _inHeli = !isNull _extractHeli && { _officer in _extractHeli };
        private _onStabo = _officer getVariable ["vgm_snatch_stabo_hooked", false];

        if (_inHeli || _onStabo) exitWith {
            private _scoutingData = [_missionId, "scouting"] call vgm_s_fnc_missions_getSystemNetmap;
            [_scoutingData, "officerExtracted", true] call para_s_fnc_netmap_set;

            ["Scouting Officer: Officer extracted for mission %1", _missionId] call vgm_g_fnc_logInfo;

            private _msg = "<t size='1.2' color='#82E0AA'>Officer Secured</t><br/><t size='0.9'>Maximum intel bonus awarded</t>";
            [parseText _msg] remoteExecCall ["hint", _playerGroup];
        };
    };
};
