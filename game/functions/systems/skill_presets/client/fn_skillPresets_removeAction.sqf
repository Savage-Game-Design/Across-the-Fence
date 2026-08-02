/*
    File: fn_skillPresets_removeAction.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Remove the "Skill Presets" addAction from the skill objects.

    Parameter(s):
        N/A

    Returns:
        Nothing
*/

// Remove actions from objects
private _actionIds = player getVariable ["vgm_c_skillPresets_actionIds", []];
{
    _x params ["_obj", "_actionId"];
    if (!isNull _obj) then {
        _obj removeAction _actionId;
    };
} forEach _actionIds;
player setVariable ["vgm_c_skillPresets_actionIds", []];

// Legacy cleanup: remove old player-based action if it exists
private _oldActionId = player getVariable ["vgm_c_skillPresets_actionId", -1];
if (_oldActionId > -1) then {
    player removeAction _oldActionId;
    player setVariable ["vgm_c_skillPresets_actionId", -1];
};

private _respawnEH = player getVariable ["vgm_c_skillPresets_respawnEH", -1];
if (_respawnEH > -1) then {
    player removeEventHandler ["Respawn", _respawnEH];
    player setVariable ["vgm_c_skillPresets_respawnEH", -1];
};
