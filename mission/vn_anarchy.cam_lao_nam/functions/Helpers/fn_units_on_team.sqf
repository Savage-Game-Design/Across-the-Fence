/*
 * File: fn_units_on_team.sqf
 * Author: Spoffy
 * Description:
 *    Returns an array of all the units on a given team
 * Params:
 *    _this - Team name
 * Returns:
 *    Array of units on a team
 * Example Usage:
 *    "SpikeTeam" call vn_an_fnc_units_on_team
 */

 units (missionNamespace getVariable [_this, grpNull])