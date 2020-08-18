/*
    File: eh_Map.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-05-27
    Last Update: 2020-05-27
    Public: No

    Description:
	    Entity respawned event handler, used to reapply unit loadout after death.

    Parameter(s):
        _map_opened - true if map is opened, false is closed [BOOL]
        _map_forced - true if map is forced [BOOL]

    Returns: nothing

    Example(s):
	    Not called directly.
*/

params
[
	"_map_opened",
	"_map_forced"
];

["Map mEH: %1", _this] call BIS_fnc_logFormat;
