/*
    File: fn_postInit.sqf
    Author: Savage Game Design
    Date: 2023-09-16
    Last Update: 2023-11-19
    Public: No

    Description:
        Client postInit function for equipment system.
 */

if (!hasInterface) exitWith {};

if (entities "vn_module_whitelistedarsenal" isNotEqualTo []) then {
    "S.O.G. Whitelisted Arsenal module detected in the mission. VGM Equipment will NOT function corectly!" call vgm_g_fnc_logError;
};

private _arsenals = entities "" select {_x getVariable ["vgm_equipment_arsenal", false]};

{
    _x addAction [
        "Open Arsenal",
        {call vgm_c_fnc_equipment_openArsenal}
    ]
} forEach _arsenals;

// Add our special Medical items to "Misc" tab
[true, "arsenalPreOpen", {
    {BIS_fnc_arsenal_data select 24 pushBackUnique _x} forEach ["vn_helper_item_firstaidkit", "vn_helper_item_medikit"];
}] call BIS_fnc_addScriptedEventHandler;

// Prevent players from getting forbidden items
[true, "arsenalClosed", {
    private _loadout = getUnitLoadout player;
    private _filteredLoadout = [+_loadout] call vgm_c_fnc_equipment_filterLoadout;
    if (_filteredLoadout isNotEqualTo _loadout) then {
        "Forbidden items were removed from your inventory" spawn BIS_fnc_guiMessage;
        player setUnitLoadout _filteredLoadout;
    };
}] call BIS_fnc_addScriptedEventHandler;

// Prevent arsenal "Open" from adding the action to the player
player setvariable ["BIS_fnc_arsenal_action", -1];
