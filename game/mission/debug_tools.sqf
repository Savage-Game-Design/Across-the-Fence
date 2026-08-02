// Debug Tools - run from console: execVM "debug_tools.sqf";
// Adds one scroll action "Enable Debug Tools" that expands into all debug actions.
// To disable: use the "[DBG] Disable Debug Tools" scroll action, or run: VGM_DEBUG_INIT = nil;
if (!isNil "VGM_DEBUG_INIT") exitWith {systemChat "Debug tools already active."};
VGM_DEBUG_INIT = true;

private _initAction = player addAction ["<t color='#ff0000'>Enable Debug Tools</t>", {
    params ["_target", "_caller", "_actionId"];
    _caller removeAction _actionId;
    systemChat "Debug tools enabled.";

    // --- State variables ---
    _caller setVariable ["dbg_godmode", false];
    _caller setVariable ["dbg_stealth", false];
    _caller setVariable ["dbg_enemyMarkers", false];
    _caller setVariable ["dbg_teleport", false];
    _caller setVariable ["dbg_civMarkers", false];
    _caller setVariable ["dbg_skills", false];
    _caller setVariable ["dbg_trackMarkers", false];
    _caller setVariable ["dbg_tfarMonitor", false];
    _caller setVariable ["dbg_directorMonitor", false];
    _caller setVariable ["dbg_convoyMarkers", false];

    // Track all action IDs for cleanup
    private _actionIds = [];

    // =====================================================================
    // 1. INVINCIBILITY TOGGLE
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ffff00'>[DBG] Toggle God Mode</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_godmode", false]);
        _target setVariable ["dbg_godmode", _on];
        _target allowDamage !_on;
        systemChat format ["God Mode: %1", ["OFF", "ON"] select _on];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 2. INVISIBLE TO AI
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ffff00'>[DBG] Invisible to AI</t>", {
        params ["_target"];
        _target setVariable ["dbg_stealth", true];
        _target setCaptive true;
        {
            if (side _x == east) then {
                _x forgetTarget _target;
            };
        } forEach allUnits;
        systemChat "AI Stealth: ON - enemies have forgotten you.";
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 3. VISIBLE TO AI
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ffff00'>[DBG] Visible to AI</t>", {
        params ["_target"];
        _target setVariable ["dbg_stealth", false];
        _target setCaptive false;
        systemChat "AI Stealth: OFF - enemies can see you again.";
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 4. TELEPORT ON MAP CLICK
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ffff00'>[DBG] Toggle Teleport (Map Click)</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_teleport", false]);
        _target setVariable ["dbg_teleport", _on];

        if (_on) then {
            VGM_DEBUG_TELEPORT_EH = addMissionEventHandler ["MapSingleClick", {
                params ["_units", "_pos"];
                player setPosATL [_pos#0, _pos#1, 0];
                systemChat format ["Teleported to %1", _pos];
            }];
            systemChat "Teleport: ON - click the map to teleport. Stays active until toggled off.";
        } else {
            if (!isNil "VGM_DEBUG_TELEPORT_EH") then {
                removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_TELEPORT_EH];
                VGM_DEBUG_TELEPORT_EH = nil;
            };
            systemChat "Teleport: OFF";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 5. SHOW ENEMIES ON MAP (toggle)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ffff00'>[DBG] Toggle Enemy Markers</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_enemyMarkers", false]);
        _target setVariable ["dbg_enemyMarkers", _on];

        if (_on) then {
            systemChat "Enemy markers: ON";
            VGM_DEBUG_MARKER_LOOP = [] spawn {
                private _markers = [];
                while {player getVariable ["dbg_enemyMarkers", false]} do {
                    {deleteMarkerLocal _x} forEach _markers;
                    _markers = [];

                    // Track which groups we've already added tracker status for (one marker per group, on the leader)
                    private _trackerGroupsDone = createHashMap;

                    {
                        if (side group _x == east && {alive _x}) then {
                            private _mName = format ["dbg_enemy_%1", _x];
                            private _m = createMarkerLocal [_mName, getPosATL _x];
                            _m setMarkerTypeLocal "mil_dot";
                            private _grp = group _x;
                            private _isTracker = _grp getVariable ["vgm_isTrackerTeam", false];
                            private _grpKey = str _grp;
                            if (_isTracker && {_x == leader _grp} && {!(_grpKey in _trackerGroupsDone)}) then {
                                _trackerGroupsDone set [_grpKey, true];
                                _m setMarkerColorLocal "ColorOrange";
                                // Read tracker status from local btree blackboard
                                private _status = "SEARCHING";
                                private _btreeState = _grp getVariable "vgm_l_btree_state";
                                if (!isNil "_btreeState") then {
                                    private _bb = _btreeState get "blackboard";
                                    private _curTrack = _bb getOrDefault ["tracking_currentTrack", createHashMap];
                                    private _lastTrack = _bb getOrDefault ["tracking_lastTrack", createHashMap];
                                    if ("pos" in _curTrack) then {
                                        private _age = (serverTime - (_curTrack getOrDefault ["time", serverTime])) / 60;
                                        private _dst = leader _grp distance2D (_curTrack get "pos");
                                        _status = format ["FOLLOWING trk:%1m ago dst:%2m", _age toFixed 1, _dst toFixed 0];
                                    } else {
                                        if ("pos" in _lastTrack) then {
                                            private _lostAge = (serverTime - (_lastTrack getOrDefault ["time", serverTime])) / 60;
                                            _status = format ["LOST (last:%1m ago)", _lostAge toFixed 1];
                                        };
                                    };
                                };
                                _m setMarkerTextLocal format ["TRK %1m | %2", player distance _x toFixed 0, _status];
                            } else {
                                if (_isTracker) then {
                                    _m setMarkerColorLocal "ColorOrange";
                                } else {
                                    _m setMarkerColorLocal "ColorRed";
                                };
                                _m setMarkerTextLocal format ["%1m", player distance _x toFixed 0];
                            };
                            _m setMarkerSizeLocal [0.5, 0.5];
                            _markers pushBack _mName;
                        };
                    } forEach allUnits;

                    sleep 2;
                };
                {deleteMarkerLocal _x} forEach _markers;
                systemChat "Enemy markers: OFF";
            };
        } else {
            _target setVariable ["dbg_enemyMarkers", false];
            systemChat "Enemy markers turning off...";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 6. GIVE 99 SKILL POINTS + 20000 XP
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ffff00'>[DBG] Give 99 SP + 20000 XP</t>", {
        params ["_target"];
        [_target, 99] remoteExecCall ["vgm_s_fnc_skills_addSkillPoint", 2];
        [_target, 20000] remoteExecCall ["vgm_s_fnc_leveling_addExperience", 2];
        systemChat "Granted 99 skill points and 20000 XP.";
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 7. TOGGLE ALL SKILLS (FIXED)
    //    Applies every skill's codeApply client-side. No persistence touched.
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ffff00'>[DBG] Toggle All Skills</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_skills", false]);
        _target setVariable ["dbg_skills", _on];

        if (_on) then {
            private _applied = 0;
            {
                private _skill = _y;
                if (!isNil {_skill get "tier"}) then {
                    private _code = _skill get "codeApply";
                    // codeApply is compileFinal'd — compare against empty code {}, not ""
                    if (!isNil "_code" && {!(_code isEqualTo {})}) then {
                        _target call _code;
                        _applied = _applied + 1;
                    };
                };
            } forEach vgm_skills_pathsHashMap;

            // Zero-cooldown loop for active abilities
            VGM_DEBUG_SKILLS_CD_LOOP = [] spawn {
                while {player getVariable ["dbg_skills", false]} do {
                    if (!isNil "vgm_c_skills_active_slots") then {
                        {
                            _y set ["cooldownUntil", 0];
                        } forEach vgm_c_skills_active_slots;
                    };
                    // Also reset the skill cooldown coefficient
                    [player, "skillCooldown", "dbg_zeroCooldown", -0.5, false] call vgm_c_fnc_coefficient_set;
                    sleep 1;
                };
                [player, "skillCooldown", "dbg_zeroCooldown"] call vgm_c_fnc_coefficient_remove;
            };

            systemChat format ["Debug Skills: ON - %1 skills applied, cooldowns disabled.", _applied];
        } else {
            {
                private _skill = _y;
                if (!isNil {_skill get "tier"}) then {
                    private _code = _skill get "codeUnapply";
                    if (!isNil "_code" && {!(_code isEqualTo {})}) then {
                        _target call _code;
                    };
                };
            } forEach vgm_skills_pathsHashMap;

            systemChat "Debug Skills: OFF - all skills removed, cooldowns restored.";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 8. FULL HEAL (Medical System)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ff00'>[DBG] Full Heal</t>", {
        params ["_target"];
        {
            [_target, _x, 3] call vgm_c_fnc_medical_removeWound;
        } forEach ["head", "arms", "torso", "legs"];

        // Stop bleeding
        _target setVariable ["vgm_g_medical_bleeding", false, true];

        // Reset damage
        _target setDamage 0;

        systemChat "Fully healed: all wounds removed, bleeding stopped, damage reset.";
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 9. DUMP COEFFICIENTS
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Dump Coefficients</t>", {
        params ["_target"];
        systemChat "=== COEFFICIENTS ===";
        if (isNil "vgm_c_coefficient_allCoefficients") exitWith {
            systemChat "Coefficient system not initialized.";
        };
        {
            private _name = _x;
            private _data = _y;
            private _baseValue = _data get "baseValue";
            private _value = [_target, _name] call vgm_c_fnc_coefficient_get;
            private _reasons = (_target getVariable ["vgm_c_coefficient_currentCoefficients", createHashMap]) getOrDefault [_name, createHashMap];
            private _reasonCount = count _reasons;
            private _color = if (_value != _baseValue) then {"#ffff00"} else {"#aaaaaa"};
            systemChat format ["  %1: %2 (base: %3) [%4 reasons]", _name, _value toFixed 2, _baseValue toFixed 2, _reasonCount];
        } forEach vgm_c_coefficient_allCoefficients;
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 10. DUMP STATUS EFFECTS
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Dump Status Effects</t>", {
        params ["_target"];
        systemChat "=== STATUS EFFECTS ===";
        if (isNil "vgm_c_statusEffect_allEffects") exitWith {
            systemChat "Status effect system not initialized.";
        };
        private _anyActive = false;
        {
            private _name = _x;
            private _active = [_target, _name] call vgm_c_fnc_statusEffect_get;
            if (_active) then {
                _anyActive = true;
                private _reasons = (_target getVariable ["vgm_c_statusEffect_currentEffects", createHashMap]) getOrDefault [_name, []];
                systemChat format ["  %1: ACTIVE (reasons: %2)", _name, _reasons];
            };
        } forEach vgm_c_statusEffect_allEffects;
        if (!_anyActive) then {
            systemChat "  No active status effects.";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 11. VIEW ALERTNESS (Mission Director)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] View Alertness</t>", {
        params ["_target"];
        // Query server for alertness data
        (compile format [
            '
            private _cid = %1;
            private _msg = "=== MISSION DIRECTOR ===";
            _msg remoteExecCall ["systemChat", _cid];
            private _allMissions = localNamespace getVariable ["vgm_missions", createHashMap];
            {
                private _missionId = _x;
                private _mission = _y;
                private _director = _mission get "director";
                if (!isNil "_director") then {
                    private _alertness = _director getOrDefault ["alertness", 0];
                    private _lastEvent = _director getOrDefault ["lastAlertnessEventTime", serverTime];
                    private _lastDecay = _director getOrDefault ["lastDecayTime", serverTime];
                    private _trackerCount = count (_director getOrDefault ["virtualSquads", createHashMap]);
                    private _lastTracker = _director getOrDefault ["lastTrackerSent", -9999];
                    (format ["  Mission %%1: alertness=%%2/100 | vSquads=%%3 | lastEvent=%%4s ago | lastDecay=%%5s ago | lastTracker=%%6s ago",
                        _missionId, _alertness toFixed 1, _trackerCount,
                        (serverTime - _lastEvent) toFixed 0,
                        (serverTime - _lastDecay) toFixed 0,
                        if (_lastTracker > 0) then { (serverTime - _lastTracker) toFixed 0 } else { "never" }
                    ]) remoteExecCall ["systemChat", _cid];
                } else {
                    (format ["  Mission %%1: no director attached", _missionId]) remoteExecCall ["systemChat", _cid];
                };
            } forEach _allMissions;
            if (count _allMissions == 0) then {
                "  No active missions." remoteExecCall ["systemChat", _cid];
            };
            ',
            owner _target
        ]) remoteExec ["call", 2];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 12. SET ALERTNESS TO MAX
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] Set Alertness to MAX</t>", {
        params ["_target"];
        (compile format [
            '
            private _cid = %1;
            private _allMissions = localNamespace getVariable ["vgm_missions", createHashMap];
            {
                private _missionId = _x;
                private _director = (_y) get "director";
                if (!isNil "_director") then {
                    [_director, 100] call vgm_s_fnc_director_addAlertness;
                    (format ["Alertness set to MAX for mission %%1", _missionId]) remoteExecCall ["systemChat", _cid];
                };
            } forEach _allMissions;
            ',
            owner _target
        ]) remoteExec ["call", 2];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 13. SET ALERTNESS TO SPECIFIC VALUE
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] Set Alertness to 0</t>", {
        params ["_target"];
        (compile format [
            '
            private _cid = %1;
            private _allMissions = localNamespace getVariable ["vgm_missions", createHashMap];
            {
                private _missionId = _x;
                private _director = (_y) get "director";
                if (!isNil "_director") then {
                    private _current = _director get "alertness";
                    [_director, -_current] call vgm_s_fnc_director_addAlertness;
                    (format ["Alertness reset to 0 for mission %%1", _missionId]) remoteExecCall ["systemChat", _cid];
                };
            } forEach _allMissions;
            ',
            owner _target
        ]) remoteExec ["call", 2];
    }, nil, 0, false, true, "", "true", 5]);

    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] Set Alertness to 61</t>", {
        params ["_target"];
        (compile format [
            '
            private _cid = %1;
            private _allMissions = localNamespace getVariable ["vgm_missions", createHashMap];
            {
                private _missionId = _x;
                private _director = (_y) get "director";
                if (!isNil "_director") then {
                    private _current = _director get "alertness";
                    [_director, 61 - _current] call vgm_s_fnc_director_addAlertness;
                    (format ["Alertness set to 61 for mission %%1", _missionId]) remoteExecCall ["systemChat", _cid];
                };
            } forEach _allMissions;
            ',
            owner _target
        ]) remoteExec ["call", 2];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 14. TOGGLE TRACK MARKERS (Map + 3D Icons)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Toggle Track Markers</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_trackMarkers", false]);
        _target setVariable ["dbg_trackMarkers", _on];

        if (_on) then {
            if (isNil "vgm_l_tracking_trackingGroups") exitWith {
                systemChat "No tracking groups active.";
                _target setVariable ["dbg_trackMarkers", false];
            };
            // Also show the original pink arrow 3D objects
            {
                [_x] call vgm_g_fnc_tracking_debugShowTracks;
            } forEach (keys vgm_l_tracking_trackingGroups);

            // Map markers + 3D icons loop
            VGM_DEBUG_TRACK_MARKER_LOOP = [] spawn {
                private _markers = [];
                while {player getVariable ["dbg_trackMarkers", false]} do {
                    // Clean previous map markers
                    {deleteMarkerLocal _x} forEach _markers;
                    _markers = [];

                    if (!isNil "vgm_l_tracking_trackingGroups") then {
                        private _idx = 0;
                        {
                            private _trackingGroup = _y;
                            private _trackDetails = _trackingGroup get "trackDetails";
                            {
                                private _pos = _x get "pos";
                                private _age = serverTime - (_x get "time");
                                private _ageMins = _age / 60;
                                private _mName = format ["dbg_trk_%1", _idx];
                                _idx = _idx + 1;

                                // Map marker
                                private _m = createMarkerLocal [_mName, _pos];
                                _m setMarkerTypeLocal "mil_dot";
                                // Fresh tracks = magenta, old tracks = pink
                                if (_ageMins < 3) then {
                                    _m setMarkerColorLocal "ColorPink";
                                } else {
                                    _m setMarkerColorLocal "ColorKhaki";
                                };
                                _m setMarkerSizeLocal [0.4, 0.4];
                                _m setMarkerTextLocal format ["%1m ago", _ageMins toFixed 1];
                                _markers pushBack _mName;
                            } forEach _trackDetails;
                        } forEach vgm_l_tracking_trackingGroups;
                    };
                    sleep 3;
                };
                // Cleanup on toggle off
                {deleteMarkerLocal _x} forEach _markers;
            };

            // 3D draw icons
            VGM_DEBUG_TRACK_DRAW3D_EH = addMissionEventHandler ["Draw3D", {
                if !(player getVariable ["dbg_trackMarkers", false]) exitWith {};
                if (isNil "vgm_l_tracking_trackingGroups") exitWith {};

                {
                    private _trackDetails = _y get "trackDetails";
                    {
                        private _pos = _x get "pos";
                        private _age = serverTime - (_x get "time");
                        // Only draw within 200m for performance
                        if (player distance2D _pos < 200) then {
                            private _ageMins = _age / 60;
                            // Fresh = bright magenta, old = faded
                            private _alpha = linearConversion [0, 600, _age, 1, 0.3, true];
                            drawIcon3D [
                                "\a3\ui_f\data\map\markers\military\dot_ca.paa",
                                [1, 0.2, 0.8, _alpha],
                                ASLToAGL (ATLtoASL _pos vectorAdd [0, 0, 0.5]),
                                0.5, 0.5, 0,
                                format ["%1m", _ageMins toFixed 1],
                                1, 0.03,
                                "RobotoCondensed",
                                "center"
                            ];
                        };
                    } forEach _trackDetails;
                } forEach vgm_l_tracking_trackingGroups;
            }];

            private _groupCount = count vgm_l_tracking_trackingGroups;
            systemChat format ["Track markers: ON (%1 groups) - map markers + 3D icons", _groupCount];
        } else {
            // Remove 3D draw handler
            if (!isNil "VGM_DEBUG_TRACK_DRAW3D_EH") then {
                removeMissionEventHandler ["Draw3D", VGM_DEBUG_TRACK_DRAW3D_EH];
                VGM_DEBUG_TRACK_DRAW3D_EH = nil;
            };
            // Hide original pink arrows
            if (!isNil "vgm_l_tracking_trackingGroups") then {
                {
                    [_x] call vgm_g_fnc_tracking_debugHideTracks;
                } forEach (keys vgm_l_tracking_trackingGroups);
            };
            systemChat "Track markers: OFF";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 15. AMBIENT LIFE OVERVIEW
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Ambient Life Overview</t>", {
        params ["_target"];

        private _localCivs = allUnits select {side group _x == civilian && alive _x};
        private _localCivVehicles = vehicles select {
            alive _x && {count crew _x > 0} && {side group (crew _x # 0) == civilian}
        };
        private _nearVeh = nearestObjects [_target, ["LandVehicle", "Ship"], 500];
        private _damaged = _nearVeh select {damage _x > 0};

        systemChat "=== AMBIENT LIFE OVERVIEW ===";
        systemChat format ["[Client] Materialized civs: %1 | Civ vehicles: %2", count _localCivs, count _localCivVehicles];
        systemChat format ["[Client] Vehicles <500m: %1 | Damaged: %2", count _nearVeh, count _damaged];
        {
            systemChat format ["  DMG: %1 @ %2 (dmg: %3)", typeOf _x, getPosATL _x, damage _x toFixed 2];
        } forEach _damaged;

        (compile format [
            '
            private _cid = %1;
            private _missions = [];
            {_missions pushBack format ["M%%1=%%2", _x, _y]} forEach vgm_s_amblife_missionActive;
            private _sCivs = {side group _x == civilian && alive _x} count allUnits;
            private _sAnimals = 0;
            {_sAnimals = _sAnimals + count _y} forEach vgm_s_amblife_missionAnimals;
            private _sObjects = 0;
            {_sObjects = _sObjects + count _y} forEach vgm_s_amblife_missionObjects;
            (format ["[Server] Missions: %%1 | Civs: %%2 | Animals: %%3 | Barriers: %%4", _missions joinString " ", _sCivs, _sAnimals, _sObjects]) remoteExecCall ["systemChat", _cid];
            ',
            owner _target
        ]) remoteExec ["call", 2];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 16. TOGGLE CIVILIAN / AMBIENT LIFE MARKERS
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Toggle Civilian Markers</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_civMarkers", false]);
        _target setVariable ["dbg_civMarkers", _on];

        if (_on) then {
            systemChat "Civilian markers: ON (green=civ, cyan=civVeh, blue=boat, yellow=opfVeh)";
            VGM_DEBUG_CIV_MARKER_LOOP = [] spawn {
                private _markers = [];
                while {player getVariable ["dbg_civMarkers", false]} do {
                    {deleteMarkerLocal _x} forEach _markers;
                    _markers = [];
                    private _idx = 0;

                    {
                        if (side group _x == civilian && alive _x && isNull objectParent _x) then {
                            private _mName = format ["dbg_al_%1", _idx];
                            _idx = _idx + 1;
                            private _m = createMarkerLocal [_mName, getPosATL _x];
                            _m setMarkerTypeLocal "mil_dot";
                            _m setMarkerColorLocal "ColorGreen";
                            _m setMarkerSizeLocal [0.5, 0.5];
                            _m setMarkerTextLocal format ["CIV %1m", player distance _x toFixed 0];
                            _markers pushBack _mName;
                        };
                    } forEach allUnits;

                    {
                        if (alive _x && count crew _x > 0) then {
                            private _crewSide = side group (crew _x # 0);
                            private _isBoat = _x isKindOf "Ship";
                            private _color = "";
                            private _label = "";
                            private _icon = "o_motor_inf";

                            if (_crewSide == civilian && _isBoat) then {
                                _color = "ColorBlue"; _label = "BOAT"; _icon = "mil_triangle";
                            } else {
                                if (_crewSide == civilian) then {
                                    _color = "ColorWEST"; _label = "CIV VEH";
                                } else {
                                    if (_crewSide == east) then {
                                        _color = "ColorYellow"; _label = "OPF VEH";
                                    };
                                };
                            };

                            if (_color != "") then {
                                private _mName = format ["dbg_al_%1", _idx];
                                _idx = _idx + 1;
                                private _m = createMarkerLocal [_mName, getPosATL _x];
                                _m setMarkerTypeLocal _icon;
                                _m setMarkerColorLocal _color;
                                _m setMarkerSizeLocal [0.6, 0.6];
                                private _dmg = if (damage _x > 0) then {format [" DMG:%1", damage _x toFixed 1]} else {""};
                                _m setMarkerTextLocal format ["%1 %2m%3", _label, player distance _x toFixed 0, _dmg];
                                _markers pushBack _mName;
                            };
                        };
                    } forEach vehicles;

                    sleep 3;
                };
                {deleteMarkerLocal _x} forEach _markers;
                systemChat "Civilian markers: OFF";
            };
        } else {
            _target setVariable ["dbg_civMarkers", false];
            systemChat "Civilian markers turning off...";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 17. VEHICLE HEALTH SCAN
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Vehicle Health Scan</t>", {
        params ["_target"];

        private _allVeh = vehicles select {alive _x};
        private _damaged = _allVeh select {damage _x > 0};
        private _destroyed = vehicles select {!alive _x && !(_x isKindOf "WeaponHolderSimulated")};
        private _stuck = _allVeh select {
            _x isKindOf "LandVehicle" && {!canMove _x} && {damage _x < 1}
        };

        systemChat "=== VEHICLE HEALTH SCAN ===";
        systemChat format ["Alive: %1 | Damaged: %2 | Destroyed: %3 | Stuck: %4",
            count _allVeh, count _damaged, count _destroyed, count _stuck];

        {
            private _crew = crew _x;
            private _crewInfo = if (count _crew > 0) then {
                format ["%1(%2)", side group (_crew # 0), count _crew]
            } else {"empty"};
            systemChat format ["  %1 @ %2 dmg:%3 crew:%4",
                typeOf _x, getPosATL _x, damage _x toFixed 2, _crewInfo];
        } forEach (_damaged + _stuck);
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 18. TELEPORT TO NEAREST CIVILIAN
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Teleport to Nearest Civilian</t>", {
        params ["_target"];

        private _nearest = objNull;
        private _minDist = 999999;
        {
            if (side group _x == civilian && alive _x && _x != _target) then {
                private _d = _target distance _x;
                if (_d < _minDist) then {
                    _minDist = _d;
                    _nearest = _x;
                };
            };
        } forEach allUnits;

        if (isNull _nearest) exitWith {
            systemChat "No civilians found in the world.";
        };

        private _pos = getPosATL _nearest;
        _target setPosATL [_pos # 0, _pos # 1, 0];
        systemChat format ["Teleported to civilian at %1 (%2m away)", _pos, _minDist toFixed 0];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 19. SPAWN PATROL SQUAD (Map Click)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] Spawn Patrol Squad (Map Click)</t>", {
        params ["_target"];
        systemChat "Click the map to spawn a patrol squad. One-shot.";
        VGM_DEBUG_SPAWN_PATROL_EH = addMissionEventHandler ["MapSingleClick", {
            params ["_units", "_pos"];
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_PATROL_EH];
            VGM_DEBUG_SPAWN_PATROL_EH = nil;

            private _spawnPos = _pos;
            private _size = 4 + floor random 3;
            (compile format [
                '
                private _cid = %1;
                private _pos = %2;
                private _size = %3;
                private _classes = vgm_s_director_patrol_classes select [0, _size];
                private _grp = ([_classes, east, _pos] call para_g_fnc_create_squad) # 1;
                _grp setVariable ["vgm_g_missionId", -1, true];
                [_grp, "enemyAI"] call vgm_s_fnc_btree_setTreeByNameGlobal;
                private _selectedClient = call para_s_fnc_loadbal_suggest_host;
                _grp setGroupOwner _selectedClient;
                (format ["Patrol squad (%1 units) spawned at %%1", _size, _pos]) remoteExecCall ["systemChat", _cid];
                ',
                owner player,
                _spawnPos,
                _size
            ]) remoteExec ["call", 2];
            systemChat format ["Spawning patrol squad (%1 units) at %2...", _size, _spawnPos];
        }];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 20. SPAWN TRACKER SQUAD (Map Click)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] Spawn Tracker Squad (Map Click)</t>", {
        params ["_target"];
        systemChat "Click the map to spawn a tracker squad. One-shot.";
        VGM_DEBUG_SPAWN_TRACKER_EH = addMissionEventHandler ["MapSingleClick", {
            params ["_units", "_pos"];
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_TRACKER_EH];
            VGM_DEBUG_SPAWN_TRACKER_EH = nil;

            private _spawnPos = _pos;
            private _size = 4 + floor random 3;
            (compile format [
                '
                private _cid = %1;
                private _pos = %2;
                private _size = %3;
                private _classes = vgm_s_director_tracker_classes select [0, _size];
                private _grp = ([_classes, east, _pos] call para_g_fnc_create_squad) # 1;
                _grp setVariable ["vgm_isTrackerTeam", true, true];
                _grp setVariable ["vgm_g_missionId", -1, true];
                [_grp, "enemyAI"] call vgm_s_fnc_btree_setTreeByNameGlobal;
                private _selectedClient = call para_s_fnc_loadbal_suggest_host;
                _grp setGroupOwner _selectedClient;
                (format ["Tracker squad (%1 units) spawned at %%1", _size, _pos]) remoteExecCall ["systemChat", _cid];
                ',
                owner player,
                _spawnPos,
                _size
            ]) remoteExec ["call", 2];
            systemChat format ["Spawning tracker squad (%1 units) at %2...", _size, _spawnPos];
        }];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 21. TFAR STATUS
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff66ff'>[DBG] TFAR Status</t>", {
        params ["_target"];
        systemChat "=== TFAR INTEGRATION STATUS ===";

        if !(isClass (configFile >> "CfgPatches" >> "task_force_radio")) exitWith {
            systemChat "  TFAR: NOT LOADED — all detection systems skipped.";
        };
        systemChat "  TFAR: LOADED";

        // Voice detection
        private _voiceActive = !(isNil "vgm_c_voiceDetection_speakHandlerId");
        private _voiceVol = _target getVariable ["tf_voiceVolume", 0.6];
        private _voiceRadius = switch (true) do {
            case (_voiceVol <= 0.2): { 15 };
            case (_voiceVol <= 0.6): { 50 };
            default { 120 };
        };
        private _voiceThrottle = 4 - (time - vgm_c_voiceDetection_lastEventTime);
        if (_voiceThrottle < 0) then { _voiceThrottle = 0 };
        systemChat format ["  Voice Detection: %1 | Volume: %2 | Radius: %3m | Throttle: %4s",
            ["INACTIVE", "ACTIVE"] select _voiceActive,
            _voiceVol toFixed 2,
            _voiceRadius,
            _voiceThrottle toFixed 1
        ];

        // Count nearby OPFOR in voice radius
        private _nearbyAI = {side group _x == east && alive _x && _x distance2D _target < _voiceRadius} count allUnits;
        systemChat format ["  AI in voice range (%1m): %2 OPFOR units", _voiceRadius, _nearbyAI];

        // Radio detection
        private _radioActive = !(isNil "vgm_c_radioDetection_tangentHandlerId");
        private _transmitting = vgm_c_radioDetection_tangentStartTime > 0;
        private _txDuration = if (_transmitting) then { time - vgm_c_radioDetection_tangentStartTime } else { 0 };
        private _interceptCooldown = 30 - (time - vgm_c_radioDetection_lastInterceptTime);
        if (_interceptCooldown < 0) then { _interceptCooldown = 0 };
        systemChat format ["  Radio Detection: %1 | PTT: %2 (%3s) | Intercept cooldown: %4s",
            ["INACTIVE", "ACTIVE"] select _radioActive,
            ["OFF", "ON"] select _transmitting,
            _txDuration toFixed 1,
            _interceptCooldown toFixed 0
        ];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 22. SIMULATE VOICE DETECTION
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff66ff'>[DBG] Simulate Voice Detection</t>", {
        params ["_target"];

        if !(isClass (configFile >> "CfgPatches" >> "task_force_radio")) exitWith {
            systemChat "TFAR not loaded — cannot simulate.";
        };

        private _voiceVol = _target getVariable ["tf_voiceVolume", 0.6];
        private _radius = switch (true) do {
            case (_voiceVol <= 0.2): { 15 };
            case (_voiceVol <= 0.6): { 50 };
            default { 120 };
        };

        private _eventGroup = if !(isNil "vgm_c_voiceDetection_locEventGroup") then {
            vgm_c_voiceDetection_locEventGroup
        } else {
            if !(isNil "vgm_g_dangerReport_defaultLocEventGroup") then {
                vgm_g_dangerReport_defaultLocEventGroup
            } else {
                "default"
            };
        };

        [
            _eventGroup,
            getPosASL _target,
            _radius,
            "player_voice",
            [_target]
        ] call vgm_g_fnc_locEvents_triggerEvent;

        private _nearbyAI = {side group _x == east && alive _x && _x distance2D _target < _radius} count allUnits;
        systemChat format ["Voice event fired: radius %1m, %2 OPFOR in range. Watch for AI reaction.", _radius, _nearbyAI];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 23. SIMULATE RADIO INTERCEPT
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff66ff'>[DBG] Simulate Radio Intercept (+6 Alertness)</t>", {
        params ["_target"];

        private _missionId = if !(isNil "vgm_c_radioDetection_missionId") then {
            vgm_c_radioDetection_missionId
        } else {
            // Fallback: try to get from group variable
            group _target getVariable ["vgm_g_missionId", -1]
        };

        if (_missionId == -1) exitWith {
            systemChat "No active mission — cannot simulate radio intercept.";
        };

        [_missionId] remoteExecCall ["vgm_s_fnc_director_onRadioTransmission", 2];
        systemChat format ["Radio intercept simulated for mission %1 — +6 alertness sent to server.", _missionId];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 24. TOGGLE TFAR MONITOR (Live HUD)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff66ff'>[DBG] Toggle TFAR Monitor</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_tfarMonitor", false]);
        _target setVariable ["dbg_tfarMonitor", _on];

        if (_on) then {
            if !(isClass (configFile >> "CfgPatches" >> "task_force_radio")) exitWith {
                systemChat "TFAR not loaded — monitor disabled.";
                _target setVariable ["dbg_tfarMonitor", false];
            };

            VGM_DEBUG_TFAR_MONITOR_LOOP = [] spawn {
                while {player getVariable ["dbg_tfarMonitor", false]} do {
                    private _voiceVol = player getVariable ["tf_voiceVolume", 0.6];
                    private _voiceRadius = switch (true) do {
                        case (_voiceVol <= 0.2): { 15 };
                        case (_voiceVol <= 0.6): { 50 };
                        default { 120 };
                    };
                    private _voiceLabel = switch (true) do {
                        case (_voiceVol <= 0.2): { "WHISPER" };
                        case (_voiceVol <= 0.6): { "NORMAL" };
                        default { "YELLING" };
                    };

                    private _transmitting = vgm_c_radioDetection_tangentStartTime > 0;
                    private _txDuration = if (_transmitting) then { time - vgm_c_radioDetection_tangentStartTime } else { 0 };
                    private _interceptCooldown = 30 - (time - vgm_c_radioDetection_lastInterceptTime);
                    if (_interceptCooldown < 0) then { _interceptCooldown = 0 };
                    private _timeToIntercept = if (_transmitting) then { 5 - _txDuration max 0 } else { 0 };

                    // Count nearby OPFOR at various ranges
                    private _ai25 = 0; private _ai50 = 0; private _ai100 = 0; private _ai200 = 0;
                    {
                        if (side group _x == east && alive _x) then {
                            private _d = _x distance2D player;
                            if (_d < 25) then { _ai25 = _ai25 + 1 };
                            if (_d < 50) then { _ai50 = _ai50 + 1 };
                            if (_d < 100) then { _ai100 = _ai100 + 1 };
                            if (_d < 200) then { _ai200 = _ai200 + 1 };
                        };
                    } forEach allUnits;

                    // Highlight if AI is within voice detection radius
                    private _inVoiceRange = switch (true) do {
                        case (_voiceRadius <= 15): { _ai25 };
                        case (_voiceRadius <= 50): { _ai50 };
                        default { _ai100 };
                    };
                    private _voiceWarning = if (_inVoiceRange > 0) then {
                        format ["  !! %1 OPFOR CAN HEAR YOU !!", _inVoiceRange]
                    } else { "" };

                    private _txt = format [
                        "--- TFAR MONITOR ---\nVoice: %1 (vol %2) | Radius: %3m\nPTT: %4 | Held: %5s | Intercept in: %6s\nIntercept Cooldown: %7s\n\nOPFOR Nearby:\n  <25m: %8 | <50m: %9 | <100m: %10 | <200m: %11\n%12",
                        _voiceLabel, _voiceVol toFixed 2, _voiceRadius,
                        ["OFF", "ON"] select _transmitting,
                        _txDuration toFixed 1,
                        if (_transmitting && _timeToIntercept > 0) then { _timeToIntercept toFixed 1 } else { "---" },
                        if (_interceptCooldown > 0) then { _interceptCooldown toFixed 0 } else { "READY" },
                        _ai25, _ai50, _ai100, _ai200,
                        _voiceWarning
                    ];

                    hintSilent _txt;
                    sleep 0.5;
                };
                hintSilent "";
                systemChat "TFAR Monitor: OFF";
            };
            systemChat "TFAR Monitor: ON — live HUD active.";
        } else {
            systemChat "TFAR Monitor turning off...";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 25. MISSION DIRECTOR LIVE MONITOR (HUD)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] Toggle Director Monitor</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_directorMonitor", false]);
        _target setVariable ["dbg_directorMonitor", _on, true];

        if (_on) then {
            // Start server-side data push loop
            (compile format [
                '
                private _player = (allPlayers select {owner _x == %1}) # 0;
                if (isNil "_player") exitWith {};
                while {_player getVariable ["dbg_directorMonitor", false]} do {
                    private _lines = [];
                    private _allMissions = localNamespace getVariable ["vgm_missions", createHashMap];
                    {
                        private _missionId = _x;
                        private _mission = _y;
                        private _director = _mission get "director";
                        if (!isNil "_director") then {
                            private _alertness = _director getOrDefault ["alertness", 0];
                            private _barFull = floor (_alertness / 100 * 20);
                            private _barEmpty = 20 - _barFull;
                            private _bar = "";
                            for "_i" from 1 to _barFull do {_bar = _bar + "#"};
                            for "_i" from 1 to _barEmpty do {_bar = _bar + "-"};

                            private _lastEvent = _director getOrDefault ["lastAlertnessEventTime", 0];
                            private _sinceEvent = serverTime - _lastEvent;
                            private _decayStatus = if (_alertness <= 0) then {"AT ZERO"} else {
                                if (_sinceEvent < 30) then {
                                    format ["COOLDOWN %%1s", (30 - _sinceEvent) toFixed 0]
                                } else {"DECAYING"}
                            };

                            private _lastTracker = _director getOrDefault ["lastTrackerSent", -9999];
                            private _trackerStatus = if (_alertness < 6) then {
                                format ["NEED %%1+", 6]
                            } else {
                                if (_lastTracker < 0) then {"READY"} else {
                                    private _elapsed = serverTime - _lastTracker;
                                    if (_elapsed >= 120) then {"READY"} else {
                                        format ["%%1s", (120 - _elapsed) toFixed 0]
                                    }
                                }
                            };

                            private _vSquads = count (_director getOrDefault ["virtualSquads", createHashMap]);
                            private _trackerCount = 0;
                            {
                                if (_x getVariable ["vgm_isTrackerTeam", false]) then {
                                    _trackerCount = _trackerCount + 1;
                                };
                            } forEach allGroups;

                            private _mortarStatus = if (_alertness >= 85) then {"ARMED"} else {"inactive"};
                            private _shootdownActive = _director getOrDefault ["vgm_s_shootdownActive", false];

                            private _compLzCount = 0;
                            {
                                if ((_y getOrDefault ["missionId", -1]) isEqualTo _missionId) then {
                                    _compLzCount = _compLzCount + 1;
                                };
                            } forEach vgm_s_compromisedLz_occupiedLzs;

                            _lines pushBack format ["--- Mission %%1 ---", _missionId];
                            _lines pushBack format ["Alert: [%%1] %%2/100", _bar, _alertness toFixed 1];
                            _lines pushBack format ["Decay: %%1 | Event: %%2s ago", _decayStatus, _sinceEvent toFixed 0];
                            _lines pushBack format ["Trackers: %%1 grps | Next: %%2", _trackerCount, _trackerStatus];
                            _lines pushBack format ["vSquads: %%1 | Mortar: %%2", _vSquads, _mortarStatus];
                            _lines pushBack format ["Shootdown: %%1 | CompLZ: %%2", ["no","ACTIVE"] select _shootdownActive, _compLzCount];
                        };
                    } forEach _allMissions;
                    if (count _lines == 0) then {_lines = ["No active missions"]};

                    private _opforCount = {side group _x == east && alive _x} count allUnits;
                    private _civCount = {side group _x == civilian && alive _x} count allUnits;
                    _lines pushBack "";
                    _lines pushBack format ["OPFOR: %%1 | Civs: %%2 | Groups: %%3", _opforCount, _civCount, count allGroups];

                    private _txt = "--- MISSION DIRECTOR ---\n" + (_lines joinString "\n");
                    _player setVariable ["dbg_directorMonitor_data", _txt, true];
                    sleep 2;
                };
                _player setVariable ["dbg_directorMonitor_data", nil, true];
                ',
                owner _target
            ]) remoteExec ["call", 2];

            // Client display loop
            VGM_DEBUG_DIRECTOR_MONITOR_LOOP = [] spawn {
                sleep 0.5;
                while {player getVariable ["dbg_directorMonitor", false]} do {
                    private _txt = player getVariable ["dbg_directorMonitor_data", "Waiting for server..."];
                    hintSilent _txt;
                    sleep 1;
                };
                hintSilent "";
            };
            systemChat "Director Monitor: ON";
        } else {
            systemChat "Director Monitor: OFF";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 26. TOGGLE CONVOY MARKERS (Vehicles + Routes)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Toggle Convoy Markers</t>", {
        params ["_target"];
        private _on = !(_target getVariable ["dbg_convoyMarkers", false]);
        _target setVariable ["dbg_convoyMarkers", _on];

        if (_on) then {
            systemChat "Convoy markers: ON (orange=OPFOR truck, cyan=bike, white=civ, blue=boat)";
            VGM_DEBUG_CONVOY_MARKER_LOOP = [] spawn {
                private _markers = [];
                while {player getVariable ["dbg_convoyMarkers", false]} do {
                    {deleteMarkerLocal _x} forEach _markers;
                    _markers = [];
                    private _idx = 0;

                    {
                        if (alive _x && {count crew _x > 0}) then {
                            private _driver = driver _x;
                            if (isNull _driver) then {_driver = (crew _x) # 0};
                            private _crewSide = side group _driver;
                            private _grp = group _driver;
                            private _spd = speed _x;
                            private _grpSize = count units _grp;
                            private _isBoat = _x isKindOf "Ship";

                            private _color = "";
                            private _label = "";

                            if (_crewSide == east) then {
                                if (_x isKindOf "Bicycle") then {
                                    _color = "ColorCivilian"; _label = "BIKE";
                                } else {
                                    _color = "ColorOrange"; _label = "TRUCK";
                                };
                            } else {
                                if (_crewSide == civilian) then {
                                    if (_isBoat) then {
                                        _color = "ColorBlue"; _label = "BOAT";
                                    } else {
                                        _color = "ColorWhite"; _label = "CIV";
                                    };
                                };
                            };

                            if (_color != "") then {
                                private _mName = format ["dbg_conv_%1", _idx];
                                _idx = _idx + 1;
                                private _m = createMarkerLocal [_mName, getPosATL _x];
                                _m setMarkerTypeLocal "o_motor_inf";
                                _m setMarkerColorLocal _color;
                                _m setMarkerSizeLocal [0.6, 0.6];
                                _m setMarkerDirLocal (getDir _x);

                                private _wpInfo = "";
                                private _wps = waypoints _grp;
                                if (count _wps > 0) then {
                                    private _curWp = currentWaypoint _grp;
                                    if (_curWp < count _wps) then {
                                        private _wpPos = waypointPosition [_grp, _curWp];
                                        private _wpDist = _x distance2D _wpPos;
                                        _wpInfo = format [" wp:%1m", _wpDist toFixed 0];
                                    };
                                };

                                _m setMarkerTextLocal format ["%1 %2km/h g:%3%4 %5m",
                                    _label, _spd toFixed 0, _grpSize, _wpInfo,
                                    player distance _x toFixed 0];
                                _markers pushBack _mName;
                            };
                        };
                    } forEach vehicles;

                    sleep 3;
                };
                {deleteMarkerLocal _x} forEach _markers;
                systemChat "Convoy markers: OFF";
            };
        } else {
            systemChat "Convoy markers turning off...";
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 27. SPAWN CRASH SCENE (Static, Map Click)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff3333'>[DBG] Spawn Crash Scene (Map Click)</t>", {
        params ["_target"];
        systemChat "Click the map to spawn a static crash scene. One-shot.";
        VGM_DEBUG_SPAWN_CRASH_EH = addMissionEventHandler ["MapSingleClick", {
            params ["_units", "_pos"];
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_CRASH_EH];
            VGM_DEBUG_SPAWN_CRASH_EH = nil;

            (compile format [
                '
                private _cid = %1;
                private _pos = %2;
                private _result = [_pos, random 360] call vgm_s_fnc_bright_light_createCrashScene;
                (format ["Crash scene spawned at %%1 (%%2 objects)", _pos, count (_result get "sceneObjects")]) remoteExecCall ["systemChat", _cid];
                ',
                owner player,
                _pos
            ]) remoteExec ["call", 2];
            systemChat format ["Spawning crash scene at %1...", _pos];
        }];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 28. SPAWN CAS SHOOTDOWN (Full DShK + Crash, Map Click)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff3333'>[DBG] Spawn CAS Shootdown (Map Click)</t>", {
        params ["_target"];
        systemChat "Click the map to spawn a CAS aircraft that will be shot down by DShK. One-shot.";
        VGM_DEBUG_SPAWN_SHOOTDOWN_EH = addMissionEventHandler ["MapSingleClick", {
            params ["_units", "_pos"];
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_SHOOTDOWN_EH];
            VGM_DEBUG_SPAWN_SHOOTDOWN_EH = nil;

            (compile format [
                '
                [%1, %2] spawn {
                    params ["_cid", "_targetPos"];

                    private _casPool = [
                        "vn_b_air_ah1g_04", "vn_b_air_ah1g_05", "vn_b_air_ah1g_06",
                        "vn_b_air_uh1c_01_01", "vn_b_air_uh1c_02_01", "vn_b_air_uh1c_03_01",
                        "vn_b_air_oh6a_03"
                    ];
                    private _aircraftClass = selectRandom _casPool;

                    private _spawnDir = random 360;
                    private _spawnPos = _targetPos getPos [2000, _spawnDir];
                    _spawnPos set [2, 200];

                    private _aircraft = createVehicle [_aircraftClass, _spawnPos, [], 0, "FLY"];
                    _aircraft setDir (_spawnDir + 180);
                    _aircraft setVelocityModelSpace [0, 60, 0];

                    private _group = createGroup [west, true];
                    private _pilotUnit = _group createUnit ["vn_b_men_sf_06", _spawnPos, [], 0, "NONE"];
                    _pilotUnit moveInDriver _aircraft;
                    if (count allTurrets _aircraft > 0) then {
                        private _gunner = _group createUnit ["vn_b_men_sf_06", _spawnPos, [], 0, "NONE"];
                        _gunner moveInTurret [_aircraft, [0]];
                    };

                    _group setBehaviourStrong "CARELESS";
                    _group setCombatMode "BLUE";
                    private _wp = _group addWaypoint [_targetPos, 100];
                    _wp setWaypointType "LOITER";
                    _wp setWaypointLoiterType "CIRCLE";
                    _wp setWaypointLoiterRadius 400;

                    (format ["CAS aircraft %%1 spawned, flying toward target...", _aircraftClass]) remoteExecCall ["systemChat", _cid];

                    private _timeout = serverTime + 30;
                    waitUntil {sleep 1; _aircraft distance2D _targetPos < 800 || serverTime > _timeout || !alive _aircraft};

                    if (!alive _aircraft) exitWith {
                        "Shootdown aborted: aircraft destroyed" remoteExecCall ["systemChat", _cid];
                    };

                    // --- DShK SHOOTDOWN SEQUENCE ---
                    private _aircraftPos = getPosATL _aircraft;
                    private _aaDir = (_aircraftPos getDir _targetPos) + 90 + random 180;
                    private _aaDist = 800 + random 400;
                    private _aaPos = _aircraftPos getPos [_aaDist, _aaDir];
                    _aaPos set [2, 0];

                    private _aaGroup = createGroup east;
                    _aaGroup deleteGroupWhenEmpty true;
                    private _aaGun = createVehicle ["vn_o_static_dshkm_01", _aaPos, [], 0, "NONE"];
                    private _aaGunner = _aaGroup createUnit ["vn_o_men_nva_02", _aaPos, [], 0, "NONE"];
                    _aaGunner moveInGunner _aaGun;
                    _aaGun setDir (_aaPos getDir _aircraftPos);

                    _aaGroup setCombatMode "RED";
                    _aaGroup setBehaviourStrong "COMBAT";
                    _aaGunner doWatch _aircraft;
                    _aaGunner doTarget _aircraft;
                    _aaGunner commandTarget _aircraft;
                    _aaGun doWatch _aircraft;

                    "DShK engaging aircraft!" remoteExecCall ["systemChat", _cid];
                    sleep 1;

                    if (alive _aaGunner) then {
                        _aaGunner forceWeaponFire [currentWeapon _aaGun, "FullAuto"];
                    };

                    sleep 1;
                    if (!isNull _aircraft && alive _aircraft) then {
                        _aircraft setHitPointDamage ["HitEngine", 0.9];
                        _aircraft setHitPointDamage ["HitHRotor", 1.0];
                    };

                    "Aircraft hit! Going down!" remoteExecCall ["systemChat", _cid];

                    sleep 2;
                    if (!isNull _aaGun) then {
                        if (!isNull _aaGunner) then {deleteVehicle _aaGunner};
                        deleteVehicle _aaGun;
                    };

                    // Wait for crash
                    private _crashTimeout = serverTime + 30;
                    waitUntil {
                        sleep 0.5;
                        isNull _aircraft || !alive _aircraft ||
                        (getPosATL _aircraft select 2) < 3 || serverTime > _crashTimeout
                    };

                    private _crashPos = if (!isNull _aircraft) then {getPosATL _aircraft} else {_aircraftPos};
                    _crashPos set [2, 0];

                    if (!isNull _aircraft) then {
                        {deleteVehicle _x} forEach crew _aircraft;
                        deleteVehicle _aircraft;
                    };

                    // Map aircraft to wreck class
                    private _wreckMap = createHashMapFromArray [
                        ["vn_b_air_ah1g_04",    ["vn_air_ah1g_01_wreck", 2]],
                        ["vn_b_air_ah1g_05",    ["vn_air_ah1g_01_wreck", 2]],
                        ["vn_b_air_ah1g_06",    ["vn_air_ah1g_01_wreck", 2]],
                        ["vn_b_air_uh1c_01_01", ["vn_air_uh1c_01_wreck", 2]],
                        ["vn_b_air_uh1c_02_01", ["vn_air_uh1c_01_wreck", 2]],
                        ["vn_b_air_uh1c_03_01", ["vn_air_uh1c_01_wreck", 2]],
                        ["vn_b_air_oh6a_03",    ["vn_air_oh6a_01_wreck", 1]]
                    ];
                    private _wreckData = _wreckMap getOrDefault [_aircraftClass, ["vn_air_uh1d_01_wreck", 2]];

                    private _sceneResult = [_crashPos, random 360, _wreckData # 0, "vn_b_men_aircrew_01", _wreckData # 1] call vgm_s_fnc_bright_light_createCrashScene;

                    // Spawn rescue pilot
                    private _pilotPos = _crashPos getPos [5 + random 5, random 360];
                    private _pilotGrp = createGroup west;
                    _pilotGrp deleteGroupWhenEmpty true;
                    private _rescuePilot = _pilotGrp createUnit ["vn_b_men_aircrew_01", _pilotPos, [], 0, "NONE"];
                    _rescuePilot setCaptive true;
                    _rescuePilot setUnconscious true;
                    _rescuePilot setVariable ["vgm_g_medical_isUnconscious", true, true];
                    _rescuePilot setVariable ["vgm_bright_light_target", true, true];
                    ["vgm_carry_enable", [_rescuePilot]] call para_g_fnc_event_triggerGlobal;

                    // Create marker
                    private _markerName = format ["vgm_dbg_shootdown_%%1", floor serverTime];
                    private _marker = createMarker [_markerName, _crashPos getPos [50 + random 50, random 360]];
                    _marker setMarkerType "mil_warning";
                    _marker setMarkerColor "ColorRed";
                    _marker setMarkerText "Downed Aircraft (Debug)";
                    _marker setMarkerAlpha 0.8;

                    (format ["Crash at %%1 — pilot needs rescue! Marker on map.", _crashPos]) remoteExecCall ["systemChat", _cid];

                    // Spawn NVA response when players approach (150m)
                    [_crashPos, _markerName, _rescuePilot, _sceneResult] spawn {
                        params ["_cPos", "_mkr", "_pilot", "_scene"];
                        private _nvaSpawned = false;
                        private _spawnedUnits = [];
                        private _lastBleed = serverTime;

                        while {alive _pilot} do {
                            sleep 2;

                            // Bleed-out
                            private _carried = _pilot getVariable ["vgm_carry_carriedBy", objNull];
                            if (isNull _carried && {serverTime - _lastBleed > 120}) then {
                                _pilot setDamage (damage _pilot + 0.15);
                                _lastBleed = serverTime;
                            };

                            // NVA response on approach
                            if (!_nvaSpawned) then {
                                private _near = allPlayers select {alive _x && _x distance2D _cPos < 150};
                                if (_near isNotEqualTo []) then {
                                    _nvaSpawned = true;
                                    private _enemyClasses = ["vn_o_men_nva_02","vn_o_men_nva_03","vn_o_men_nva_04","vn_o_men_nva_05","vn_o_men_nva_06"];
                                    for "_i" from 1 to (2 + floor random 2) do {
                                        private _sDir = random 360;
                                        private _sPos = _cPos getPos [200 + random 150, _sDir];
                                        private _nGrp = createGroup east;
                                        _nGrp deleteGroupWhenEmpty true;
                                        for "_j" from 1 to (4 + floor random 3) do {
                                            _spawnedUnits pushBack (_nGrp createUnit [selectRandom _enemyClasses, _sPos, [], 10, "NONE"]);
                                        };
                                        _nGrp setBehaviourStrong "AWARE";
                                        _nGrp setCombatMode "RED";
                                        private _wp = _nGrp addWaypoint [_cPos, 30];
                                        _wp setWaypointType "SAD";
                                    };
                                };
                            };

                            // Check rescue complete
                            if (!isNull (_pilot getVariable ["vgm_carry_carriedBy", objNull])) then {
                                if (vehicle _pilot != _pilot) exitWith {};
                            };
                        };

                        // Cleanup after 60s
                        sleep 60;
                        deleteMarker _mkr;
                        {_x hideObjectGlobal false} forEach (_scene get "hiddenTerrainObjects");
                        {if (!isNull _x) then {deleteVehicle _x}} forEach (_scene get "sceneObjects");
                        {if (!isNull _x && alive _x) then {deleteVehicle _x}} forEach _spawnedUnits;
                        if (!isNull _pilot) then {deleteVehicle _pilot};
                    };
                };
                ',
                owner player,
                _pos
            ]) remoteExec ["call", 2];
            systemChat format ["Spawning CAS shootdown at %1...", _pos];
        }];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 29. SPAWN BDA SITE (Map Click)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff3333'>[DBG] Spawn BDA Site (Map Click)</t>", {
        params ["_target"];
        systemChat "Click the map to spawn a BDA site. One-shot.";
        VGM_DEBUG_SPAWN_BDA_EH = addMissionEventHandler ["MapSingleClick", {
            params ["_units", "_pos"];
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_BDA_EH];
            VGM_DEBUG_SPAWN_BDA_EH = nil;

            (compile format [
                '
                private _cid = %1;
                private _pos = %2;
                [-1, _pos] call vgm_s_fnc_bda_buildScene;
                (format ["BDA site spawned at %%1 — watch for mines!", _pos]) remoteExecCall ["systemChat", _cid];
                ',
                owner player,
                _pos
            ]) remoteExec ["call", 2];
            systemChat format ["Spawning BDA site at %1...", _pos];
        }];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 30. SPAWN INSERT HELI (Map Click)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff3333'>[DBG] Spawn Insert Heli (Map Click)</t>", {
        params ["_target"];
        systemChat "Click the map to spawn a UH-1D that will land there. One-shot.";
        VGM_DEBUG_SPAWN_INSERT_EH = addMissionEventHandler ["MapSingleClick", {
            params ["_units", "_pos"];
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_INSERT_EH];
            VGM_DEBUG_SPAWN_INSERT_EH = nil;

            (compile format [
                '
                [%1, %2] spawn {
                    params ["_cid", "_lzPos"];

                    private _spawnDir = random 360;
                    private _spawnPos = _lzPos getPos [2000, _spawnDir];
                    _spawnPos set [2, 50];

                    private _heli = createVehicle ["vn_b_air_uh1d_02_07", _spawnPos, [], 0, "FLY"];
                    _heli setDir (_spawnDir + 180);
                    _heli setVelocityModelSpace [0, 50, 0];

                    private _grp = createGroup [west, true];
                    private _p1 = _grp createUnit ["vn_b_men_sf_06", _spawnPos, [], 0, "NONE"];
                    _p1 moveInDriver _heli;
                    private _p2 = _grp createUnit ["vn_b_men_sf_06", _spawnPos, [], 0, "NONE"];
                    _p2 moveInTurret [_heli, [0]];

                    _grp setBehaviourStrong "CARELESS";
                    _grp setCombatMode "BLUE";

                    private _pad = createVehicle ["Land_HelipadEmpty_F", _lzPos, [], 0, "CAN_COLLIDE"];

                    private _wp = _grp addWaypoint [_lzPos, 0];
                    _wp setWaypointType "MOVE";
                    _wp setWaypointBehaviour "CARELESS";
                    _wp setWaypointStatements ["true", "(vehicle this) land ''GET IN''"];

                    (format ["Insert heli inbound to %%1, ETA ~40s", _lzPos]) remoteExecCall ["systemChat", _cid];

                    // Wait for landing then cleanup after 60s
                    waitUntil {sleep 2; isTouchingGround _heli || !alive _heli};
                    if (!alive _heli) exitWith {};
                    "Insert heli on the ground. Board or wait 60s for departure." remoteExecCall ["systemChat", _cid];
                    sleep 60;

                    if (isNull _heli || !alive _heli) exitWith {deleteVehicle _pad};
                    while {count waypoints _grp > 0} do {deleteWaypoint [_grp, 0]};
                    private _exitPos = _lzPos getPos [5000, random 360];
                    _exitPos set [2, 200];
                    private _wpE = _grp addWaypoint [_exitPos, 0];
                    _wpE setWaypointType "MOVE";
                    _wpE setWaypointSpeed "FULL";
                    sleep 180;
                    if (!isNull _heli) then {{deleteVehicle _x} forEach crew _heli; deleteVehicle _heli};
                    deleteVehicle _pad;
                };
                ',
                owner player,
                _pos
            ]) remoteExec ["call", 2];
            systemChat format ["Calling insert heli to %1...", _pos];
        }];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 31. SPAWN EXTRACT HELI (To Player)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff3333'>[DBG] Spawn Extract Heli (To Me)</t>", {
        params ["_target"];
        private _lzPos = getPosATL _target;

        (compile format [
            '
            [%1, %2] spawn {
                params ["_cid", "_lzPos"];

                private _spawnDir = random 360;
                private _spawnPos = _lzPos getPos [2000, _spawnDir];
                _spawnPos set [2, 50];

                private _heli = createVehicle ["vn_b_air_uh1d_02_07", _spawnPos, [], 0, "FLY"];
                _heli setDir (_spawnDir + 180);
                _heli setVelocityModelSpace [0, 50, 0];

                private _grp = createGroup [west, true];
                private _p1 = _grp createUnit ["vn_b_men_sf_06", _spawnPos, [], 0, "NONE"];
                _p1 moveInDriver _heli;
                private _p2 = _grp createUnit ["vn_b_men_sf_06", _spawnPos, [], 0, "NONE"];
                _p2 moveInTurret [_heli, [0]];

                _grp setBehaviourStrong "CARELESS";
                _grp setCombatMode "BLUE";

                private _pad = createVehicle ["Land_HelipadEmpty_F", _lzPos, [], 0, "CAN_COLLIDE"];

                private _wp = _grp addWaypoint [_lzPos, 0];
                _wp setWaypointType "MOVE";
                _wp setWaypointBehaviour "CARELESS";
                _wp setWaypointStatements ["true", "(vehicle this) land ''GET IN''"];

                (format ["Extract heli inbound to %%1, ETA ~40s. Waits 90s.", _lzPos]) remoteExecCall ["systemChat", _cid];

                waitUntil {sleep 2; isTouchingGround _heli || !alive _heli};
                if (!alive _heli) exitWith {};
                "Extract heli on the ground. Board within 90s." remoteExecCall ["systemChat", _cid];
                sleep 90;

                if (isNull _heli || !alive _heli) exitWith {deleteVehicle _pad};
                while {count waypoints _grp > 0} do {deleteWaypoint [_grp, 0]};
                private _exitPos = _lzPos getPos [5000, random 360];
                _exitPos set [2, 200];
                private _wpE = _grp addWaypoint [_exitPos, 0];
                _wpE setWaypointType "MOVE";
                _wpE setWaypointSpeed "FULL";
                sleep 180;
                if (!isNull _heli) then {{deleteVehicle _x} forEach crew _heli; deleteVehicle _heli};
                deleteVehicle _pad;
            };
            ',
            owner _target,
            _lzPos
        ]) remoteExec ["call", 2];
        systemChat "Calling extract heli to your position...";
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 32. VIEW COMPROMISED LZS
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] View Compromised LZs</t>", {
        params ["_target"];

        if (!isNil "VGM_DEBUG_COMP_LZ_MARKERS") then {
            {deleteMarkerLocal _x} forEach VGM_DEBUG_COMP_LZ_MARKERS;
        };
        VGM_DEBUG_COMP_LZ_MARKERS = [];

        (compile format [
            '
            private _cid = %1;
            private _player = (allPlayers select {owner _x == %1}) # 0;
            private _count = count vgm_s_compromisedLz_occupiedLzs;
            (format ["=== COMPROMISED LZS: %%1 ===", _count]) remoteExecCall ["systemChat", _cid];

            private _lzData = [];
            {
                private _data = _y;
                private _pos = _data getOrDefault ["lzPosition", [0,0,0]];
                private _state = _data getOrDefault ["state", "UNKNOWN"];
                private _defenders = _data getOrDefault ["defenders", []];
                private _defCount = 0;
                {_defCount = _defCount + count units _x} forEach _defenders;
                _lzData pushBack [_pos, _state, _defCount];
                (format ["  LZ: state=%%1 def=%%2 pos=%%3", _state, _defCount, _pos]) remoteExecCall ["systemChat", _cid];
            } forEach vgm_s_compromisedLz_occupiedLzs;

            if (_count == 0) then {
                "  No compromised LZs active." remoteExecCall ["systemChat", _cid];
            };

            _player setVariable ["dbg_compLzData", _lzData, true];
            ',
            owner _target
        ]) remoteExec ["call", 2];

        // Client creates markers after server responds
        [] spawn {
            sleep 1.5;
            private _data = player getVariable ["dbg_compLzData", []];
            {
                _x params ["_pos", "_state", "_defCount"];
                private _mName = format ["dbg_complz_%1", _forEachIndex];
                private _m = createMarkerLocal [_mName, _pos];
                _m setMarkerTypeLocal "mil_warning";
                _m setMarkerColorLocal "ColorRed";
                _m setMarkerSizeLocal [1, 1];
                _m setMarkerTextLocal format ["COMP LZ %1 def:%2", _state, _defCount];
                VGM_DEBUG_COMP_LZ_MARKERS pushBack _mName;
            } forEach _data;
            player setVariable ["dbg_compLzData", nil];
        };
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 33. SPAWN COMPROMISED LZ DEFENDERS (Map Click)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff3333'>[DBG] Spawn Comp. LZ Defenders (Map Click)</t>", {
        params ["_target"];
        systemChat "Click the map to spawn compromised LZ defenders. One-shot.";
        VGM_DEBUG_SPAWN_COMPLZ_EH = addMissionEventHandler ["MapSingleClick", {
            params ["_units", "_pos"];
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_COMPLZ_EH];
            VGM_DEBUG_SPAWN_COMPLZ_EH = nil;

            (compile format [
                '
                private _cid = %1;
                private _lzPos = %2;

                private _mgClasses = vgm_s_compromisedLz_mgClasses;
                private _rifleClasses = vgm_s_compromisedLz_rifleClasses;
                private _defCount = 4 + floor random 4;

                private _grp = createGroup east;
                _grp deleteGroupWhenEmpty true;
                _grp setBehaviourStrong "STEALTH";
                _grp setCombatMode "RED";

                for "_i" from 1 to _defCount do {
                    private _cls = if (random 1 < 0.5) then {selectRandom _mgClasses} else {selectRandom _rifleClasses};
                    private _spawnPos = _lzPos getPos [5 + random 15, random 360];
                    _grp createUnit [_cls, _spawnPos, [], 3, "NONE"];
                };

                private _wp = _grp addWaypoint [_lzPos, 10];
                _wp setWaypointType "GUARD";

                private _key = format ["dbg_complz_%%1", floor serverTime];
                vgm_s_compromisedLz_occupiedLzs set [_key, createHashMapFromArray [
                    ["missionId", -1],
                    ["lzPosition", _lzPos],
                    ["defenders", [_grp]],
                    ["state", "WAITING"]
                ]];

                (format ["Compromised LZ: %%1 defenders at %%2 (key: %%3)", _defCount, _lzPos, _key]) remoteExecCall ["systemChat", _cid];
                ',
                owner player,
                _pos
            ]) remoteExec ["call", 2];
            systemChat format ["Spawning compromised LZ defenders at %1...", _pos];
        }];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 34. FORCE LZ WATCHER (Tracker Near Player)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff9900'>[DBG] Force LZ Watcher</t>", {
        params ["_target"];
        private _playerPos = getPosATL _target;

        (compile format [
            '
            [%1, %2] spawn {
                params ["_cid", "_pos"];

                private _allMissions = localNamespace getVariable ["vgm_missions", createHashMap];
                private _triggered = false;
                {
                    private _director = (_y) get "director";
                    if (!isNil "_director") then {
                        private _current = _director getOrDefault ["alertness", 0];
                        if (_current < 10) then {
                            [_director, 10 - _current] call vgm_s_fnc_director_addAlertness;
                        };

                        private _mission = _y;
                        [_mission, _pos, _cid] spawn {
                            params ["_m", "_p", "_c"];
                            sleep 30;
                            private _players = (units (_m get "public" get "group")) select {isPlayer _x && alive _x};
                            if (_players isEqualTo []) then {_players = allPlayers select {alive _x}};
                            if (_players isNotEqualTo []) then {
                                [_m, _players] call vgm_s_fnc_director_spawnTracker;
                                "LZ Watcher: Tracker team dispatched!" remoteExecCall ["systemChat", _c];
                            } else {
                                "LZ Watcher: No players found for tracker" remoteExecCall ["systemChat", _c];
                            };
                        };
                        _triggered = true;
                    };
                } forEach _allMissions;

                if (_triggered) then {
                    "LZ Watcher: alertness set to 6+, tracker in 30s" remoteExecCall ["systemChat", _cid];
                } else {
                    "No active missions — spawning manual tracker instead" remoteExecCall ["systemChat", _cid];
                    private _spawnPos = _pos getPos [200, random 360];
                    private _size = 4 + floor random 3;
                    private _classes = vgm_s_director_tracker_classes select [0, _size];
                    private _grp = ([_classes, east, _spawnPos] call para_g_fnc_create_squad) # 1;
                    _grp setVariable ["vgm_isTrackerTeam", true, true];
                    _grp setVariable ["vgm_g_missionId", -1, true];
                    [_grp, "enemyAI"] call vgm_s_fnc_btree_setTreeByNameGlobal;
                    private _selectedClient = call para_s_fnc_loadbal_suggest_host;
                    _grp setGroupOwner _selectedClient;
                    (format ["Manual tracker (%%1 units) spawned 200m from player", _size]) remoteExecCall ["systemChat", _cid];
                };
            };
            ',
            owner _target,
            _playerPos
        ]) remoteExec ["call", 2];
        systemChat "Triggering LZ Watcher...";
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 35. DUMP ALL TRACKER DETAILS
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#00ffff'>[DBG] Dump Tracker Details</t>", {
        params ["_target"];

        (compile format [
            '
            private _cid = %1;
            "=== TRACKER DETAILS ===" remoteExecCall ["systemChat", _cid];
            private _trackerCount = 0;
            {
                private _grp = _x;
                if (_grp getVariable ["vgm_isTrackerTeam", false]) then {
                    _trackerCount = _trackerCount + 1;
                    private _ldr = leader _grp;
                    private _alive = {alive _x} count units _grp;
                    private _total = count units _grp;
                    private _dist = if (!isNull _ldr && alive _ldr) then {
                        private _minDist = 99999;
                        {
                            if (isPlayer _x && alive _x) then {
                                private _d = _ldr distance _x;
                                if (_d < _minDist) then {_minDist = _d};
                            };
                        } forEach allUnits;
                        _minDist
                    } else {-1};

                    private _status = "UNKNOWN";
                    private _btreeState = _grp getVariable "vgm_l_btree_state";
                    if (!isNil "_btreeState") then {
                        private _bb = _btreeState get "blackboard";
                        if (!isNil "_bb") then {
                            private _curTrack = _bb getOrDefault ["tracking_currentTrack", createHashMap];
                            private _lastTrack = _bb getOrDefault ["tracking_lastTrack", createHashMap];
                            private _inferring = _bb getOrDefault ["tracking_inferring", false];

                            if ("pos" in _curTrack) then {
                                private _trkAge = (serverTime - (_curTrack getOrDefault ["time", serverTime])) / 60;
                                private _trkDist = if (!isNull _ldr) then {_ldr distance2D (_curTrack get "pos")} else {-1};
                                _status = format ["FOLLOWING trk:%%1min dst:%%2m", _trkAge toFixed 1, _trkDist toFixed 0];
                            } else {
                                if (_inferring) then {
                                    _status = "INFERRING (extrapolating trail)";
                                } else {
                                    if ("pos" in _lastTrack) then {
                                        private _lostAge = (serverTime - (_lastTrack getOrDefault ["time", serverTime])) / 60;
                                        _status = format ["LOST (last:%%1min ago)", _lostAge toFixed 1];
                                    } else {
                                        _status = "SEARCHING (no tracks found)";
                                    };
                                };
                            };
                        };
                    };

                    (format ["  Tracker %%1: %%2/%%3 alive | %%4m away | %%5", _trackerCount, _alive, _total, _dist toFixed 0, _status]) remoteExecCall ["systemChat", _cid];
                };
            } forEach allGroups;

            if (_trackerCount == 0) then {
                "  No tracker teams found." remoteExecCall ["systemChat", _cid];
            };
            ',
            owner _target
        ]) remoteExec ["call", 2];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // 36. SPAWN WIRE TAP (Map Click)
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff3333'>[DBG] Spawn Wire Tap (Map Click)</t>", {
        params ["_target"];
        systemChat "Click the map to spawn a wire tap on the nearest road. One-shot.";
        VGM_DEBUG_SPAWN_WIRETAP_EH = addMissionEventHandler ["MapSingleClick", {
            params ["_units", "_pos"];
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_WIRETAP_EH];
            VGM_DEBUG_SPAWN_WIRETAP_EH = nil;

            (compile format [
                '
                private _cid = %1;
                private _pos = %2;

                // Find nearest road segment
                private _road = roadAt _pos;
                if (isNull _road) then {
                    private _roads = _pos nearRoads 200;
                    if (_roads isNotEqualTo []) then {
                        _road = _roads # 0;
                        {if (_x distance2D _pos < _road distance2D _pos) then {_road = _x}} forEach _roads;
                    };
                };

                if (isNull _road) exitWith {
                    "Wire tap: No road found within 200m." remoteExecCall ["systemChat", _cid];
                };

                private _roadPos = getPos _road;
                private _roadDir = 0;
                private _conn = roadsConnectedTo _road;
                if (count _conn > 0) then {_roadDir = _road getDir (_conn # 0)};

                private _perpDir = _roadDir + 90;
                private _offsetDist = 2 + random 1;
                private _basePos = _roadPos vectorAdd [_offsetDist * sin _perpDir, _offsetDist * cos _perpDir, 0];

                // Two fence posts
                private _postSpacing = (4 + random 2) / 2;
                {
                    private _offset = [1, -1] # _forEachIndex;
                    private _postPos = _basePos vectorAdd [_offset * _postSpacing * sin _roadDir, _offset * _postSpacing * cos _roadDir, 0];
                    private _post = createSimpleObject ["vn_fence_punji_01_10_part1", ATLToASL [_postPos # 0, _postPos # 1, 0], true];
                    _post setDir (_roadDir + (random 10) - 5);
                    _post enableSimulationGlobal false;
                } forEach [0, 1];

                // Junction box — real object for hold action support
                private _wirePos = [_basePos # 0, _basePos # 1, 0];
                private _junctionBox = createVehicle ["vn_o_ammobox_03", _wirePos, [], 0, "CAN_COLLIDE"];
                _junctionBox setDir (_roadDir + random 20 - 10);
                _junctionBox enableSimulationGlobal false;
                _junctionBox allowDamage false;
                _junctionBox setVariable ["vgm_wireTap_active", true, true];
                _junctionBox setVariable ["vgm_wireTap_missionId", -1, true];

                [_junctionBox, [_wirePos]] remoteExec ["vgm_c_fnc_sites_hints_initObject", 0, true];

                (format ["Wire tap spawned at %%1 (road dir %%2)", _wirePos, round _roadDir]) remoteExecCall ["systemChat", _cid];
                ',
                owner player,
                _pos
            ]) remoteExec ["call", 2];
            systemChat format ["Spawning wire tap near %1...", _pos];
        }];
    }, nil, 0, false, true, "", "true", 5]);

    // =====================================================================
    // DISABLE DEBUG TOOLS
    // =====================================================================
    _actionIds pushBack (_caller addAction ["<t color='#ff0000'>[DBG] Disable Debug Tools</t>", {
        params ["_target"];

        // Turn off all active toggles so loops self-terminate
        _target setVariable ["dbg_godmode", false];
        _target setVariable ["dbg_stealth", false];
        _target setVariable ["dbg_enemyMarkers", false];
        _target setVariable ["dbg_teleport", false];
        _target setVariable ["dbg_civMarkers", false];
        _target setVariable ["dbg_skills", false];
        _target setVariable ["dbg_trackMarkers", false];
        _target setVariable ["dbg_tfarMonitor", false];
        _target setVariable ["dbg_directorMonitor", false, true];
        _target setVariable ["dbg_convoyMarkers", false];

        // Restore damage
        _target allowDamage true;
        _target setCaptive false;

        // Clean up teleport EH
        if (!isNil "VGM_DEBUG_TELEPORT_EH") then {
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_TELEPORT_EH];
            VGM_DEBUG_TELEPORT_EH = nil;
        };

        // Clean up spawn EHs
        if (!isNil "VGM_DEBUG_SPAWN_PATROL_EH") then {
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_PATROL_EH];
            VGM_DEBUG_SPAWN_PATROL_EH = nil;
        };
        if (!isNil "VGM_DEBUG_SPAWN_TRACKER_EH") then {
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_TRACKER_EH];
            VGM_DEBUG_SPAWN_TRACKER_EH = nil;
        };
        if (!isNil "VGM_DEBUG_SPAWN_CRASH_EH") then {
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_CRASH_EH];
            VGM_DEBUG_SPAWN_CRASH_EH = nil;
        };
        if (!isNil "VGM_DEBUG_SPAWN_SHOOTDOWN_EH") then {
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_SHOOTDOWN_EH];
            VGM_DEBUG_SPAWN_SHOOTDOWN_EH = nil;
        };
        if (!isNil "VGM_DEBUG_SPAWN_BDA_EH") then {
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_BDA_EH];
            VGM_DEBUG_SPAWN_BDA_EH = nil;
        };
        if (!isNil "VGM_DEBUG_SPAWN_INSERT_EH") then {
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_INSERT_EH];
            VGM_DEBUG_SPAWN_INSERT_EH = nil;
        };
        if (!isNil "VGM_DEBUG_SPAWN_COMPLZ_EH") then {
            removeMissionEventHandler ["MapSingleClick", VGM_DEBUG_SPAWN_COMPLZ_EH];
            VGM_DEBUG_SPAWN_COMPLZ_EH = nil;
        };

        // Clean up compromised LZ markers
        if (!isNil "VGM_DEBUG_COMP_LZ_MARKERS") then {
            {deleteMarkerLocal _x} forEach VGM_DEBUG_COMP_LZ_MARKERS;
            VGM_DEBUG_COMP_LZ_MARKERS = nil;
        };

        // Clean up track markers + 3D draw handler
        if (!isNil "VGM_DEBUG_TRACK_DRAW3D_EH") then {
            removeMissionEventHandler ["Draw3D", VGM_DEBUG_TRACK_DRAW3D_EH];
            VGM_DEBUG_TRACK_DRAW3D_EH = nil;
        };
        if (!isNil "vgm_l_tracking_trackingGroups") then {
            {
                [_x] call vgm_g_fnc_tracking_debugHideTracks;
            } forEach (keys vgm_l_tracking_trackingGroups);
        };

        // Unapply all debug skills
        {
            private _skill = _y;
            if (!isNil {_skill get "tier"}) then {
                private _code = _skill get "codeUnapply";
                if (!isNil "_code" && {!(_code isEqualTo {})}) then {
                    _target call _code;
                };
            };
        } forEach vgm_skills_pathsHashMap;

        // Remove all debug scroll actions
        private _ids = _target getVariable ["dbg_actionIds", []];
        {_target removeAction _x} forEach _ids;
        _target setVariable ["dbg_actionIds", nil];

        // Allow re-initialization
        VGM_DEBUG_INIT = nil;

        systemChat "Debug tools disabled. Run execVM ""debug_tools.sqf"" to re-enable.";
    }, nil, 0, false, true, "", "true", 5]);

    // Store action IDs on the player for cleanup
    _caller setVariable ["dbg_actionIds", _actionIds];

}, nil, 10, false, true, "", "true", 5];

systemChat "Debug tools ready - use scroll menu to enable.";
