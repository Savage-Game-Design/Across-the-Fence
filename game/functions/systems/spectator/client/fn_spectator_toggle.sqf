/*
    File: spectator_toggle.sqf
    Author: Savage Game Design
    Date: 2026-04-05
    Last Update: 2026-04-08
    Public: No

    Description:
        Toggles spectator mode

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_spectator_toggle;
 */

params [["_allowClosing", true, [true]]];

if (["IsSpectating", [player]] call BIS_fnc_EGSpectator) exitWith {
    ["Terminate", []] call BIS_fnc_EGSpectator;
};

if (_allowClosing) then {
    [] spawn {
        private _display = displayNull;
        waitUntil { _display = ["GetDisplay"] call BIS_fnc_EGSpectator; !isNull _display };

        // Get the camera groups control. We want to add a spectator button directly above it.
        private _cameraGroup = _display displayCtrl 52909;

        private _button = _display ctrlCreate ["ctrlButton", -1];

        _button ctrlSetText "Stop spectating";
        //_button ctrlCommit 0;
        private _width = pixelW * 200;
        private _height = ctrlTextHeight _button * 2;

        private _xPos = 0.5 - _width / 2;
        private _yPos = (ctrlPosition _cameraGroup # 1) - _height;

        _button ctrlSetPosition [_xPos, _yPos, _width, _height];
        _button ctrlCommit 0;

        _button ctrlAddEventHandler ["ButtonClick", { ["Terminate"] call BIS_fnc_EGSpectator }];
    };
};

["Initialize", [
    // Player is spectating
    player,
    // Only allow US and civilian (in case captive messes with it)
    [west, civilian],
    // Disable AI
    false
]] call BIS_fnc_EGSpectator;
