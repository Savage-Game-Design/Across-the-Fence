/*
    File: fn_btree_getNodeParams.sqf
    Author: Savage Game Design
    Date: 2024-10-03
    Last Update: 2024-10-25
    Public: Yes

    Description:
        Retrieves the parameters for the given node.

        Any function parameters are evaluated, and their results added to the hashmap for the node.

        This allows individual trees a lot of flexibility with how they source parameters.

        Can only be run from function inside an executing node.

    Parameter(s):
        _node - Node to retrieve the parameters from [HASHMAP]

    Returns:
        Any parameters given to the node [HASHMAP]

    Example(s):
        [_node] call vgm_g_fnc_btree_getNodeParams;
 */

params ["_node"];

private _params = +(_node get "params");
private _calculatedParams = createHashMap;

{
    if (_y isEqualType {}) then {
        _calculatedParams set [_x, [_node] call _y];
    };
} forEach _params;

_params merge [_calculatedParams, true];

_params
