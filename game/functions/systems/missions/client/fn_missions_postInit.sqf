/*
    File: fn_missions_postInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-06-20
    Public: Yes

    Description:
        Initialises the mission system on the client, setting up necessary state.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_missions_postInit
 */

[getPlayerID player] remoteExecCall ["vgm_s_fnc_missions_remoteExec_requestMissionData", 2];

// To remove later, this is just for debugging right now.
["missions system postinit", []] call para_g_fnc_event_triggerLocal;
