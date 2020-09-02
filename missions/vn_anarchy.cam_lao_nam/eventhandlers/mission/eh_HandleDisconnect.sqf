/*
    File: eh_HandleDisconnect.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-03-01
    Last Update: 2020-05-27
    Public: No

    Description:
		Handle Disconnect Event Handler that saves player vars on disconnect.

    Parameter(s):
		_unit - unit formerly occupied by player [OBJECT]
		_id - unique DirectPlay ID [NUMBER]
		_uid - getPlayerUID of player [STRING]
		_name - profileName of the leaving player [STRING]

    Returns:
    	Always returns false [BOOL]

    Example(s):
    	Not called directly.
*/

params
[
	"_unit",
	"_id",
	"_uid",
	"_name"
];

["HandleDisconnect mEH: %1",_this] call BIS_fnc_logFormat;

if !(isNull _unit) then
{
	// todo do save on disconnect

	// delete unit
	deleteVehicle _unit;
};

false
