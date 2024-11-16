/*
    File: fn_areaLimiterDisable.sqf
    Author: veteran29
    Date: 2022-12-03
    Last Update: 2024-11-16
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_sharedHub_areaLimiterDisable
 */

terminate (missionNamespace getVariable ["vgm_sharedHub_areaLimiterScript", scriptNull]);

removeMissionEventHandler (missionNamespace getVariable ["vgm_sharedHub_areaLimiterDraw3D", -1]);
