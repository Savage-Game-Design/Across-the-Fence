/*
    File: fn_btree_compileTree.sqf
    Author: Savage Game Design
    Date: 2024-01-26
    Last Update: 2024-02-03
    Public: No

    Description:
        Compiles a runnable behaviour tree, from a behaviour tree in array format.

    Parameter(s):
        _tree - Behaviour tree [ARRAY]

    Returns:
        A compiled behaviour tree, ready for assigning to a group and running [HASHMAP]

    Example(s):
 */

params ["_tree"];

// Hashmaps prevent identical code running multiple times.
private _extern_onTreeAssignedCallbacks = createHashMap;
private _extern_onTreeUnassignedCallbacks = createHashMap;

// Recursive algorithm should be fine, as our behaviour trees are unlikely to ever be more than 10 nodes deep.
private _fnc_compileNode = {
    params ["_constructor", "_params", "_children"];

    private _childNodes = _children apply {_x call _fnc_compileNode};

    // By passing built children to the constructor, we enable the constructor to modify them as needed.
    private _node = [createHashMapFromArray _params, _childNodes] call _constructor;

    if ("onTreeAssigned" in _node) then {
        _extern_onTreeAssignedCallbacks set [_node get "onTreeAssigned", true];
    };

    if ("onTreeUnassigned" in _node) then {
        _extern_onTreeUnassignedCallbacks set [_node get "onTreeUnassigned", true];
    };

    _node
};

createHashMapFromArray [
    ["rootNode", _tree call _fnc_compileNode],
    ["onTreeAssignedCallbacks", keys _extern_onTreeAssignedCallbacks],
    ["onTreeUnassignedCallbacks", keys _extern_onTreeUnassignedCallbacks]
]

