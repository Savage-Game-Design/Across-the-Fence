/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2024-08-21
    Public: No

    Description:
        Initialises the mission system, setting up necessary state.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_missions_initSystem
 */

if (!isServer) exitWith {};

// This is assumed to be static at startup.
vgm_missions_zones_targetBoxes = [] call vgm_s_fnc_loc_getTargetBoxIds;
publicVariable "vgm_missions_zones_targetBoxes";

