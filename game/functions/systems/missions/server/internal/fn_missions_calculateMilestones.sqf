/*
    File: fn_missions_calculateMilestones.sqf
    Author: Savage Game Design
    Date: 2023-10-15
    Last Update: 2024-12-05
    Public: No

    Description:
        Calculate amount of XP player should gain. Returns an array of "milestones" each awarding an amount of XP.

    Parameter(s):
        _endType - Mission end type, SUCCESS or FAILURE [STRING]
        _playerId - Id of the player that is being awareded the XP [STRING]

    Returns:
        Experiences to gain [ARRAY]

    Example(s):
        ["SUCCESS", "2"] call vgm_s_fnc_missions_calculateMilestones;
 */

params ["_endType", "_playerId"];

private _milestones = [];

if (_endType == "SUCCESS") then {
    _milestones pushBack ["mission_success", 50];
};

// add XP for spotting
call {
    #define SEARCH_RADIUS 200

    private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;
    private _scoutingData = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;

    private _missionSites = +((_mission get "public" get "targetZone") call vgm_s_fnc_missions_zones_getSites);
    private _guessedSites = _scoutingData get "guessedSites";
    {

        _x params ["", "_guessedClass", "", "_guessedPos", "_guessId"];
        if (_guessedPos isEqualTo []) then {continue};
        private _guessIdText = parseNumber _guessId + 1;

        private _nearSitesIndexes = _missionSites apply {_x get "pos"} inAreaArrayIndexes [_guessedPos, SEARCH_RADIUS, SEARCH_RADIUS];
        if (_nearSitesIndexes isEqualTo []) then {
            _milestones pushBack ["site_spotted_bad", 0, [_guessIdText]];
            continue;
        };

        private _perfectMatchIndexOfIndex = _nearSitesIndexes findIf {((_missionSites select _x) get "class") == _guessedClass};

        /*
            TODO place for improvment.
            Current algorithm is imperfect, if good spot is before a perfect spot very close to eachother,
            it might be counted first and invalidate the perfect one due to removal of the site from the list.
            It should be a very rare case which is likely to happen only if player spams sites in the same area trying to abuse the system.
        */
        if (_perfectMatchIndexOfIndex > -1) then {
            _milestones pushBack ["site_spotted_perfect", 200, [_guessIdText]];

            _missionSites deleteAt (_nearSitesIndexes select _perfectMatchIndexOfIndex);
        } else {
            _milestones pushBack ["site_spotted_good", 100, [_guessIdText]];

            private _nearSitesIndexesByDist = _nearSitesIndexes apply {[((_missionSites select _x) get "pos") distance2D _guessedPos, _x]};
            _nearSitesIndexesByDist sort true;

            private _goodMatchIndex = _nearSitesIndexesByDist select 0 select 1;

            _missionSites deleteAt _goodMatchIndex;
        };

    } forEach _guessedSites;
};

// zero it out for failure
if (_endType == "FAILURE") then {
    private _xp = 0;
    {
        _xp = _xp + (_x param [1, 0]);
    } forEach _milestones;

    _milestones pushBack ["mission_failure", -_xp];
};

_milestones // return
