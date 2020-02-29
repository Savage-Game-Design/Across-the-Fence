/*
  Author: Aaron Clark

  Description:
	changes team

  Example Usage:
      	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params ["_group"];
private _current_group = group _player;
private _current_group_ID = groupID _current_group;
// check that desired group is different from current group
if !(_current_group_ID isEqualTo _group) then
{
	// attempt get group from missionNamespace variable
	private _selected_group = missionNamespace getVariable [_group,grpNull];
	// check that group is found and is proper type
	if (!isNull _selected_group && {_selected_group isEqualType grpNull}) then
	{
		// make sure player is witin 20m of a duty officer
		if !(vn_mf_duty_officers inAreaArray [getPos _player, 20, 20, 0, false, 20] isEqualTo []) then
		{
			// join group
			_player setVariable ["vn_mf_player_group",_group,true];
			[_player] joinSilent _selected_group;
			[] remoteExec ["vn_mf_fnc_tr_overview_team_update", _player];
			[_player] call vn_mf_fnc_task_refresh_task_list;
		} else {
			{["TaskFailed",["",localize "STR_vn_mf_needdutyofficer"]] call BIS_fnc_showNotification} remoteExecCall ["call",_player];
		};
	} else {
		diag_log format ["Attempted to join %1 to invalid group %2, with ID %3 - current group %4", _player, _selected_group, _group, _current_group_ID];
	};
};
