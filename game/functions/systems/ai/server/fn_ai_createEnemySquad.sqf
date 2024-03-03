/*
    File: fn_ai_createEnemySquad.sqf
    Author: Savage Game Design
    Date: 2024-02-10
    Last Update: 2024-03-03
    Public: Yes

    Description:
        Creates an enemy squad, enabling VGM specific enemy AI features in the process.

        Accepts the same arguments as para_g_fnc_create_squad.

    Parameter(s):
		_units - Array of unit classes [Array, defaults to [] (empty array)]
		_groupTarget - Group to put units in, or side to create units in [Group|Side]
		_position - Position to spawn units around [Position3D]

    Returns:
        Group units were placed into [GROUP]

    Example(s):
        ["vn_west", "west"] call vgm_s_fnc_ai_createEnemySquad
 */

params [["_units", []], "_groupTarget", "_position"];

// Create it on the server, to avoid an FPS stutter on a client. Also, easier to get a reference to them.
// Generally speaking, the rest of the systems assume a squad is created on the server.
private _squad = _this call para_g_fnc_create_squad;

private _group = _squad select 1;

//Set the squad's locality to the client with highest FPS
private _selectedClient = call para_s_fnc_loadbal_suggest_host;
_group setGroupOwner _selectedClient;
_group setVariable ["groupClientOwner", _selectedClient];
_group setVariable ["behaviourEnabled", false, true];
[_group, ["enemyAI"] call vgm_g_fnc_btree_getCompiledTree] call vgm_g_fnc_btree_setTree;

//Update the owner variable if the group changes locality.
_group addEventHandler ["Local", {
    params ["_group"];
    if (local _group) then {
        _group setVariable ["groupClientOwner", clientOwner, true];
        // Reassign the behaviour tree on locality change, as it's local.
        [_group, ["enemyAI"] call vgm_g_fnc_btree_getCompiledTree] call vgm_g_fnc_btree_setTree;
    };
}];

_group
