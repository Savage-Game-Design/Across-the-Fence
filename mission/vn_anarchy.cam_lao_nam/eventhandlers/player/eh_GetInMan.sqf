/*
    File: eh_GetInMan.sqf
    Author: Spoffy
    Date: 2020-03-27
    Last Update: 2020-05-29
    Public: No

    Description:
        Fires on the 'GetInMan' event on the client

    Parameter(s):
		_unit - Unit the event handler is assigned to [Object]
		_role - Can be either "driver", "gunner" or "cargo" [String]
		_vehicle - Vehicle the unit entered [Object]
		_turret - Turret path [Array]

    Returns: nothing

    Example(s): none
*/

params ["_unit", "_role", "_vehicle", "_turret"];
