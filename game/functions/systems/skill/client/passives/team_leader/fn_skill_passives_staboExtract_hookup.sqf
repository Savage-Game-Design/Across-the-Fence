/*
    File: fn_skill_passives_staboExtract_hookup.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-05
    Public: No

    Description:
        Group effect for the STABO Rig skill. Applied to ALL team members via
        codeApplyGroup. Subscribes to the rope-dropped event and adds a
        "HOOK UP" hold action. On completion, starts a per-frame position
        handler that hangs the player below the helicopter at the rope end.
        Players remain on the ground until the helicopter lifts off, and
        can freely rotate their camera while hooked.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_staboExtract_hookup
 */

#define HOOKUP_RADIUS 10
#define HOOKUP_HOLD_DURATION 3

params ["_known"];

if (!_known) exitWith {
    [player getVariable ["vgm_c_skill_staboHookup_ropeEh", -1]] call para_g_fnc_event_unsubscribe;
    [player getVariable ["vgm_c_skill_staboHookup_endEh", -1]] call para_g_fnc_event_unsubscribe;
    player setVariable ["vgm_c_skill_staboHookup_ropeEh", nil];
    player setVariable ["vgm_c_skill_staboHookup_endEh", nil];

    // Unhook if currently hooked (PFH self-removes when hooked becomes false)
    if (player getVariable ["vgm_missions_stabo_hooked", false]) then {
        player setVariable ["vgm_missions_stabo_hooked", false, true];
    };
};

// Subscribe to rope-dropped event from server
private _ropeEhId = ["vgm_missions_gameplay_staboRopeDropped", {
    (_this select 0) params ["_missionId", "_helicopter", "_hoverHeight"];

    // Remove previous hold action if any
    private _oldActionId = player getVariable ["vgm_c_skill_staboHookup_holdAction", -1];
    if (_oldActionId > -1) then {
        [player, _oldActionId] call BIS_fnc_holdActionRemove;
    };

    // Add "HOOK UP" hold action
    private _actionId = [
        player,
        localize "STR_VGM_SKILLS_SKILL_STABO_HOOKUP_ACTION",
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
        // Condition to show: must be within HOOKUP_RADIUS of the rope ground position, not already hooked, alive
        toString {
            alive _target
            && {!(_target getVariable ["vgm_missions_stabo_hooked", false])}
            && {
                private _heli = (group _target) getVariable ["vgm_missions_stabo_helicopter", objNull];
                !isNull _heli
                && {_heli getVariable ["vgm_missions_stabo_hookupReady", false]}
                && {
                    private _ropeGroundPos = _heli getVariable ["vgm_missions_stabo_ropeGroundPos", [0,0,0]];
                    _target distance2D _ropeGroundPos < HOOKUP_RADIUS
                }
            }
        },
        "true",
        {},
        {},
        // On complete: start per-frame handler to hang player below helicopter
        {
            params ["_target"];
            private _heli = (group _target) getVariable ["vgm_missions_stabo_helicopter", objNull];
            if (isNull _heli) exitWith {};

            private _hoverHeight = _heli getVariable ["vgm_missions_stabo_hoverHeight", 20];
            private _hookedCount = _heli getVariable ["vgm_missions_stabo_hookedCount", 0];

            // Spacing: first player at rope end, each subsequent 2m higher up the rope
            private _ropeHangOffset = _hoverHeight - (_hookedCount * 2) - 1;

            _target setVariable ["vgm_missions_stabo_hooked", true, true];

            // Increment hooked count on helicopter
            _heli setVariable ["vgm_missions_stabo_hookedCount", _hookedCount + 1, true];

            // Play dangling animation immediately
            _target switchMove "AfalPercMstpSrasWlnrDnon";

            // Per-frame handler: position player below helicopter, clamped to ground.
            // Uses setVelocityTransformation to atomically set position + zero velocity
            // in one call, preventing the falling/jitter caused by gravity between frames.
            // Player is NOT attached to anything, so they keep full infantry camera and
            // can aim/fire their weapon freely (like a littlebird bench).
            // Re-enforces the dangling animation periodically to prevent engine overrides.
            private _pfhId = addMissionEventHandler ["EachFrame", {
                _thisArgs params ["_unit", "_heli", "_ropeHangOffset"];

                if (!alive _unit || isNull _heli || !(_unit getVariable ["vgm_missions_stabo_hooked", false])) exitWith {
                    removeMissionEventHandler ["EachFrame", _thisEventHandler];
                    _unit setVariable ["vgm_missions_stabo_pfhId", nil];
                };

                // Re-enforce animation every ~60 frames to prevent player input overriding it
                if (diag_frameNo % 60 == 0) then {
                    if (animationState _unit != "AfalPercMstpSrasWlnrDnon") then {
                        _unit switchMove "AfalPercMstpSrasWlnrDnon";
                    };
                };

                // Hang point: directly below helicopter center, offset by rope length
                private _heliPosASL = getPosASL _heli;
                private _hangPos = _heliPosASL vectorAdd [0, 0, -_ropeHangOffset];

                // Clamp to ground so player stays on ground until heli lifts
                private _groundASL = getTerrainHeightASL [_hangPos select 0, _hangPos select 1];
                if ((_hangPos select 2) < _groundASL + 0.5) then {
                    _hangPos set [2, _groundASL + 0.5];
                };

                // Atomically set position and zero velocity — no physics gap between frames
                private _dir = vectorDir _unit;
                _unit setVelocityTransformation [
                    _hangPos, _hangPos,
                    [0,0,0], [0,0,0],
                    _dir, _dir,
                    [0,0,1], [0,0,1],
                    0
                ];
            }, [_target, _heli, _ropeHangOffset]];

            _target setVariable ["vgm_missions_stabo_pfhId", _pfhId];

            hintSilent localize "STR_VGM_SKILLS_SKILL_STABO_HOOKED";
            format ["STABO: %1 hooked up (slot %2)", name _target, _hookedCount + 1] call vgm_g_fnc_logInfo;
        },
        {},
        nil,
        HOOKUP_HOLD_DURATION,
        0,
        false,
        true,
        false
    ] call BIS_fnc_holdActionAdd;

    player setVariable ["vgm_c_skill_staboHookup_holdAction", _actionId];

    // Officer hook-up: scan for a snatch target that can be attached to the STABO rig
    private _officer = objNull;
    {
        if (_x getVariable ["vgm_snatch_target", false]
            && {_x getVariable ["vgm_snatch_unconscious", false]}
            && {!(_x getVariable ["vgm_snatch_stabo_hooked", false])}) exitWith {
            _officer = _x;
        };
    } forEach allUnits;

    if (!isNull _officer) then {
        private _officerActionId = player addAction [
            "Hook Up Officer",
            // Action code
            {
                params ["_target", "_caller", "_actionId", "_args"];
                _args params ["_officer", "_helicopter"];

                // Drop officer if player is carrying them
                private _carriedObj = _caller getVariable ["vgm_carry_carriedObject", objNull];
                if (!isNull _carriedObj && {_carriedObj == _officer}) then {
                    [_officer, _caller] remoteExecCall ["vgm_s_fnc_carry_detachRequest", 2];
                    sleep 1;
                };

                // Attach officer to helicopter at next staggered offset (server-side since officer is AI)
                private _hoverHeight = _helicopter getVariable ["vgm_missions_stabo_hoverHeight", 20];
                private _hookedCount = _helicopter getVariable ["vgm_missions_stabo_hookedCount", 0];
                private _zOffset = -(_hoverHeight) + (_hookedCount * 2) + 1;

                [[_officer, _helicopter, _zOffset], {
                    params ["_officer", "_helicopter", "_zOffset"];
                    _officer switchMove "Acts_AidlPercMstpSnonWnonDnon_PlayerDefeated01";
                    _officer attachTo [_helicopter, [0, 1, _zOffset]];
                }] remoteExecCall ["BIS_fnc_call", 2];

                _officer setVariable ["vgm_snatch_stabo_hooked", true, true];
                _helicopter setVariable ["vgm_missions_stabo_hookedOfficer", _officer, true];
                _helicopter setVariable ["vgm_missions_stabo_hookedCount", _hookedCount + 1, true];

                _caller removeAction _actionId;

                hintSilent "Officer hooked to STABO rig";
                format ["STABO: Officer hooked up (slot %1)", _hookedCount + 1] call vgm_g_fnc_logInfo;
            },
            // Args
            [_officer, _helicopter],
            1.5,
            false,
            true,
            "",
            // Condition: near rope ground pos AND near officer AND officer not already hooked
            toString {
                private _heli = (group _target) getVariable ["vgm_missions_stabo_helicopter", objNull];
                !isNull _heli
                && {_heli getVariable ["vgm_missions_stabo_hookupReady", false]}
                && {
                    private _ropeGroundPos = _heli getVariable ["vgm_missions_stabo_ropeGroundPos", [0,0,0]];
                    _target distance2D _ropeGroundPos < 10
                }
                && {
                    private _off = (_this select 3) select 0;
                    _target distance _off < 5
                    && {!(_off getVariable ["vgm_snatch_stabo_hooked", false])}
                }
            }
        ];

        player setVariable ["vgm_c_skill_staboHookup_officerAction", _officerActionId];
    };
}] call para_g_fnc_event_subscribe;

