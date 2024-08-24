/*
    File: fn_missions_calculateMilestones.sqf
    Author: Savage Game Design
    Date: 2023-10-15
    Last Update: 2024-08-24
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

    private _markedSites = _scoutingData get "markedSites";
    {
        if (_x in _markedSites) then {
            _milestones pushBack ["site_marked", 125];
        } else {
            _milestones pushBack ["site_spotted", 75];
        };
    } forEach (_scoutingData get "objects");
};

_milestones // return
