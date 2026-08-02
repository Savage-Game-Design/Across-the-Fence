/*
    File: fn_skill_passives_eavesdropping.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Trailing an enemy squad may reveal site information. When the player
        is stealthily following enemies (within range, undetected), there is a
        chance to intercept useful intel about nearby sites.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_eavesdropping
 */

#define CHECK_INTERVAL 10
#define EAVESDROP_RANGE 50
#define EAVESDROP_CHANCE 0.15

params ["_known"];

if (!_known) exitWith {
    removeMissionEventHandler ["EachFrame", vgm_c_skill_passives_eavesdropping_eh];
};

vgm_c_skill_passives_eavesdropping_nextCheck = 0;
vgm_c_skill_passives_eavesdropping_revealed = createHashMap;

vgm_c_skill_passives_eavesdropping_eh = addMissionEventHandler ["EachFrame", {
    if (time < vgm_c_skill_passives_eavesdropping_nextCheck) exitWith {};
    vgm_c_skill_passives_eavesdropping_nextCheck = time + CHECK_INTERVAL;

    // Must be undetected
    if (player getVariable ["vgm_g_stealth_isVisible", false]) exitWith {};

    // Check for nearby enemies
    private _nearbyEnemies = player nearEntities ["CAManBase", EAVESDROP_RANGE];
    _nearbyEnemies = _nearbyEnemies select {side _x != side player && alive _x};

    if (count _nearbyEnemies < 2) exitWith {}; // Need a squad (2+ enemies)

    // Random chance to intercept intel
    if (random 1 > EAVESDROP_CHANCE) exitWith {};

    // Get current mission
    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (isNil "_currentMission") exitWith {};

    private _sites = (_currentMission get "public" get "targetZone") call vgm_g_fnc_missions_zones_getSites;
    if (_sites isEqualTo []) exitWith {};

    // Find the nearest unrevealed site
    private _playerPos = getPosATL player;
    private _bestSite = objNull;
    private _bestDist = 1e10;
    private _bestSiteId = "";

    {
        private _siteId = _x get "id";
        if (_siteId in vgm_c_skill_passives_eavesdropping_revealed) then { continue };

        private _dist = _playerPos distance2D (_x get "pos");
        if (_dist < _bestDist) then {
            _bestDist = _dist;
            _bestSite = _x;
            _bestSiteId = _siteId;
        };
    } forEach _sites;

    if (_bestSiteId == "") exitWith {};

    // Mark as revealed
    vgm_c_skill_passives_eavesdropping_revealed set [_bestSiteId, true];

    // Show intel message with approximate direction
    private _sitePos = _bestSite get "pos";
    private _spokenDirection = [_playerPos, _sitePos] call vgm_g_fnc_spokenDirection;

    private _message = format [
        localize "STR_VGM_SKILLS_SKILL_EAVESDROPPING_INTEL",
        _spokenDirection
    ];

    ["", _message] call BIS_fnc_showSubtitle;

    format ["Eavesdropping: Revealed site %1 direction", _bestSiteId] call vgm_g_fnc_logInfo;
}];
