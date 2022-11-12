/*
    File: fn_bases_containing_pos.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Returns a list of bases that the position is contained withs
    
    Parameter(s):
        _pos - Position to check [ARRAY]
    
    Returns:
        Bases that the position is inside [ARRAY]
    
    Example(s):
        [1,1,1] call para_g_fnc_bases_containing_pos
*/

private _pos = _this;

//Filter it down to start with, so we don't search every base on the map.
private _candidates = para_g_bases inAreaArray [_pos, para_g_max_base_radius, para_g_max_base_radius];
//Select only the ones we're actually inside.
_candidates select {_x distance2D _pos < _x getVariable "para_g_base_radius"};