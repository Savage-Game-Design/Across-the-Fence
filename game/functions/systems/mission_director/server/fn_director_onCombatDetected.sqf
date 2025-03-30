/*
    File: fn_director_onCombatDetected.sqf
    Author:
    Date: 2025-03-29
    Last Update: 2025-03-30
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_group", "_targets"];

// Nothing we can do if the AI is fighting ghosts. Generally shouldn't happen though.
if (_targets isEqualTo []) exitWith {
    [format ["Director: AI group %1 reported combat against no targets", _group]] call vgm_g_fnc_logWarning;
};

private _missionId = _group getVariable ["vgm_g_missionId", -1];
private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
if (isNil "_director") exitWith {};

private _engagementPos = getPosATL selectRandom _targets;
private _engagementsIndex = _director get "engagementsIndex";
private _nearbyEngagements = [
    _engagementsIndex,
    [_engagementPos, vgm_s_director_engagementRadius, vgm_s_director_engagementRadius]
] call vgm_g_fnc_posindex_inAreaArray;

private _groupHash = hashValue _group;
private _groupsEntry = [_group, _groupHash];

if (_nearbyEngagements isNotEqualTo []) exitWith {
    // Really we should combine multiple nearby engagements. But this is quick and cheap, and it should rarely happen anyway.
    private _selectedEngagement = selectRandom _nearbyEngagements;
    _selectedEngagement get "groups" set [_groupHash, _groupsEntry];
};

private _newEngagement = createHashMapFromArray [
    ["pos", _engagementPos],
    // Use a hashmap as an array would require pushBackUnique.
    // That would be fine for most missions, but would become a performance issue if custom mission makers increase max group count.
    ["groups", createHashMapFromArray [[_groupHash, _groupsEntry]]],
    ["startedAt", serverTime]
];

[_engagementsIndex, _newEngagement] call vgm_g_fnc_posindex_add;
