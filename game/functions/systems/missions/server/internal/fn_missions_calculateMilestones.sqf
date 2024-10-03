/*
    File: fn_missions_calculateMilestones.sqf
    Author: Savage Game Design
    Date: 2023-10-15
    Last Update: 2024-10-03
    Public: No

    Description:
        Calculate amount of XP player should gain. Returns an array of "milestones" each awarding an amount of XP.

    Parameter(s):
        _playerId - Id of the player that is being awareded the XP [STRING]

    Returns:
        Experiences to gain [ARRAY]

    Example(s):
        ["SUCCESS", "2"] call vgm_s_fnc_missions_calculateMilestones;
 */

params ["_endType", "_playerId"];

private _milestones = [
    ["mission_participation", 125]
    // ["invincible", 100] // We could give bonus XP for certain things, not being downed at all during the mission etc.
];

if (_endType == "SUCCESS") then {
    _milestones pushBack ["mission_success", 375];
};

// add XP for spotting
call {
    private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;
    private _scoutingData = [_mission get "public" get "id", "scouting"] call vgm_s_fnc_missions_getSystemNetmap;

    private _missionSites = +(_mission get "sites");
    private _guessedSites = _scoutingData get "guessedSites";
    {
        #define SITE_DIST ((_x get "pos") distance2d _guessedPos)

        _x params ["", "_guessedClass", "", "_guessedPos", "_guessId"];
        private _guessIdText = parseNumber _guessId + 1;

        private _nearSites = _missionSites select {SITE_DIST <= 200};
        if (_nearSites isEqualTo []) then {
            _milestones pushBack ["site_spotted_bad", 0, [_guessIdText]];
            continue;
        };

        private _perfectMatch = _nearSites findIf {(_x get "class") == _guessedClass};

        if (_perfectMatch > -1) then {
            _milestones pushBack ["site_spotted_perfect", 200, _guessIdText];

            _missionSites deleteAt _perfectMatch;
        } else {
            _milestones pushBack ["site_spotted_good", 100, _guessIdText];

            _nearSites apply {[SITE_DIST, _x]};
            _nearSites sort false;

            private _goodMatch = _nearSites select 0;

            _missionSites deleteAt (_missionSites find _goodMatch);
        };

    } forEach _guessedSites;
};

_milestones // return
