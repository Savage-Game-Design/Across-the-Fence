/*
    File: fn_radioJamming_postInit.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Client-side TFAR degradation loop for radio jamming. When the player
        is inside a jammer's radius, TFAR sending distance is silently degraded.
        Closer to the jammer = worse degradation. No hints or notifications.

        TFAR is a soft dependency - if the mod is not loaded, this system
        is completely skipped with no errors.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
*/

// Soft dependency: exit silently if TFAR is not loaded
if !(isClass (configFile >> "CfgPatches" >> "task_force_radio")) exitWith {};

vgm_c_radioJamming_active = false;
vgm_c_radioJamming_degraded = false;

[
    "vgm_mission_deploy_local",
    {
        vgm_c_radioJamming_active = true;

        [] spawn {
            while {vgm_c_radioJamming_active && {alive player}} do {
                sleep 5;

                private _jammers = missionNamespace getVariable ["vgm_s_radioJammer_sites", []];
                private _nearestDist = 99999;

                {
                    private _jammerObj = _x get "object";
                    if (!isNull _jammerObj && {alive _jammerObj}) then {
                        private _dist = player distance2D (_x get "pos");
                        private _radius = _x get "radius";
                        if (_dist < _radius && {_dist < _nearestDist}) then {
                            _nearestDist = _dist;
                        };
                    };
                } forEach _jammers;

                if (_nearestDist < 600) then {
                    // Inside jamming radius - degrade TFAR sending distance
                    // At 150m or closer: 0.1 (almost no range)
                    // At 400m: ~0.5
                    // At 600m edge: ~0.9
                    private _multiplier = linearConversion [150, 600, _nearestDist, 0.1, 1.0, true];

                    // Apply to both SR and LR radios
                    player setVariable ["tf_sendingDistanceMultiplicator", _multiplier];
                    vgm_c_radioJamming_degraded = true;
                } else {
                    // Outside all jammers - restore if previously degraded
                    if (vgm_c_radioJamming_degraded) then {
                        player setVariable ["tf_sendingDistanceMultiplicator", 1.0];
                        vgm_c_radioJamming_degraded = false;
                    };
                };
            };
        };
    }
] call para_g_fnc_event_subscribeLocal;

[
    "vgm_mission_end_local",
    {
        vgm_c_radioJamming_active = false;

        // Restore TFAR sending distance
        if (vgm_c_radioJamming_degraded) then {
            player setVariable ["tf_sendingDistanceMultiplicator", 1.0];
            vgm_c_radioJamming_degraded = false;
        };
    }
] call para_g_fnc_event_subscribeLocal;