player setVariable ["vgm_c_skill_staboHookup_ropeEh", _ropeEhId];

// Clean up on mission end: unhook player, remove actions
private _endEhId = ["vgm_mission_end_local", {
    if (player getVariable ["vgm_missions_stabo_hooked", false]) then {
        player setVariable ["vgm_missions_stabo_hooked", false, true];
    };

    // Remove hold action
    private _holdActionId = player getVariable ["vgm_c_skill_staboHookup_holdAction", -1];
    if (_holdActionId > -1) then {
        [player, _holdActionId] call BIS_fnc_holdActionRemove;
        player setVariable ["vgm_c_skill_staboHookup_holdAction", -1];
    };

    // Remove officer hook-up action
    private _officerActionId = player getVariable ["vgm_c_skill_staboHookup_officerAction", -1];
    if (_officerActionId > -1) then {
        player removeAction _officerActionId;
        player setVariable ["vgm_c_skill_staboHookup_officerAction", -1];
    };

    // Remove rope visual PFH
    private _ropeVisualPfh = player getVariable ["vgm_c_skill_staboHookup_ropeVisualPfh", -1];
    if (_ropeVisualPfh > -1) then {
        removeMissionEventHandler ["EachFrame", _ropeVisualPfh];
        player setVariable ["vgm_c_skill_staboHookup_ropeVisualPfh", nil];
    };
}] call para_g_fnc_event_subscribe;

player setVariable ["vgm_c_skill_staboHookup_endEh", _endEhId];
