/*
    File: fn_director_startMission.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2023-09-24
    Public: Yes

    Description:
        Starts the mission director running on a new mission.

        Generally, this should be called when a mission is started, as the players are deploying.

        Handles:
            - Mission asset creation
            - Overall mission flow
            - AI quantities and behaviour
            - Ending the mission

    Parameter(s):
        _mission - Mission to monitor [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_director_startMission
 */

params ["_mission"];

private _directorData = _mission getOrDefault ["director", createHashMap, true];

[] remoteExec ["vgm_c_fnc_director_startClientsideMonitoring", values (_mission get "machineIds")];

private _insertionLocation = _mission get "public" get "startPosASL";
private _objective = markerPos "marker_47";


private _unitClasses = "true" configClasses (configFile >> "CfgGroups" >> "East" >> "VN_PAVN" >> "vn_o_group_men_nva" >> "vn_o_group_men_nva_04") apply {getText (_x >> "vehicle")};

private _desiredSquads = 10;

private _angleToObjective = _insertionLocation getDir _objective;
private _spawnAngles = [_angleToObjective + 90, _angleToObjective - 90];
private _spawnIntervalDistance = (_insertionLocation distance2D _objective) /_desiredSquads;

private _squads = [];

for "_i" from 1 to _desiredSquads do {
    private _spawnCenterlinePos = _insertionLocation getPos [_spawnIntervalDistance * _i, _angleToObjective];
    private _spawnPos = _spawnCenterlinePos getPos [100 + random 100, selectRandom _spawnAngles];

    private _squad = [_unitClasses, east, _spawnPos] call para_s_fnc_loadbal_create_squad;
    private _group = _squad select 1;
    _group setVariable ["behaviourEnabled", true, true];
    _group setVariable ["orders", ["patrol", _spawnPos, 100]];
    _squads pushBack _group;
};

_directorData set ["squads", _squads];

// TODO - Start clientside monitoring on JIP players
// Use startDeploy and finishDeploy as events for ease of use.



