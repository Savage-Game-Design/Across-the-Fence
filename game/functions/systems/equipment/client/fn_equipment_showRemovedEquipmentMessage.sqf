/*
    File: fn_equipment_showRemovedEquipmentMessage.sqf
    Author: Savage Game Design
    Date: 2025-07-03
    Last Update: 2025-07-03
    Public: Yes

    Description:
        Shows a message listing equipment removed from the player.

    Parameter(s):
        _removedItems - Classes removed [ARRAY]

    Returns:
        Nothing

    Example(s):
        [["vn_b_pack_03"]] call vgm_c_fnc_equipment_showRemovedEquipmentMessage;
 */

params ["_removedItems", "_display"];

private _message = [localize "STR_VGM_EQUIPMENT_REMOVED_ITEM_MESSAGE"];

{
    private _className = _x;
    private _displayName = getText (configFile >> "CfgWeapons" >> _className >> "displayName");
    if (_displayName == "") then {
        _displayName = getText (configFile >> "CfgVehicles" >> _className >> "displayName");
    };
    if (_displayName == "") then {
        _displayName = getText (configFile >> "CfgMagazines" >> _className >> "displayName");
    };
    _message append [
        lineBreak,
        format ["- %1", [_displayName, _className] select (_displayName == "")]
    ];
} forEach _removedItems;

if (!isNil "_display") then {
    [composeText _message, nil, nil, nil, _display] spawn BIS_fnc_guiMessage;
} else {
    [composeText _message] spawn BIS_fnc_guiMessage;
};
