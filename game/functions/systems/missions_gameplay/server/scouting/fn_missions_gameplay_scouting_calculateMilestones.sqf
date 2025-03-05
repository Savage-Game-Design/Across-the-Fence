/*
    File: fn_missions_gameplay_scouting_calculateMilestones.sqf
    Author: Savage Game Design
    Date: 2025-02-25
    Last Update: 2025-03-05
    Public: No

    Description:
        Calculate amount of XP player should gain for guessing sites in a mission.

    Parameter(s):
        _playerId - Id of the player that is being awareded the XP [STRING]
        _milestones - Array of milestones to be updated [ARRAY]

    Returns:
        Nothing

    Example(s):
        [_playerId, _milestones get "scouting"] call vgm_s_fnc_missions_gameplay_scouting_calculateMilestones;
 */

#define SEARCH_RADIUS 90

params ["_playerId", "_milestones"];

private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;
private _scoutingData = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;

private _missionSites = +((_mission get "public" get "targetZone") call vgm_s_fnc_missions_zones_getSites);
private _guessedSites = _scoutingData get "guessedSites";
// scoring
// 0-100 for position
// 0-100 for photos
// 0-25 for type
// up to 225 XP total
{
    _x params ["", "_guessedClass", "", "_guessedPos", "_guessId", "_guessPhoto"];

    private _siteMilestone = createHashMapFromArray [["index", parseNumber _guessId + 1]];
    private _milestoneEntry = [_siteMilestone, 0];
    _milestones pushBack _milestoneEntry;

    // if the guess has no position, it is not useful
    if (_guessedPos isEqualTo []) then {
        _siteMilestone set ["position", ["not_complete", 0]];

        continue;
    };

    private _nearSitesIndexes = (_missionSites apply {_x get "pos"}) inAreaArrayIndexes [_guessedPos, SEARCH_RADIUS, SEARCH_RADIUS];
    // not a single site near guessed position, it is not useful
    if (_nearSitesIndexes isEqualTo []) then {
        _siteMilestone set ["position", ["not_usable", 0]];

        continue;
    };

    private _nearSitesIndexesByDist = _nearSitesIndexes apply {[((_missionSites select _x) get "pos") distance2D _guessedPos, _x]};
    _nearSitesIndexesByDist sort true;

    (_nearSitesIndexesByDist select 0) params ["_closestSiteDistance", "_closestSiteIndex"];
    private _closestSite = _missionSites deleteAt _closestSiteIndex;

    _siteMilestone set ["position", call {
        if (_closestSiteDistance <= 12.5) exitWith {
            ["spot_on", 100]
        };
        if (_closestSiteDistance <= 20) exitWith {
            ["very_close", 75]
        };
        if (_closestSiteDistance <= 45) exitWith {
            ["close", 50]
        };

        ["far", 25]
    }];

    _siteMilestone set ["type", call {
        if ((_closestSite get "class") == _guessedClass) exitWith {
            ["correct", 25]
        };

        ["incorrect", 0]
    }];

    _siteMilestone set ["photo", call {
        if (_guessPhoto isEqualTo createHashMap) exitWith {
            ["missing", 0]
        };

        private _photoObjects = _guessPhoto get (_closestSite get "id");
        if (isNil "_photoObjects") exitWith {
            format ["Photo does not contain site it is assigned to: %1", _guessId] call vgm_g_fnc_logInfo;

            ["invalid", 0]
        };

        _photoObjects params ["_foregroundObjects", "_backgroundObjects", "_allSpottableObjects"];
        private _photoQuality = ((count _foregroundObjects + count _backgroundObjects) * 100) / count _allSpottableObjects;

        if (_photoQuality < 15) exitWith {
            format ["Photo quality too low: %1, %2", _guessId, _photoQuality] call vgm_g_fnc_logInfo;

            ["unusable", 0]
        };

        format ["Photo usable: %1, %2", _guessId, _photoQuality] call vgm_g_fnc_logInfo;

        // calculate XP based on photo quality
        call {
            if (_photoQuality < 35) exitWith {
                ["blurry", 25]
            };
            if (_photoQuality <= 55) exitWith {
                ["grainy", 50]
            };
            if (_photoQuality <= 85) exitWith {
                ["detailed", 75]
            };

            ["perfect", 100]
        };
    }];

    _milestoneEntry set [
        1,
        (_siteMilestone get "position" select 1)
        + (_siteMilestone get "type" select 1)
        + (_siteMilestone get "photo" select 1)
    ];
} forEach _guessedSites;
