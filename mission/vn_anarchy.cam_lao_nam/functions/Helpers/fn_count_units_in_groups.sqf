/*
 * File: fn_count_units_in_groups.sqf
 * Author: Spoffy
 * Description:
 *    Counts the total number of units found in an array of groups.
 * Params:
 *    _this - array of groups.
 * Returns:
 *    Number of units in all of the groups added together
 * Example Usage:
 *    [grpNull, group1] call vn_an_fnc_count_units_in_groups
 */

private _total = 0;

{
	_total = _total + count units _x;
} forEach _this;

_total