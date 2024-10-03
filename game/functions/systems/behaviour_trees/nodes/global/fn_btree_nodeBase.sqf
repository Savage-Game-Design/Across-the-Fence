/*
    File: fn_btree_nodeBase.sqf
    Author: Savage Game Design
    Date: 2024-10-03
    Last Update: 2024-10-03
    Public: Yes

    Description:
        Basis for all node types.

        Establishes common properties that exist on all nodes.

    Parameter(s):
        _nodeType - String uniquely identifying the type of the node [STRING]
        _name - Human readable name of this node [STRING]
        _params - Any parameters to be stored on the node. [HASHMAP]

    Returns:
        Node [HashMap]

    Example(s):
        [NODE_TYPE_DECORATOR, createHashMap] call vgm_g_fnc_btree_node_basic;
 */

params ["_nodeType", "_name", "_params"];

createHashMapFromArray [
    ["type", _nodeType],
    ["name", _name],
    ["params", _params]
]

