/*
    File: fn_loc_getTargetBoxIds.sqf
    Author: Savage Game Design
    Date: 2024-06-01
    Last Update: 2024-08-21
    Public: No

    Description:
        Retrieves a list of all target box IDs.

    Parameter(s):
        None

    Returns:
        Array of target box IDs [ARRAY]

    Example(s):
        [] call vgm_s_fnc_loc_getTargetBoxIds;
 */

keys (localNamespace getVariable "vgm_s_loc_targetBoxIndexes")
