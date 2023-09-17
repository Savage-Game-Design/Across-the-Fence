/*
    File: fn_postInit.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-09-17
    Public: No

    Description:
        Client postInit function for equipment system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

if (entities "vn_module_whitelistedarsenal" isNotEqualTo []) then {
    "S.O.G. Whitelisted Arsenal module detected in the mission. VGM Equipment will NOT function corectly!" call vgm_g_fnc_logError;
};

private _arsenals = entities "" select {_x getVariable ["vgm_equipment_arsenal", false]};

{
    _x addAction [
        "Open Arsenal",
        {call vgm_c_equipment_openArsenal}
    ]
} forEach _arsenals;
