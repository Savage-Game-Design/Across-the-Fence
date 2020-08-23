// [16169.5,7656.14,0.00151062]
vn_an_seed = 9283;

vn_an_mock_loot_re = {
	params ["_player", "_pos", "_building"];
	//hintSilent str _this;
	_chance = 0.99;
	_type = typeOf _building;
	if (_player distance2D _pos < 5) then {
		// check if loot pos is real
		_seed = (vn_an_seed + (_pos#2));
		if (_seed random [(_pos#0),(_pos#1)] > _chance) then
		{
			// todo do loot type lookup based on building class
			_loot_type = "type_military";
			hintSilent format["Spawn loot with id/seed %1 for type %2", _pos joinString "", _loot_type];
		};
		// hintSilent str _seed;
	} else {
		hintSilent ("player too far way crate pos:" + str _pos + " ppos: " +  str getPosASL player + " dist: " + str (_player distance2D _pos));
	};
};

player addAction
[
	"Search",	// title
	{
		params ["_target", "_caller", "_actionId", "_arguments"]; // script
		_building = cursorObject getVariable ["linked_building",objNull];
		_pos = cursorObject getVariable ["linked_pos",[0,0,0]];
		// "send re to server to loot object with ref to crate object and crate pos and building item is spawned in"
		[player,_pos,_building] call vn_an_mock_loot_re;
	},
	nil,		// arguments
	1.5,		// priority
	true,		// showWindow
	true,		// hideOnUse
	"",			// shortcut
	"cursorObject in vn_an_crates", 	// condition
	5,			// radius
	false,		// unconscious
	"",			// selection
	""			// memoryPoint
];


// remove old objects
if (!isNil "vn_an_crates") then
{
	{
		private _pos = getPosASL _x;
		private _loot_pos_key = format["vn_%1",[floor(_pos#0),floor(_pos#1),floor(_pos#2)]];
		missionNamespace setVariable [_loot_pos_key,nil];
		deleteVehicle _x;
	} forEach vn_an_crates;
};

vn_an_crates = [];
vn_an_fnc_debug_loot_bubble =
{
	_ticktime = diag_tickTime;
	_chance = 0.99;
	_grid_size = 1;
	_grid_x = 0;
	_grid_y = 0;
	_grid_rows = 20;
	_total_rows = _grid_rows*_grid_rows;
	_row_counter = 0;
	_offset = -((_grid_rows*_grid_size)/2);
	_playerpos = getPosASL player;
	_startpos =  [floor(_playerpos#0),floor(_playerpos#1),floor(_playerpos#2)] vectorAdd [_offset,_offset,0];
	_pos = _startpos;
	_color = "#(rgb,8,8,3)color(1,0,0,1)";

	_check_counter = 0;

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
		_spawned_loot_crate = false;

		if (isNil _loot_pos_key) then
		{

			if ((vn_an_seed + floor(_pos#2)) random [floor(_pos#0),floor(_pos#1)] > _chance) then
			{
				// hintSilent str ((_seed + floor(ASLToATL _pos#2)) random [_pos#0, _pos#1]);
				_pos_dn = (_pos vectorAdd [0,0,-1]);
				_pos_up = _pos_dn vectorAdd [0,0,3];
				_ins = lineIntersectsSurfaces [
					_pos_up,
					_pos_dn,
					player,
					objNull,
					true,
					1,
					"GEOM",
					"VIEW"
				];
				_check_counter = _check_counter +1;
				if !(_ins isEqualTo []) then
				{
					_crate_pos = ((_ins select 0) select 0);
					_vec = ((_ins select 0) select 1);
					_inside = !(isNull ((_ins select 0) select 3));


					if (_inside) then
					{
						_spawned_loot_crate = true;
						_crate = createSimpleObject ["Land_vn_object_trashcan_01", _crate_pos, true];

						_marker1 = createMarker [_loot_pos_key, _crate_pos];
						_marker1 setMarkerType "hd_dot";

						_color = "#(rgb,8,8,3)color(0,1,0,1)";
						_crate setObjectTexture [0, _color];
						_crate setVariable ["linked_building", (_ins select 0) select 3];
						_crate setVariable ["linked_pos",[floor(_pos#0),floor(_pos#1),floor(_pos#2)]];
						vn_an_crates pushBack _crate;
					};
				};
			};
			missionNamespace setVariable [_loot_pos_key,_spawned_loot_crate];
		};
		_pos = (_startpos vectorAdd [_grid_x,_grid_y,0]);
	};
	// hintSilent str [(diag_tickTime - _ticktime),_check_counter, count vn_an_crates];
};

0 spawn {
	// make bubble visible while moving
	while {true} do {
		call vn_an_fnc_debug_loot_bubble;
		uiSleep 0.02;
	};
};
