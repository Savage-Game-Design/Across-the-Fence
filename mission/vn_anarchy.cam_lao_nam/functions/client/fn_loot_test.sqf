if (!isNil "vn_an_arrows") then
{
	{
		private _pos = getPosASL _x;
		private _loot_pos_key = format["vn_%1",[floor(_pos#0),floor(_pos#1),floor(_pos#2)]];
		missionNamespace setVariable [_loot_pos_key,nil];
		deleteVehicle _x;
	} forEach vn_an_arrows;
};

vn_an_arrows = [];

vn_an_fnc_debug_loot_bubble =
{
	_ticktime = diag_tickTime;
	_seed = 9283;
	_chance = 0.99;
	_grid_size = 1;
	_grid_x = 0;
	_grid_y = 0;
	_grid_rows = 10;
	_total_rows = _grid_rows*_grid_rows;
	_row_counter = 0;
	_offset = -((_grid_rows*_grid_size)/2);
	_playerpos = getPosASL player;
	_startpos = [floor(_playerpos#0),floor(_playerpos#1),floor(_playerpos#2)] vectorAdd [_offset,_offset,0];
	_color = "#(rgb,8,8,3)color(1,0,0,1)";

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
		_pos = (_startpos vectorAdd [_grid_x,_grid_y,-1]);

		_loot_pos_key = format["vn_%1",[floor(_pos#0),floor(_pos#1),floor(_pos#2)]];
		_loot_pos = missionNamespace getVariable [_loot_pos_key,false];
		if !(_loot_pos) then
		{

			if ((_seed + floor(ASLToATL _pos#2)) random [floor(_pos#0),floor(_pos#1)] > _chance) then
			{
				// hintSilent str ((_seed + floor(ASLToATL _pos#2)) random [_pos#0, _pos#1]);
				_pos = (_startpos vectorAdd [_grid_x,_grid_y,-1]);
				_pos_up = _pos vectorAdd [0,0,3];
				_ins = lineIntersectsSurfaces [
					_pos_up,
					_pos,
					player,
					objNull,
					true,
					1,
					"GEOM",
					"VIEW"
				];

				if !(_ins isEqualTo []) then
				{
					_pos = ((_ins select 0) select 0);
					_vec = ((_ins select 0) select 1);
					_inside = !(isNull ((_ins select 0) select 3));


					if (_inside) then
					{
						missionNamespace setVariable [_loot_pos_key,true];
						_arrow = createSimpleObject ["Sign_Arrow_F", _pos, true];
						_color = "#(rgb,8,8,3)color(0,1,0,1)";
						_arrow setObjectTexture [0, _color];
						vn_an_arrows pushBack _arrow;
					};
				};
			};
		};
	};
	hintSilent str (diag_tickTime - _ticktime);
};

0 spawn {
	// make bubble visible while moving
	while {true} do {
		call vn_an_fnc_debug_loot_bubble;
		uiSleep 1;
	};
};
