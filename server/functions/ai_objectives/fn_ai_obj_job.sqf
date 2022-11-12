/*
	File: fn_ai_job.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Scheduler job for managing the AI.

	Parameter(s): none

	Returns: nothing

	Example(s): none
*/

private _allPlayers = allUnits select {isPlayer _x && {!(_x isKindOf "HeadlessClient_F")} && !(vehicle _x isKindOf "Plane") && !(speed vehicle _x > 300)};

//Groups of AI that are no longer in use by the system.
//We can reuse these for other objectives later.
//Or tidy them up, if we don't need to reuse them.
//Initially - populate it with groups the system owns, that have no objective.
private _freeGroupLeaders = para_s_ai_obj_managedGroups select {isNull (_x getVariable ["objective", objNull])} apply {leader _x};

////////////////////////
// OBJECTIVE HANDLING //
////////////////////////
//Prune finished objectives
para_s_ai_obj_objectives = para_s_ai_obj_objectives select {!isNull _x};

//"Tick" each objective, allowing each objective to run periodic code, such as updating its position.
//diag_log "AI Obj: Ticking Objectives";
{
	[_x] call (_x getVariable ["onTick", {}]);
} forEach para_s_ai_obj_objectives;

// Determine active objectives
private _activeObjectives = [];

{
	_activeObjectives append (para_s_ai_obj_objectives inAreaArray [getPos _x, para_s_ai_obj_activation_radius, para_s_ai_obj_activation_radius]);
} forEach _allPlayers;

//The above code adds the objectives way too many times - one duplicate for each player, potentially - we need to normalise it.
//It's *probably* faster to normalise it like this, than loop through all the objectives.
_activeObjectives = _activeObjectives arrayIntersect _activeObjectives;

//Figure out which objectives have just been activated, and which have been de-activated.
//Risk of bouncing here - if players wander in and out of objective radius. Need to put a buffer in to minimise it.
private _newlyActiveObjectives = _activeObjectives - para_s_ai_obj_active_objectives;
private _deactivatedObjectives = para_s_ai_obj_active_objectives - _activeObjectives;
para_s_ai_obj_active_objectives = _activeObjectives;

/*diag_log format ["AI Obj: Activating Objectives: %1", _newlyActiveObjectives apply {_x getVariable "id"}];
diag_log format ["AI Obj: Deactivating Objectives: %1", _deactivatedObjectives apply {_x getVariable "id"}];
diag_log format ["AI Obj: Active Objectives: %1", _activeObjectives apply {_x getVariable "id"}];*/

//Deactivate objectives
{
	[_x] call (_x getVariable ["onDeactivation", {}]);
	private _assignedGroups = _x getVariable "assignedGroups";
	[_assignedGroups, _x] call para_s_fnc_ai_obj_unassign_from_objective;
	_freeGroupLeaders append (_assignedGroups apply {leader _x});
} forEach _deactivatedObjectives;

//Activate new objectives
{
	[_x] call (_x getVariable ["onActivation", {}]);
} forEach _newlyActiveObjectives;

private _enemyUnits = allUnits select {side group _x == east};

//Calculate our total AI pool size - this is all the AI we have to use.
private _globalPoolSize = para_s_ai_obj_hard_ai_limit;
private _currentUnitCount = count _enemyUnits;

//diag_log format ["AI Obj: Current Pool Size: %1, Count: %2", _globalPoolSize, _currentUnitCount];

//Prioritise objectives, and order them by priority
private _objectivePriorityBands = para_s_ai_obj_priority_radii apply {[]};
private _objectivesWithPriority = [];

{
	private _obj = _x;
	private _priority = 9999;

	{
		if (count (_allPlayers inAreaArray [getPos _obj, _x, _x]) > 0) exitWith {
			_priority = _forEachIndex;
		};
	} forEach para_s_ai_obj_priority_radii;

	_objectivesWithPriority pushBack [_priority, _obj];
	_obj setVariable ["priority", _priority];
} forEach para_s_ai_obj_active_objectives;

