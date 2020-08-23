// global seed same on server and client
vn_an_seed = 9283;

// mock function to be remote executed from client to server
vn_an_mock_loot_re = {
	params ["_player", "_pos", "_building"];
	private _chance = 0.99;
	private _max_dist = 20;
	private _building_type = typeOf _building;
	if !(isNull _building) then {
		if (_pos distance2D _building < _max_dist) then {
			if (_player distance2D _pos < _max_dist) then {
				// check if loot pos is real
				_seed = (vn_an_seed + (_pos#2));
				if (_seed random [(_pos#0),(_pos#1)] > _chance) then
				{
					// todo do loot type lookup based on building class _building_type
					_crate_type = "type_military";
					_crate_seed = (str vn_an_seed) + (_pos joinString "");
					// todo do call to ASC to make crate and spawn loot.
					systemChat format["Spawn loot with id/seed %1 for type %2", _crate_seed, _crate_type];
				};
			} else {
				systemChat ("player too far way! crate pos:" + str _pos + " ppos: " +  str getPosASL player + " dist: " + str (_player distance2D _pos));
			};
		} else {
			systemChat ("building too far way! crate pos:" + str _pos + " ppos: " +  str getPosASL player + " dist: " + str (_player distance2D _pos));
		};

	};
};

// search action, todo to be replaced with our own interaction system
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

// remove old objects if whole function is called again
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
	private _ticktime = diag_tickTime;

	private _debug_show_markers = false;
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
				private _pos_up = _pos_dn vectorAdd [0,0,3];
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
						_crate_spawned = true;
						_crate = createSimpleObject ["Land_vn_object_trashcan_01", _crate_pos, true];

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
			missionNamespace setVariable [_loot_pos_key,_crate_spawned];
		};
		_pos = (_startpos vectorAdd [_grid_x,_grid_y,0]);
	};
	if (_debug_show_info) then
	{
		 systemChat str [(diag_tickTime - _ticktime),_check_counter, count vn_an_crates];
	};
};

0 spawn {
	// make loot spawn
	while {true} do {
		call vn_an_fnc_debug_loot_bubble;
		uiSleep 0.02;
	};
};
