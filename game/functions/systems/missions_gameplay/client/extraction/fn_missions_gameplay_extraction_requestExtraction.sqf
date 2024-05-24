/*
    File: fn_missions_gameplay_extraction_requestExtraction.sqf
    Author: Savage Game Design
    Date: 2024-05-23
    Last Update: 2024-05-24
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [player] call vgm_c_fnc_missions_gameplay_extraction_requestExtraction;
 */

params ["_player", ["_radio", objNull]];

private _fnc_getLzPos = {
    params ["_player", ["_attempts", 0]];

    private _expression = "(3*meadow) + (1-trees) + (1-houses)";
    private _places = selectBestPlaces [_player, 200, _expression, 25, 10];

    if (_places isEqualTo [] && _attempts < 3) exitWith {
        [_player, _attempts + 1] call _fnc_getLzPos // return
    };

    _places param [0, [getPosATL _player, -1]] select 0 // return
};

private _lzPosATL = _player call _fnc_getLzPos;
_lzPosATL set [2, 0];

[call vgm_c_fnc_missions_getCurrentMission get "id", _lzPosATL] remoteExecCall ["vgm_s_fnc_missions_gameplay_extraction_startExtract", 2];

// dialog
_this spawn {
    params ["_player", "_radio"];
    [_player, ["vgm_extraction_request", 100, 1, true]] remoteExec ["say3D", group _player];
    sleep 4;
    [_radio, ["vgm_extraction_response", 100, 1, true]] remoteExec ["say3D", group _player];
};
