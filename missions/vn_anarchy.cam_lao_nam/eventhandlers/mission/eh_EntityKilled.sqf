/*
    File: eh_EntityKilled.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-01-29
    Last Update: 2020-05-27
    Public: No

    Description:
		Entity death event handler for tracking stats.

    Parameter(s):
		_unit - entity that was killed [OBJECT]
		_killer - the killer (vehicle or person) [OBJECT]
		_instigator - person who pulled the trigger [OBJECT]
		_useEffects - destruction effects [BOOL]

    Returns: nothing

    Example(s):
    	Not called directly.
*/

params
[
	"_unit",
	"_killer",
	"_instigator",
	"_useEffects"
];

["EntityKilled mEH: %1", _this] call BIS_fnc_logFormat;
