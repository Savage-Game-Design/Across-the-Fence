/*
    File: fn_disableHub.sqf
    Author: veteran29
    Date: 2022-12-03
    Last Update: 2025-01-06
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_sharedHub_disableHub
 */

if (isNull (missionNamespace getVariable ["vgm_sharedHub_areaLimiterScript", scriptNull])) exitWith {};

terminate (missionNamespace getVariable ["vgm_sharedHub_areaLimiterScript", scriptNull]);

removeMissionEventHandler ["Draw3D", missionNamespace getVariable ["vgm_sharedHub_iconsDraw3D", -1]];

["vgm_shared_hub_disabled", []] call para_g_fnc_event_triggerLocal;
