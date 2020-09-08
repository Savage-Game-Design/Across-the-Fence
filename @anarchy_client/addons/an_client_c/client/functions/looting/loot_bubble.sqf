/*
	File: fn_loot_bubble.sqf
	Author: Aaron Clark <vbawol>
	Date: 2020-07-20
	Last Update: 2020-09-02
	Public: No

	Description:
		Creates loot visable loot containers

	Parameter(s):
		None

	Returns:
		Nothing

	Example(s):
		call AN_C_fnc_loot_bubble;
*/

private _ticktime = diag_tickTime;

private _debug_show_markers = true;
private _debug_show_info = false;
private _chance = 0.99;
private _grid_size = 1;
private _grid_x = 0;
private _grid_y = 0;
private _grid_rows = 20;

private _total_rows = _grid_rows*_grid_rows;
private _row_counter = 0;
private _offset = -((_grid_rows*_grid_size)/2);
private _playerpos = getPosASL player;
private _startpos =  [floor(_playerpos#0),floor(_playerpos#1),floor(_playerpos#2)] vectorAdd [_offset,_offset,0];
private _pos = _startpos;

private _check_counter = 0;

private _looting_config = (missionConfigFile >> "gamemode" >> "looting" >> "buildings");

for "_i" from 0 to _total_rows do
{
	_grid_x = _grid_x + _grid_size;
	if (_row_counter >= _grid_rows) then
	{
		_grid_x = 0;
		_row_counter = 0;
		_grid_y = _grid_y + _grid_size;
	};
	_row_counter = _row_counter + 1;



	_loot_pos_key = format["vn_%1",[floor(_pos#0),floor(_pos#1),floor(_pos#2)]];
	_loot_pos = missionNamespace getVariable _loot_pos_key;
	_crate_spawned = false;

	if (isNil _loot_pos_key) then
	{
		if ((vn_an_seed + floor(_pos#2)) random [floor(_pos#0),floor(_pos#1)] > _chance) then
		{
			private _pos_dn = (_pos vectorAdd [0,0,-1]);
			private _pos_up = _pos_dn vectorAdd [0,0,4];
			private _intersect = lineIntersectsSurfaces [
				_pos_up,
				_pos_dn,
				player,
				objNull,
				true,
				1,
				"VIEW",
				"FIRE"
			];
			_check_counter = _check_counter +1;
			if !(_intersect isEqualTo []) then
			{
				(_intersect select 0) params ["_crate_pos","_crate_vec","_object","_building"];

				if !(isNull _building) then
				{
					_count_per_crate = getNumber (_looting_config >> typeOf _building >> "count");
					if (_count_per_crate > 0) then {

						_crate_class = selectRandom getArray (_looting_config >> typeOf _building >> "containers");

						_crate_spawned = true;
						_crate = createSimpleObject [_crate_class, _crate_pos, true];

						if (_debug_show_markers) then
						{
							_marker1 = createMarker [_loot_pos_key, _crate_pos];
							_marker1 setMarkerType "hd_dot";
						};
						_crate setVariable ["linked_building", _building];
						_crate setVariable ["linked_pos",[floor(_pos#0),floor(_pos#1),floor(_pos#2)]];
						_crate setVariable ["linked_vec",_crate_vec];
						vn_an_crates pushBack _crate;
					};
				};
			};
		};
		missionNamespace setVariable [_loot_pos_key,_crate_spawned];
	};
	_pos = (_startpos vectorAdd [_grid_x,_grid_y,0]);
};
if (_debug_show_info) then
{
	 systemChat str [(diag_tickTime - _ticktime),_check_counter, count vn_an_crates];
};
