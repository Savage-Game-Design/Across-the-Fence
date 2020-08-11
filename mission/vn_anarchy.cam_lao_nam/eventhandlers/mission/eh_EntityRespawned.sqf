/*
    File: eh_EntityRespawned.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-04-12
    Last Update: 2020-05-27
    Public: No

    Description:
		Entity respawned event handler, used to reapply unit loadout after death.

    Parameter(s):
		_entity - respawned entity [OBJECT]
		_corpse - corpse/wreck [OBJECT]

    Returns: nothing

    Example(s):
		Not called directly.
*/

params
[
	"_entity",
	"_corpse"
];
// respawn player with same loadout as before death

["EntityRespawned mEH: %1", _this] call BIS_fnc_logFormat;
