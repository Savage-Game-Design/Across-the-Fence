/*
    File: fn_amblife_civilianReporting.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server-side loop (10s interval) per mission. Iterates all spawned civilian
        virtual squads, checks if any spawned civilian unit knowsAbout a player > 1.5
        within 100m. If so, adds +2 alertness to the mission director.
        Each civilian can only report once per 60s (cooldown variable).
        Loop exits when mission ends (vgm_s_amblife_missionActive flag set to false).

    Parameter(s):
        _missionId - Mission ID [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0] call vgm_s_fnc_amblife_civilianReporting;
 */

params ["_missionId"];

[_missionId] spawn {
    params ["_missionId"];
    scriptName format ["vgm_amblife_civReporting_%1", _missionId];

    while {vgm_s_amblife_missionActive getOrDefault [_missionId, false]} do {
        sleep 10;

        // Get director data for this mission
        private _directorData = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
        if (isNil "_directorData") then {continue};

        // Get all spawned squads for this mission
        private _missionSquadsInfo = [_missionId] call vgm_s_fnc_virtsquad_getMissionSquadsInfo;
        private _spawnedSquads = values (_missionSquadsInfo get "spawnedSquads");

        // Filter to civilian squads that are currently spawned
        private _civSquads = _spawnedSquads select {
            (_x get "side") isEqualTo civilian && "group" in _x
        };

        // Cache player list once per cycle instead of per civilian unit
        private _alivePlayers = allPlayers select {alive _x};

        {
            private _squad = _x;
            private _group = _squad get "group";
            if (isNull _group) then {continue};

            {
                private _unit = _x;
                if (!alive _unit) then {continue};

                // Check cooldown (60s)
                private _lastReport = _unit getVariable ["amblife_lastReport", -9999];
                if (time - _lastReport < 60) then {continue};

                // Check players within 100m using engine-optimized spatial query
                private _players = _alivePlayers inAreaArray [getPosATL _unit, 100, 100];
                {
                    if (_unit knowsAbout _x > 1.5) exitWith {
                        // Civilian spotted a player - report to director
                        [_directorData, 3] call vgm_s_fnc_director_addAlertness;
                        _unit setVariable ["amblife_lastReport", time];
                    };
                } forEach _players;
            } forEach units _group;
        } forEach _civSquads;
    };
};
