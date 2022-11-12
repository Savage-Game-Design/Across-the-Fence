/*
    File: fn_count_alive_units_in_groups.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Counts the total number of units found in an array of groups that are alive.
    
    Parameter(s):
        _this - [_group(n)] of groups [Array].
			_group - Group [Group]
    
    Returns:
        Number of units in all of the groups added together [Number]
    
    Example(s):
        [grpNull, group1] call para_g_fnc_count_units_in_groups
*/

private _total = 0;

{
	_total = _total + ({alive _x} count units _x);
} forEach _this;

_total