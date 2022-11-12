/*
	File: fn_cleanup_subsystem_init.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Initialises the Cleanup Subsystem.

	Parameter(s): nothing

	Returns: nothing

	Example(s):
		call para_s_fnc_cleanup_subsystem_init;
*/

params [["_params", createHashMap]];

para_s_cleanup_minPlayerDistance = _params getOrDefault ["minPlayerDistance", 400];
para_s_cleanup_max_bodies = _params getOrDefault ["maxBodies", 50];
// Remove items placed on the ground by players
para_s_cleanup_clean_placed_gear = _params getOrDefault ["cleanPlacedGear", true];
para_s_cleanup_placed_gear_cleanup_time = _params getOrDefault ["placedGearCleanupTime", 300];
// Remove items dropped by players or AI dying
para_s_cleanup_clean_dropped_gear = _params getOrDefault ["cleanDroppedGear", true];
para_s_cleanup_dropped_gear_cleanup_time = _params getOrDefault ["droppedGearCleanupTime", 300];

para_s_cleanup_items_delete_immediately = [];

para_s_cleanup_items_range_restricted = [];
para_s_cleanup_items_time_only = [];

para_s_cleanup_items_bodies = [];

para_s_cleanup_time_bucket_size = 30;
para_s_cleanup_time_bucket_times = [];
para_s_cleanup_time_buckets = createHashMap;
para_s_cleanup_items_time_check = [];

["cleanup", {call para_s_fnc_cleanup_job}, [], 5] call para_g_fnc_scheduler_add_job;

if (para_s_cleanup_clean_dropped_gear) then {
	addMissionEventHandler ["EntityKilled", {
		params ["_unit"];

		if (_unit isKindOf "CAManBase") then {
			para_s_cleanup_items_bodies pushBack _unit;
			private _weaponHolders = _unit nearEntities ["WeaponHolderSimulated", 5];
			[_weaponHolders, false, para_s_cleanup_dropped_gear_cleanup_time] call para_s_fnc_cleanup_add_items;
		};
	}];
};