/*
  Author: Aaron Clark

  Description:
	virtual group invite

  Example Usage:
	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params [
	["_target",objNull,[objNull]]
];

["_player %1 _target %2", _player,_target] call BIS_fnc_log;

// make sure we have a target
if !(isNull _target) then
{
	// check if player is already in group
	_target_uid = getPlayerUID _target;
	if !(_target_uid isEqualTo "") then
	{
		_friends = _player getVariable ["vn_an_friends", []];
		if !(_target_uid in _friends) then
		{
			// add player to
			_friends pushBackUnique _target_uid;
			_player setVariable ["vn_an_friends", _friends,true];

			// check if both sides are friends
			if (getPlayerUID _player in (_target getVariable ["vn_an_friends",[]])) then
			{
				{["TaskSucceeded",[localize "STR_vn_an_friendsmade"]] call BIS_fnc_showNotification} remoteExecCall ["call",[_player,_target]];
			}
			else
			{
				{["TaskSucceeded",[localize "STR_vn_an_invitereceived"]] call BIS_fnc_showNotification} remoteExecCall ["call",_target];
			};
		};
	};
};
