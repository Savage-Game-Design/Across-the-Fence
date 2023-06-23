/*
    File: fn_missions_getMissions.sqf
    Author:  Savage Game Design
    Date: 2023-04-07
    Last Update: 2023-06-22
    Public: Yes

    Description:
        Retrieves a HashMap of all missions

    Parameter(s):
        N/A

    Returns:
        Hashmap of all missions indexed by mission id [HASHMAP]

    Example(s):
        [] call vgm_c_fnc_missions_getMissions;
 */

["vgm_missions_publicMissionInfo", createHashMap] call para_g_fnc_netmap_getOrDefault
