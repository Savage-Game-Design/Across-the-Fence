/*
    File: fn_count_units_in_groups.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Counts the total number of units found in an array of groups.
    
    Parameter(s):
        _this - [_group(n)] of groups [Array] .
			_group - Group or Array
    
    Returns:
    	Number of units in all of the groups added together [Number]
    
    Example(s):
        [grpNull, group1] call para_g_fnc_count_units_in_groups
*/

private _total = 0;

if (grpNull isEqualTypeAny _this) then {
    {
        _total = _total + count units _x;
    } forEach _this;
} else {
    {
        _total = _total + count _x;
    } forEach _this;
};

_total