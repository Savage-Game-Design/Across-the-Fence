/*
  Author: Aaron Clark

  Description:
	Creates support tasks

  Example Usage:
	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params ["_taskClass", "_coords", "_teamToTarget"];
[
  _taskClass,
  "",
  [
    ["supportRequestPos", _coords],
    ["supportRequestPlayer", _player]
  ],
  groupId (group _player),
  [_teamToTarget]
] call vn_mf_fnc_task_create;
