/*
    File: fn_loc_preInit.sqf
    Author: Savage Game Design
    Date: 2024-06-01
    Last Update: 2024-07-27
    Public: No

    Description:
        PreInit for the location finding system.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */

if (!isServer) exitWith {};

// Set to default
private _targetBoxIndexes = localNamespace getVariable ["vgm_s_loc_targetBoxIndexes" , createHashMap];
localNamespace setVariable ["vgm_s_loc_targetBoxIndexes", _targetBoxIndexes];
