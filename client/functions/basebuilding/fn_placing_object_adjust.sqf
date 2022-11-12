/*
    File: fn_placing_object_adjust.sqf
    Author:  Savage Game Design
    Public: No

    Description:
	No description added yet.

    Parameter(s):
	_localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]

    Returns:
	Function reached the end [BOOL]

    Example(s):
	[_unused,_change] call para_c_fnc_placing_object_adjust
*/
params
[
	"",
	["_change",0]
];

// only works if build mode is enabled
if !(isNil "para_l_placing") then
{
	private _min_height = 0;
	private _max_height = 10;
	private _tick = if (_change > 0) then
	{
		0.1
	} else
	{
		-0.1
	};
	if (!isNil "para_keydown_ctrl" && {para_keydown_ctrl}) then
	{
		_tick = _tick * 10;
	};
	if (!isNil "para_keydown_shift" && {para_keydown_shift}) then
	{
		_tick = _tick / 10;
	};
	if (!isNil "para_keydown_alt" && {para_keydown_alt}) then
	{
		para_l_last_rotation = para_l_last_rotation + (_tick * 10);
		para_l_placing_object setDir para_l_last_rotation;
	} else {
		para_l_build_height = (para_l_build_height + _tick) min _max_height max _min_height;
	};
};
