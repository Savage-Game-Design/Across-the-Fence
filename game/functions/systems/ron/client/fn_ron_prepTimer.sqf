/*
    File: fn_ron_prepTimer.sqf
    Author: Atlas
    Date: 2026-03-06
    Last Update: 2026-03-06
    Public: No

    Description:
        Shows a 2-minute prep countdown after RON vote passes.
        Players use this time to set claymores, find cover, etc.
        Displays "Prepare positions — MM:SS" center-screen.

    Parameter(s):
        _deadline - serverTime-based deadline [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_deadline] remoteExecCall ["vgm_c_fnc_ron_prepTimer", 0];
 */

params ["_deadline"];

if (!hasInterface) exitWith {};

// Hint notification
hint "RON approved. Prepare your positions.";

// Show countdown using dynamicText each second
[_deadline] spawn {
    params ["_deadline"];

    while {serverTime < _deadline && {missionNamespace getVariable ["vgm_s_ron_active", false]}} do {
        private _remaining = ceil (_deadline - serverTime);
        private _min = floor (_remaining / 60);
        private _sec = _remaining mod 60;
        private _timeStr = format ["%1:%2", _min, if (_sec < 10) then {format ["0%1", _sec]} else {str _sec}];

        private _color = if (_remaining < 30) then {"#ff4444"} else {if (_remaining < 60) then {"#ffcc00"} else {"#ffffff"}};

        [
            format ["<t font='tt2020base_vn' color='%1' size='0.8' align='center' shadow='2'>Prepare position — %2</t>", _color, _timeStr],
            0, 0.05, 1.1, 0, 0, 789
        ] spawn BIS_fnc_dynamicText;

        sleep 1;
    };
};
