/*
    File: fn_missions_getTeamMembers.sqf
    Author: Savage Game Design
    Date: 2025-11-29
    Last Update: 2025-11-29
    Public: Yes

    Description:
        Fetches the team members on the player's current mission.

    Parameter(s):
        None

    Returns:
        Team members (units) [ARRAY]

    Example(s):
        [] call vgm_c_fnc_missions_getTeamMembers;
 */

private _mission = [] call vgm_c_fnc_missions_getCurrentMission;

if (isNil "_mission") then {
    [player]
} else {
    units (_mission get "group") select { isPlayer _x }
}
