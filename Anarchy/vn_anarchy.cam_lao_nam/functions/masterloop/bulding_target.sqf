private _cursor_object = cursorObject;
// show building progress for target
if !(isNull _cursor_object) then {
	if (_cursor_object distance player < 6) then
	{
		private _build_state = _cursor_object getVariable ["vn_mf_buildstate",0];

		if !(_lastBuildState isEqualTo _build_state) then
		{
			_lastBuildState = _build_state;
			[vn_mf_cursor_object,_action_id] call BIS_fnc_holdActionRemove;
			_action_id = -1
		};

		if (_build_state > 0 && _action_id isEqualTo -1) then
		{
			// select target
			vn_mf_cursor_object = _cursor_object;

			private _diff = _build_state - vn_mf_totalgametime;
			private _percent = linearConversion [0,_decay_time,_diff,0,100,true];

			// add action
			_action_id = [
				_cursor_object,
				format[localize "STR_vn_mf_resupply",_percent toFixed 1,"%"],
				"",
				"",
				"true",
				"true",
				{},
				{},
				{
					params ['_target', '_caller', '_action_id', '_arguments'];
					private _nearby_supplies = _target nearEntities ["I_supplyCrate_F", 20];
					if !(_nearby_supplies isEqualTo []) then
					{
						[_target,_action_id] call BIS_fnc_holdActionRemove;
						[player,"resupplybuilding",[_target],player getVariable "vn_mf_token"] remoteExecCall ["vn_mf_fnc_rehandler",2];
					} else {
						["TaskFailed",["",localize "STR_vn_mf_nosupplydropnearby"]] call BIS_fnc_showNotification;
					};
				},
				{},
				[],
				2,
				100,
				false,
				false
			] call BIS_fnc_holdActionAdd;
		};
	} else {
		[vn_mf_cursor_object,_action_id] call BIS_fnc_holdActionRemove;
		vn_mf_cursor_object = objNull;
		_action_id = -1;

	};
} else {
	[vn_mf_cursor_object,_action_id] call BIS_fnc_holdActionRemove;
	vn_mf_cursor_object = objNull;
	_action_id = -1;
};
