/*
    File: fn_skills_treesHashToPathsHash.sqf
    Author: veteran29
    Date: 2023-01-22
    Last Update: 2023-02-25
    Public: No

    Description:
        Create one level deep hash map of skill/tree paths mapped to their respective element in skillTreeHash.

    Parameter(s):
        N/A

    Returns:
        Paths hash [HashMap]

    Example(s):
        [vgm_skills_treesHashMap] call vgm_g_fnc_skills_treesHashToPathsHash;
 */

params [
    ["_skillTreesHash", createHashMap, [createHashMap]]
];

private _fnc_walkTree = {
    params ["_pathsHash", "_skillTree"];

    _pathsHash set [_skillTree get "path", _skillTree];

    // handle all skills of the current tree
    {
        private _tier = _x;
        {
            private _skill = _x;
            _pathsHash set [_skill get "path", _skill];
        } forEach _tier;
    } forEach (_skillTree get "skills");

    // handle subtrees
    {
        [_pathsHash, _y] call _fnc_walkTree;
    } forEach (_skillTree get "subtreesHash");
};

private _pathsHash = createHashMap;
{
    [_pathsHash, _y] call _fnc_walkTree;
} forEach _skillTreesHash;

_pathsHash // return