//Sort by priority
_objectivesWithPriority sort true;
//Filter out the objective objects
private _objectivesPrioritisedHighestFirst = _objectivesWithPriority apply {_x # 1};

//diag_log format ["AI Obj: Prioritised Objectives: %1", _objectivesPrioritisedHighestFirst apply {_x getVariable "id"}];

//Calculate the numbers we need to make informed decisions about each zone.
{
	private _obj = _x;

	private _playerCount = _obj getVariable ["scaling_player_count_override", 0];
	if (_playerCount == 0) then
	{
		_playerCount = count (_allPlayers inAreaArray [getPos _obj, para_s_ai_obj_activation_radius, para_s_ai_obj_activation_radius]);
	};

	_obj setVariable ["nearby_player_count", _playerCount];

	private _desiredUnitCount = _obj getVariable ["fixed_unit_count", 0];
	if (_desiredUnitCount == 0) then {
		private _priority = _obj getVariable "priority";
		//LOD multiplier - distant objectives need fewer units, as they're less likely to be targeted.
		//This is a terrible way of calculating the LOD multiplier, but it's hacky and works for now.
		//Priorities can start at 0, so we need to add 1.
		private _LODMultiplier = 1 / (_priority + 1);
		private _scalingFactor = (_obj getVariable "scaling_factor") * _LODMultiplier;
		_desiredUnitCount = [_playerCount, _scalingFactor] call para_g_fnc_ai_scale_to_player_count;
		/*diag_log format [
			"AI Obj %1: Players: %2, Scaling Factor: %3, LOD Multiplier: %4",
			_obj getVariable "id",
			_playerCount,
			_scalingFactor,
			_LODMultiplier
		];*/
	};

	_obj setVariable ["desired_unit_count", _desiredUnitCount];

	private _totalAliveUnits = 0;
	{
		_totalAliveUnits = _totalAliveUnits + ({alive _x} count units _x);
	} forEach (_obj getVariable "assignedGroups");
	_obj setVariable ["total_alive_units", _totalAliveUnits];

} forEach _objectivesPrioritisedHighestFirst;

//First, work backwards down the priority list, de-allocating groups from over-staffed objectives.
//These free groups can then be re-allocated where needed, starting with high priority objectives.
private _objectivesPrioritisedLowestFirst = +_objectivesPrioritisedHighestFirst;
reverse _objectivesPrioritisedLowestFirst;
//Amount of "flex" in the number of allocated units, before we decide to remove some.
private _assignedUnitFlex = 4;

{
	private _obj = _x;
	private _desiredUnitCount = _obj getVariable "desired_unit_count";
	private _totalAliveUnits = _obj getVariable "total_alive_units";
	private _assignedGroups = _obj getVariable ["assignedGroups", []];
	private _deallocateThreshold = _desiredUnitCount + _assignedUnitFlex;

	if (_totalAliveUnits > _deallocateThreshold && count _assignedGroups > 1) then
	{
		//This is a dumb algorithm. We remove groups until we don't need to remove any more.
		private _difference = _totalAliveUnits - _deallocateThreshold;
		{
			//If we've deallocated enough units, stop deallocating.
			if (_difference <= 0) exitWith {};
			[_x, _obj] call para_s_fnc_ai_obj_unassign_from_objective;
			_freeGroupLeaders pushBack leader _x;
			_difference = _difference - count units _x;
			/*diag_log format [
				"AI Obj %1: Deallocating %2 units from group %3. Desired: %4, has %5",
				_obj getVariable "id",
				count units _x,
				_x,
				_desiredUnitCount,
				_totalAliveUnits
			];*/
		} forEach _assignedGroups;
	};
} forEach _objectivesPrioritisedLowestFirst;

//Now we go in order of highest priority, and allocate units where needed.
{
	private _obj = _x;
	private _playerCount = _obj getVariable "nearby_player_count";
	private _desiredUnitCount = _obj getVariable "desired_unit_count";

	private _availableReinforcements = [_obj] call para_s_fnc_ai_obj_available_reinforcements; 

	private _totalAliveUnits = _obj getVariable "total_alive_units";
	private _squadSize = _obj getVariable "squad_size";

	//Do this to keep this function tidy.
	call
	{
		//Don't need to do anything if we have enough units. Let's roughly define that as 50% dead for now.
		if (_totalAliveUnits >= _desiredUnitCount * 0.5) exitWith {};

		private _reinforcementsNeeded = _desiredUnitCount - _totalAliveUnits;

		private _reusableGroups = _freeGroupLeaders inAreaArray [getPos _obj, para_s_ai_obj_reinforce_reallocate_range, para_s_ai_obj_reinforce_reallocate_range] apply {group _x};
		private _reusedGroups = [];

		{
			if (_reinforcementsNeeded <= 0) exitWith {};
			if (count units _x <= (_reinforcementsNeeded + _assignedUnitFlex)) then
			{
				_reusedGroups pushBack _x;
				[_x, _obj] call para_s_fnc_ai_obj_assign_to_objective;
				_reinforcementsNeeded = _reinforcementsNeeded - count units _x;
				/*diag_log format [
					"AI Obj %1: Reinforcing with %2 units from group %3",
					_obj getVariable "id",
					count units _x,
					_x
				];*/
			};
		} forEach _reusableGroups;

		_freeGroupLeaders = _freeGroupLeaders - (_reusedGroups apply {leader _x});

		//No reinforcements needed at all - great, let's exit.
		if (_reinforcementsNeeded <= 0) exitWith {};

		//No reinforcement pools available - nothing we can send.
		if (_availableReinforcements <= 0) exitWith {};

		//Still need more men - let's get some fresh ones.
		private _unitsRemainingInGlobalPool = _globalPoolSize - _currentUnitCount;
		private _unitsToSendCount =
			_reinforcementsNeeded
			min
			_availableReinforcements
			min
			_unitsRemainingInGlobalPool
			max 0;

		diag_log format [
			"AI Obj %1 [%6]: Reinforcing with %2 units. Needed: %3, available: %4, global: %5",
			_obj getVariable "id",
			_unitsToSendCount,
			_reinforcementsNeeded,
			_availableReinforcements,
			_unitsRemainingInGlobalPool,
			_obj getVariable "type"
		];

		[_obj, _unitsToSendCount] call para_s_fnc_ai_obj_reinforce;
		_currentUnitCount = _currentUnitCount + _unitsToSendCount;
	};
} forEach _objectivesPrioritisedHighestFirst;

// Finish any objectives that haven't got any AI left.
private _objectivesToFinish = para_s_ai_obj_objectives select {_x getVariable ["reinforcements_remaining", 0] <= 0};
{
	[_x] call para_s_fnc_ai_obj_finish_objective;
} forEach _objectivesToFinish;

//Add any unused groups to cleanup.
//Be wary of lingering AI squads being pinned in place by a single guy.
//Want to avoid the situation where one unit can stop 100 AI from being cleaned up
private _groupsToRemove = [];
{
	private _group = group _x;
	_groupsToRemove pushBack _group;
	_group deleteGroupWhenEmpty true;
	//[units group _x] call para_s_fnc_cleanup_add_items;
	{ deleteVehicle _x } forEach units _group;
} forEach _freeGroupLeaders;

para_s_ai_obj_managedGroups = para_s_ai_obj_managedGroups - _groupsToRemove;
