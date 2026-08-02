/*
    File: fn_skill_passives_handrail.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Inspecting a trail reveals the direction to the nearest site within 300m.
        Subscribes to the hint inspection event and provides a compass bearing
        to the nearest site.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_handrail
 */

#define SEARCH_RADIUS 300

params ["_known"];

if (!_known) exitWith {
    [vgm_c_skill_passives_handrail_inspectEh] call para_g_fnc_event_unsubscribe;
};

// Subscribe to hint inspection event - when a hint is inspected, show bearing to nearest site
vgm_c_skill_passives_handrail_inspectEh = ["vgm_sites_hints_inspected", {
    params ["_missionId", "_objectId", "_shouldMarkOnMap"];

    // Get current mission's sites
    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (isNil "_currentMission") exitWith {};

    private _sites = ((_currentMission get "public" get "targetZone") call vgm_g_fnc_missions_zones_getSites);
    if (_sites isEqualTo []) exitWith {};

    // Find nearest site within search radius
    private _playerPos = getPosATL player;
    private _nearestSite = objNull;
    private _nearestDist = SEARCH_RADIUS;
    private _nearestPos = [];

    {
        private _sitePos = _x get "pos";
        private _dist = _playerPos distance2D _sitePos;
        if (_dist < _nearestDist) then {
            _nearestDist = _dist;
            _nearestPos = _sitePos;
        };
    } forEach _sites;

    if (_nearestPos isEqualTo []) exitWith {};

    // Calculate compass bearing
    private _bearing = _playerPos getDir _nearestPos;
    private _spokenDirection = [_playerPos, _nearestPos] call vgm_g_fnc_spokenDirection;

    private _message = format [
        localize "STR_VGM_SKILLS_SKILL_HANDRAIL_DIRECTION",
        _spokenDirection,
        round _nearestDist
    ];

    ["", _message] call BIS_fnc_showSubtitle;
}] call para_g_fnc_event_subscribe;
