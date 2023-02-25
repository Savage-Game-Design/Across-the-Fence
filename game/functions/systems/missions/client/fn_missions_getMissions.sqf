/*
    File: fn_missions_getMissions.sqf
    Author:  Savage Game Design
    Date: 2023-04-07
    Last Update: 2023-04-23
    Public: Yes

    Description:
        Retrieves a list of all missions

    Parameter(s):
        N/A

    Returns:
        Hashmap of all missions indexed by mission id [HASHMAP]

    Example(s):
        [] call vgm_c_fnc_missions_getMissions;
 */

private _missionsData = localNamespace getVariable "vgm_c_missions_data";

_missionsData get "missions"
