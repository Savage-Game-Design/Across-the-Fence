/*
    File: fn_director_onPlayerNoiseEvent.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2025-08-30
    Public: False

    Description:
        Called when the players make certain noises, such as gunshots, explosions or flares.

    Parameter(s):
        _pos - Position of the event
        _type - Event type
        _details - Details of the specific event
        _args - Arguments provided to the locEvent system

    Returns:
        Nothing

    Example(s):
    [
        _missionId,
        "",
        ["player_gunshot_aggregate", "player_explosion", "player_flare"],
        [_missionId],
        {
            params ["_pos", "_type", "_listener", "_details", "_args"];
            // Filter out listener, as it's irrelevant
            [_pos, _type, _details, _args] call vgm_s_fnc_director_onPlayerNoiseEvent
        }
    ] call vgm_g_fnc_locEvents_onNearbyEvent;

 */

params ["_pos", "_type", "_details", "_args"];

_args params ["_missionId", "_directorData"];

private _alertnessGain = 0;

if (_type in ["player_explosion", "player_flare"]) then {
    _alertnessGain = _alertnessGain + (vgm_s_director_noiseEventAlertness get _type);
};

if (_type isEqualTo "player_gunshots_aggregate") then {
    if (_details getOrDefault ["unsuppressedShots", 0] > 0) exitWith {
        _alertnessGain = _alertnessGain + (vgm_s_director_noiseEventAlertness get "unsuppressedShots");
    };

    if (_details getOrDefault ["suppressedShots", 0] > 0) exitWith {
        _alertnessGain = _alertnessGain + (vgm_s_director_noiseEventAlertness get "suppressedShots");
    };
};

[_directorData, _alertnessGain] call vgm_s_fnc_director_addAlertness;
