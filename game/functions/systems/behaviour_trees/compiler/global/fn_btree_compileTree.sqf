/*
    File: fn_btree_compileTree.sqf
    Author: Savage Game Design
    Date: 2024-01-26
    Last Update: 2024-02-02
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

// Recursive algorithm should be fine, as our behaviour trees are unlikely to ever be more than 10 nodes deep.
private _fnc_compileNode = {
    params ["_constructor", "_params", "_children"];

    private _childNodes = _children apply {_x call _fnc_compileNode};

    // By passing built children to the constructor, we enable the constructor to modify them as needed.
    [createHashMapFromArray _params, _childNodes] call _constructor
};

_tree call _fnc_compileNode
