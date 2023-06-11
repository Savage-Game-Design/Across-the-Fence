/*
    File: fn_medical_postInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-06-11
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

if (!hasInterface) exitWith {};

vgm_c_medical_eh = player addEventHandler ["HandleDamage", {call vgm_c_fnc_medical_handleDamage}];

// tell other clients to add actions on our player unit
["vgm_medical_addAction", player] call para_g_fnc_event_triggerGlobal;

// add the actions on players that were present before we joined
{
    ["vgm_medical_addAction", _x] call para_g_fnc_event_triggerLocal;
} forEach ((allPlayers select {!(_x isKindOf "VirtualMan_F")}) - [player]);
