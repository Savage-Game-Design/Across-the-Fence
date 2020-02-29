/*
  Author: Aaron Clark

  Description:
	 Building state tracking

  Example Usage:
	call vn_mf_fnc_building_state_tracker;

  Returns:
	NOTHING

  Parameter(s):
  	NA
*/
private _config = (missionConfigFile >> "gamemode");
private _decay_time = ["difficulty", "building_decay_time", 259200] call vn_mf_fnc_get_gamemode_value;
private _buildables_config = (_config >> "buildables");
private _prefix = "vn_mf_";
private _savebuildings = [];

private _vars_config = (_config >> "vars" >> "buildables");
private _blacklisted = getArray(_vars_config >> "blacklisted");

// remove any deleted objects
vn_mf_buildings = vn_mf_buildings - [objNull];

private _fnc_remove_object = {
	if (_object in _objects) then
	{
		// remove object from types array
		_objects = _objects - [_object];
		missionNamespace setVariable [_typename, _objects];

		// remove any spawned agents
		_current_agents = _object getVariable ["vn_mf_agents", []];
		if !(_current_agents isEqualTo []) then {
			{
				deleteVehicle _x;
			} forEach _current_agents;
			_object setVariable ["vn_mf_agents", []];
		};
	};
};


{
	private _object = _x;
	// check current state
	private _build_state = _object getVariable ["vn_mf_buildstate",0];
	private _build_class = _object getVariable ["vn_mf_buildclass",""];

	private _type = getText(_buildables_config >> _build_class >> "type" );
	private _agents_cfg = getArray(_buildables_config >> _build_class >> "agents" );
	private _typename = format["vn_mf_%1",_type];
	private _objects = missionNamespace getVariable [_typename, []];

	private _build_config = (_buildables_config >> _build_class >> "build_states");
	private _current_class = typeOf _object;
	private _class = _current_class;

	// if fully decayed remove building
	if (vn_mf_totalgametime >= _build_state) then
	{
		diag_log format["removing expired building %1 %2 %3", vn_mf_totalgametime, _build_state ,_object];
		deleteVehicle _object;
	}
	else
	{
		// calculate decay / building
		private _diff = _build_state - vn_mf_totalgametime;
		private _percent = linearConversion [0,_decay_time,_diff,0,100,true];
		if (_percent >= 50) then
		{
			 // final_state
			_class = getText(_build_config >> "final_state" >> "object_class");

			if !(_object in _objects) then
			{
				// add building to matching array for its type
				_objects pushBack _object;
				missionNamespace setVariable [_typename, _objects];

				// spawn dummy AI inside buildings (todo make AI walk into position)
				_agents = [];
				{
					_pos = _object buildingPos (_foreachindex + 1);
					if !(_pos isEqualTo [0,0,0]) then
					{
						private _agent = createAgent [_x, _pos, [], 0, "NONE"];
					        _agent enableSimulationGlobal false;
					        _agent disableAI "ALL";
					        _agent allowDamage false;
						_agents pushBack _agent;
					};
				} forEach _agents_cfg;
				if !(_agents isEqualTo []) then {
					_object setVariable ["vn_mf_agents", _agents];
				};

			};
			diag_log format["final state object %1 %2 %3", _class , _build_class, _object];
		}
		else
		{
			if (_percent <= 10) then
			{
				// initial object
				_class = getText(_build_config >> "initial_state" >> "object_class");
				call _fnc_remove_object;
				diag_log format["initial state object %1 %2 %3", _class , _build_class, _object];
			}
			else
			{
				// middle_state
				_class = getText(_build_config >> "middle_state" >> "object_class");
				call _fnc_remove_object;
				diag_log format["middle state object %1 %2 %3", _class , _build_class, _object];
			};
		};

		// save building to db
		_vardata = [];
		private _all_vars = (allVariables _object) - _blacklisted;
		// filter for proper prefix and populate array to be saved
		{
			_vardata pushBack [_x,(_object getVariable _x)];
		} forEach (_all_vars select {_x find _prefix == 0});
		_savebuildings pushBack [_current_class,getPosWorld _object,[vectorDir _object, vectorUp _object],_vardata,_type];


		// swap building
		if !(_current_class isEqualTo _class) then
		{
			// swap building to class
			[_object,_class] call vn_mf_fnc_swap_building;
		};
	};

} forEach vn_mf_buildings;


// save all buildings
["SET", "buildables", _savebuildings] call vn_mf_fnc_hive;
