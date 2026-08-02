#include "macros.inc"
/*
    File: fn_displayTrackIndicator.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Handles the Track Indicator HUD — a signal-bar meter that shows the
        player's current footprint trail visibility based on stance and speed.
        Mirrors the server-side track level logic from fn_tracking_recordTracks.

    Parameter(s):
        _mode - One of the switch-cases [STRING]
        _params - Parameters from the event [ARRAY]

    Returns:
        Nothing [NIL]

    Example(s):
        ["onLoad", [_display]] call vgm_c_fnc_displayTrackIndicator;
*/

#define SELF vgm_c_fnc_displayTrackIndicator

#if __A3_DEBUG__
    diag_log ["fn_displayTrackIndicator", _this];
#endif

params ["_mode", "_params"];
_this = _params;

switch _mode do {
    case "onLoad": {
        params ["_display"];
        uiNamespace setVariable ["VGM_RscDisplayTrackIndicator", _display];

        // Gather bar controls
        private _bars = [
            VGM_IDC_RSCTRACK_BAR1,
            VGM_IDC_RSCTRACK_BAR2,
            VGM_IDC_RSCTRACK_BAR3,
            VGM_IDC_RSCTRACK_BAR4,
            VGM_IDC_RSCTRACK_BAR5
        ] apply { _display displayCtrl _x };

        // Color palette per bar index (0-4)
        private _activeColors = [
            [0.2, 0.8, 0.2, 0.8],  // bar 1: green
            [0.2, 0.8, 0.2, 0.8],  // bar 2: green
            [0.8, 0.8, 0.2, 0.8],  // bar 3: yellow
            [1.0, 0.6, 0.2, 0.8],  // bar 4: orange
            [1.0, 0.3, 0.2, 0.8]   // bar 5: red
        ];
        private _dimColor = [0.3, 0.3, 0.3, 0.3];

        // Start throttled EachFrame updater (0.25s interval)
        private _ehId = addMissionEventHandler ["EachFrame", {
            _thisArgs params ["_bars", "_activeColors", "_dimColor", "_lastUpdate"];

            private _now = diag_tickTime;
            if (_now - _lastUpdate < 0.25) exitWith {};
            _thisArgs set [3, _now];

            private _unit = player;

            // Compute track level (mirrors fn_tracking_recordTracks logic)
            private _level = 0;

            // Clean Sweep check
            if (_unit getVariable ["vgm_g_skill_cleanSweep_active", false]) then {
                _level = 0;
            } else {
                private _stance = stance _unit;
                // vectorMagnitude velocity captures all directions (sideways strafing, rolling)
                private _spd = vectorMagnitude velocity _unit;
                _level = switch (_stance) do {
                    case "PRONE": { if (_spd < 0.1) then { 0 } else { 1 } };
                    case "CROUCH": {
                        if (_spd < 0.1) then { 0 }
                        else { if (_spd < 1.8) then { 1 }   // crouch walk / tactical pace
                        else { 2 } };                        // crouch jog
                    };
                    default {
                        if (_spd < 0.1) then { 0 }
                        else { if (_spd < 2.5) then { 3 }   // walk
                        else { if (_spd < 4.0) then { 4 }   // jog
                        else { 5 } } };                      // sprint
                    };
                };

                // Lightfooted: reduce level by 1 when alone
                if (_unit getVariable ["vgm_g_skill_lightfooted", false]) then {
                    private _nearbyFriendlies = (units group _unit) select {
                        _x != _unit && alive _x && _x distance _unit < 100
                    };
                    if (count _nearbyFriendlies == 0) then {
                        _level = (_level - 1) max 1;
                    };
                };
            };

            // Apply colors to bars
            {
                private _i = _forEachIndex;
                if (_i < _level) then {
                    _x ctrlSetBackgroundColor (_activeColors select _i);
                } else {
                    _x ctrlSetBackgroundColor _dimColor;
                };
            } forEach _bars;
        }, [_bars, _activeColors, _dimColor, 0]];

        _display setVariable ["vgm_trackIndicator_ehId", _ehId];
    };

    case "onUnload": {
        params ["_display"];
        private _ehId = _display getVariable ["vgm_trackIndicator_ehId", -1];
        if (_ehId >= 0) then {
            removeMissionEventHandler ["EachFrame", _ehId];
        };
        uiNamespace setVariable ["VGM_RscDisplayTrackIndicator", displayNull];
    };
};
