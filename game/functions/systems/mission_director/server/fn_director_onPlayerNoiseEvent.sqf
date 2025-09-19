/*
    File: fn_director_onPlayerNoiseEvent.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2025-09-19
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

private _highestAlertnessThisEvent = 0;

if (_type isEqualTo "player_flare") then {
    _highestAlertnessThisEvent = _highestAlertnessThisEvent max (vgm_s_director_noiseEventAlertness get _type);
};

if (_type isEqualTo "player_explosion") then {
    _details params ["_projectileConfig"];
    private _projectileInfo = [_projectileConfig] call vgm_g_fnc_dangerReport_getProjectileInfo;
    private _explosionAlertnessValueRange = vgm_s_director_noiseEventAlertness get "player_explosion";
    _highestAlertnessThisEvent = _highestAlertnessThisEvent max (linearConversion [
       0,
       1,
       _projectileInfo get "explosivePower",
       _explosionAlertnessValueRange # 0,
       _explosionAlertnessValueRange # 1
    ]);
};

if (_type isEqualTo "player_gunshots_aggregate") then {
    if (_details getOrDefault ["unsuppressedShots", 0] > 0) exitWith {
        _highestAlertnessThisEvent = _highestAlertnessThisEvent max (vgm_s_director_noiseEventAlertness get "unsuppressedShots");
    };

    if (_details getOrDefault ["suppressedShots", 0] > 0) exitWith {
        _highestAlertnessThisEvent = _highestAlertnessThisEvent max (vgm_s_director_noiseEventAlertness get "suppressedShots");
    };
};

private _alertnessPeriodEnd = _directorData get "alertnessPeriodEnd";
private _alertnessAddedThisPeriod = _directorData get "alertnessAddedThisPeriod";

if (_alertnessPeriodEnd < serverTime) exitWith {
    [_directorData, _highestAlertnessThisEvent] call vgm_s_fnc_director_addAlertness;
    _directorData set ["alertnessPeriodEnd", serverTime + vgm_s_director_alertness_period_secs];
    _directorData set ["alertnessAddedThisPeriod", _highestAlertnessThisEvent];
};

// Still in an alertness aggregation period, increase alertness if something more dramatic happened.
if (_alertnessAddedThisPeriod < _highestAlertnessThisEvent) then {
    [_directorData, _highestAlertnessThisEvent - _alertnessAddedThisPeriod] call vgm_s_fnc_director_addAlertness;
};


