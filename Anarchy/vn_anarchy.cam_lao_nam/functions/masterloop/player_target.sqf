private _cursor_object = cursorObject;
// show building progress for target
if !(isNull _cursor_object) then {
	if (_cursor_object distance player < 6 && isPlayer _cursor_object) then
	{
		if (_action_id_pt isEqualTo -1) then
		{
			_is_friend = (getPlayerUID _cursor_object) in (_cursor_object getVariable ["vn_mf_friends",[]]);

			if !(_is_friend) then
			{

				vn_mf_cursor_object_pt = _cursor_object;

				// add action
				_action_id_pt = [
					_cursor_object,
					format[localize "STR_vn_mf_invite", name _cursor_object],
					"",
					"",
					"true",
					"true",
					{},
					{},
					{
						params ['_target', '_caller', '_action_id_pt', '_arguments'];

						if (isPlayer _target) then
						{
							[_target,_action_id_pt] call BIS_fnc_holdActionRemove;
							[player,"inviteplayer",[_target],player getVariable "vn_mf_token"] remoteExecCall ["vn_mf_fnc_rehandler",2];
						};
					},
					{},
					[],
					2,
					101,
					false,
					false
				] call BIS_fnc_holdActionAdd;
			};
			// todo add remove friend action
		};
	} else {
		[vn_mf_cursor_object_pt,_action_id_pt] call BIS_fnc_holdActionRemove;
		vn_mf_cursor_object_pt = objNull;
		_action_id_pt = -1;

	};
} else {
	[vn_mf_cursor_object_pt,_action_id_pt] call BIS_fnc_holdActionRemove;
	vn_mf_cursor_object_pt = objNull;
	_action_id_pt = -1;
};
