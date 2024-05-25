#include "\a3\ui_f\hpp\defineDikCodes.inc"
#include "script_component.inc"
/*
    File: fn_progressBar.sqf
    Author: Savage Game Design
    Date: 2023-07-16
    Last Update: 2023-07-17
    Public: Yes

    Description:
        Start progress bar for player action.

    Parameter(s):
        _title - Title of the progress bar [STRING, defaults to ""]
        _duration - Duration in seconds [NUMBER, defaults to 5]
        _fnc_condition - Code executed every tick, must return <BOOL>, progress bar will stop on false [CODE, defaults to {true}]
        _fnc_onSuccess - Code executed on progress bar completion [CODE, defaults to {}]
        _fnc_onFailure - Code executed on progress bar failure [CODE, defaults to {}]
        _arguments - Additional arguments to be passed to callbacks [ANY, defaults to []]
        _blockInput - Should input be blocked during the progress bar [BOOL, defaults to true]

    Returns:
        Nothing

    Example(s):
        ["My progress bar", 10, {
            params ["_args", "_startedAt", "_duration"];
            _args params ["_startPos", "_unit"];
            _startPos distance _unit < 5 // return
        }, {
            params ["_args", "_startedAt", "_duration"];
            systemChat "completed!";
        }, {
            params ["_args", "_startedAt", "_duration", "_reason"];
            // possible reasons: cancelled | condition | overriden
            systemChat format ["failed due to: %1", _reason];
        }, [getPos player, player]] call vgm_c_fnc_progressBar;
*/

#define CLOSE_DISPLAY_BLOCK ((uiNamespace getVariable ["vgm_displayBlockInput", displayNull]) closeDisplay 0)
#define CLOSE_DISPLAY_PROGRESS ("vgm_progressBar" cutText ["", "PLAIN"])

if (!hasInterface) exitWith {
    "Could not open progress bar without interface" call vgm_g_fnc_logError;
};

params [
    ["_title", "", [""]],
    ["_duration", 5, [0]],
    ["_fnc_condition", {true}, [{}]],
    ["_fnc_onSuccess", {}, [{}]],
    ["_fnc_onFailure", {}, [{}]],
    ["_arguments", []],
    ["_blockInput", true, [false]]
];


private _displayPrevious = uiNamespace getVariable ["vgm_rscProgressBar", displayNull];
if (!isNull _displayPrevious) then {
    format ["Cancelling previous progress bar"] call vgm_g_fnc_logInfo;

    (_displayPrevious getVariable "vgm_params") params ["", "", "_fnc_onFailure", "_arguments", "_startedAt", "_duration"];
    [_arguments, _startedAt, _duration, "overriden"] call _fnc_onFailure;
};

"vgm_progressBar" cutRsc ["VGM_RscProgressBar", "PLAIN"];
private _display = uiNamespace getVariable "vgm_rscProgressBar";;

private _ctrlTitle = _display displayCtrl VGM_IDC_PROGRESSBAR_TITLE;
_ctrlTitle ctrlSetText _title;

_display setVariable ["vgm_params", [
    _fnc_condition,
    _fnc_onSuccess,
    _fnc_onFailure,
    _arguments,
    time,
    _duration
]];

private _ctrlDrawHandler = _display displayCtrl VGM_IDC_PROGRESSBAR_DRAWHANDLER;

_ctrlDrawHandler ctrlAddEventHandler ["Draw", {
    params ["_ctrl"];
    private _display = ctrlParent _ctrl;

    (_display getVariable "vgm_params") params ["_fnc_condition", "_fnc_onSuccess", "_fnc_onFailure", "_arguments", "_startedAt", "_duration"];

    private _continue = [_fnc_condition, [_arguments, _startedAt, _duration]] call {
        private ["_display", "_fnc_condition", "_fnc_onSuccess", "_fnc_onFailure", "_arguments", "_startedAt", "_duration"];
        _this#1 call _this#0 // return
    };

    private _elapsedTime = time - _startedAt;

    if (!_continue) exitWith {
        ["Progress bar failed"] call vgm_g_fnc_logInfo;

        [{CLOSE_DISPLAY_PROGRESS}] call vgm_g_fnc_execNextFrame;
        CLOSE_DISPLAY_BLOCK;

        [_arguments, _startedAt, _duration, "condition"] call _fnc_onFailure;
    };

    if (_elapsedTime >= _duration) exitWith {
        ["Progress bar succeeded"] call vgm_g_fnc_logInfo;

        [{CLOSE_DISPLAY_PROGRESS}] call vgm_g_fnc_execNextFrame;
        CLOSE_DISPLAY_BLOCK;

        [_arguments, _startedAt, _duration] call _fnc_onSuccess;
    };

    private _ctrlProgress = _display displayCtrl VGM_IDC_PROGRESSBAR_PROGRESSBAR;
    _ctrlProgress progressSetPosition (_elapsedTime / _duration);
}];

CLOSE_DISPLAY_BLOCK;

if (_blockInput) then {
    private _displayMission = findDisplay 46;
    private _blockInputDisplay = _displayMission createDisplay "RscDisplayEmpty";
    uiNamespace setVariable ["vgm_displayBlockInput", _blockInputDisplay];

    _blockInputDisplay displayAddEventHandler ["KeyDown", {
        params ["_display", "_key", "_shift", "_control", "_alt"];

        if (_key == DIK_ESCAPE) exitWith {
            format ["Cancelling current progress bar"] call vgm_g_fnc_logInfo;

            private _displayProgress = uiNamespace getVariable ["vgm_rscProgressBar", displayNull];
            (_displayProgress getVariable "vgm_params") params ["", "", "_fnc_onFailure", "_arguments", "_startedAt", "_duration"];

            CLOSE_DISPLAY_PROGRESS;

            [_arguments, _startedAt, _duration, "cancelled"] call _fnc_onFailure;

            false // do not block input
        };

        true // block input
    }];
};

nil
