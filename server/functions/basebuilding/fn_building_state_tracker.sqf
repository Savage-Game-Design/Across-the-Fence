/*
	File: fn_building_state_tracker.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Building state tracking

	Parameter(s): none

	Returns: nothing

	Example(s):
		call para_s_fnc_building_state_tracker;
*/

private _lastRan = missionNamespace getVariable [
	"para_l_building_state_tracker_last_ran",
	time
];

para_l_building_state_tracker_last_ran = time;

private _timeDifference = time - _lastRan;

// remove any deleted objects
para_l_buildings = para_l_buildings - [objNull];

{
	private _building = _x;
	//We can "safely" "select 0" here, as it's invalid for an object to ever have an empty array here.
	private _objects = _building getVariable ["para_g_objects", []] - [objNull];
	//If somehow we've no longer got any objects, building is invalid, delete it.
	if (_objects isEqualTo []) then {
		[_building] call para_s_fnc_building_delete;
	} else {

		if ([_building] call para_g_fnc_building_is_decaying) then {
			//Buildings don't decay while players are nearby, otherwise we get things like cover vanishing mid-firefight
			if (allPlayers inAreaArray [getPos (_objects select 0), 100, 100, 0, false] isEqualTo []) then {
				//Check if a building is part of a base. If not, allow building decay to start, else decay base first.
				_base = _building getVariable ["para_g_base", objNull];
				private _buildableConfig = [_building] call para_g_fnc_get_building_config;
				private _isBaseStarter = isClass (_buildableConfig >> "features" >> "base_starter");
				if (isNil str(_base) && !_isBaseStarter) then {
					//Aiming for a 50% chance to have vanished within 20 minutes after the base has despawned, given this script runs once a minute.
					if (random 1 > 0.965) then {
						[_building] call para_s_fnc_building_delete;
					};
				} else {
					//Aiming for a 50% chance to have vanished within 20 minutes, given this script runs once a minute. Keeping both if statements to allow for tuning.
					if (random 1 > 0.965) then {
						//Delete base and "base starter(s)" at the same time
						[_building] call para_s_fnc_building_delete;
						[_base] call para_s_fnc_base_delete;
					};
				};
			};
		}
		else
		{
			// Do supply consumption
			private _config = [_building] call para_g_fnc_get_building_config;
			private _supplyConsumptionRate = getNumber(_config >> "supply_consumption");
			[_building, _timeDifference * _supplyConsumptionRate, true] call para_s_fnc_building_consume_supplies;
		};

		[_building, "onBuildingTick", [_building, _timeDifference]] call para_g_fnc_building_fire_feature_event;
	};
} forEach para_l_buildings;

//Save buildings
[] call para_s_fnc_basebuilding_save;
