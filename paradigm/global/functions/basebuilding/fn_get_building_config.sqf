/*
    File: fn_get_building_config.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Retrieves building config
    
    Parameter(s):
        _building - Building to check config for [OBJECT]
		_stat - Name of the stat to lookup [STRING]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [cursorObject, "supply_consumption"] call para_g_fnc_get_building_info_from_config
*/

params [["_building", nil, [objNull]]];

//If it's an object that belongs to a "building" entity, it has this set. Otherwise, assume we've been passed a building
private _building = _building getVariable ["para_g_building", _building];

missionConfigFile >> "gamemode" >> "buildables" >> (_building getVariable "para_g_buildclass")

