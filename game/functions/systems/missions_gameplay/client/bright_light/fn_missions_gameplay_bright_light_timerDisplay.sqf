/*
    File: fn_missions_gameplay_bright_light_timerDisplay.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Client-side function to show/hide the Bright Light mission countdown timer.
        Displays MM:SS top-center with color shifts:
          white (> 5 min) → yellow (< 5 min) → red (< 2 min).
        Purely cosmetic urgency — removed when players reach crash site.

    Parameter(s):
        _deadline - serverTime-based deadline [NUMBER]
        _show     - true to show, false to hide [BOOL]

    Returns:
        Nothing

    Example(s):
        [_deadline, true] call vgm_c_fnc_missions_gameplay_bright_light_timerDisplay;
        [0, false] call vgm_c_fnc_missions_gameplay_bright_light_timerDisplay;
 */

params ["_deadline", "_show"];

if (!_show) exitWith {
    // Remove the timer display
    "vgm_bright_light_timer" cutText ["", "PLAIN"];
    // Remove EachFrame handler
    private _ehId = missionNamespace getVariable ["vgm_c_bright_light_timerEH", -1];
    if (_ehId >= 0) then {
        removeMissionEventHandler ["EachFrame", _ehId];
        missionNamespace setVariable ["vgm_c_bright_light_timerEH", -1];
    };
};

// Show the timer
"vgm_bright_light_timer" cutRsc ["VGM_RscMissionTimer", "PLAIN", -1, false];

// Store deadline
missionNamespace setVariable ["vgm_c_bright_light_deadline", _deadline];

// Remove existing handler if any
private _existingEH = missionNamespace getVariable ["vgm_c_bright_light_timerEH", -1];
if (_existingEH >= 0) then {
    removeMissionEventHandler ["EachFrame", _existingEH];
};

// Start EachFrame handler to update timer text
private _ehId = addMissionEventHandler ["EachFrame", {
    private _deadline = missionNamespace getVariable ["vgm_c_bright_light_deadline", 0];
    if (_deadline <= 0) exitWith {};

    private _display = uiNamespace getVariable ["vgm_RscMissionTimer", displayNull];
    if (isNull _display) exitWith {};

    private _ctrl = _display displayCtrl 9500;
    if (isNull _ctrl) exitWith {};

    private _remaining = _deadline - serverTime;
    if (_remaining < 0) then {_remaining = 0};

    private _minutes = floor (_remaining / 60);
    private _seconds = floor (_remaining mod 60);
    private _minStr = if (_minutes < 10) then {format ["0%1", _minutes]} else {str _minutes};
    private _secStr = if (_seconds < 10) then {format ["0%1", _seconds]} else {str _seconds};
    private _timeStr = format ["%1:%2", _minStr, _secStr];

    // Color based on remaining time
    private _color = "#ffffff"; // white
    if (_remaining < 120) then {
        _color = "#ff3333"; // red < 2 min
    } else {
        if (_remaining < 300) then {
            _color = "#ffcc00"; // yellow < 5 min
        };
    };

    _ctrl ctrlSetStructuredText parseText format ["<t align='center' size='1.2' color='%1' shadow='2'>%2</t>", _color, _timeStr];

    // Auto-hide when timer reaches 0
    if (_remaining <= 0) then {
        "vgm_bright_light_timer" cutText ["", "PLAIN"];
        private _ehId = missionNamespace getVariable ["vgm_c_bright_light_timerEH", -1];
        if (_ehId >= 0) then {
            removeMissionEventHandler ["EachFrame", _ehId];
            missionNamespace setVariable ["vgm_c_bright_light_timerEH", -1];
        };
    };
}];

missionNamespace setVariable ["vgm_c_bright_light_timerEH", _ehId];
