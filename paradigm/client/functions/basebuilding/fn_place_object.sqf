/*
	File: fn_place_object.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Spawns object and loads related data

	Parameter(s):
		_class - Classname of the object [String, defaults to "Land_vn_b_tower_01"]
		_buildingCheck - [args, code] - Called to check if a building can be placed [ARRAY]

	Returns: nothing

	Example(s):
		["Land_vn_b_tower_01"] spawn para_c_fnc_place_object;
*/
//code
params [
	["_class","Land_vn_b_tower_01"],
	["_buildingCheck", [[], {}]]
];

if (_buildingCheck isEqualType {}) then {
	_buildingCheck = [[], _buildingCheck];
};

//Abort building if we're already building.
call para_c_fnc_abort_building;

para_l_placing_script = _thisScript;

private _objectConfig = (missionConfigFile >> "gamemode" >> "buildables" >> _class);

if (!isClass _objectConfig) exitWith {["Building not in buildables config %1", _class] call BIS_fnc_logFormat;};

private _transparent = "#(rgb,8,8,3)color(1,1,1,0)";	// transparent texture
private _whitetexture = "#(rgb,8,8,3)color(1,1,1,0.7)";	// white texture
private _bluetexture = "#(rgb,8,8,3)color(0,0,1,0.7)"; 	// blue texture
private _greentexture = "#(rgb,8,8,3)color(0,1,0,0.7)"; // green texture
private _redtexture = "#(rgb,8,8,3)color(1,0,0,0.7)"; 	// red texture

//Load information on the object
private _initialClass = getText (_objectConfig >> "build_states" >> "initial_state" >> "object_class");
private _initialRotation = getNumber (_objectConfig >> "rotation");

private _neededNearby = getArray (_objectConfig >> "nearby");
private _initialOffset = getArray (_objectConfig >> "offset");

private _checkPosStart = getArray (_objectConfig >> "check_pos_start");
if (_checkPosStart isEqualTo []) then {
	_checkPosStart = [0,0,0];
};

private _checkPosStop = getArray (_objectConfig >> "check_pos_stop");
if (_checkPosStop isEqualTo []) then {
	_checkPosStop = [0,0,-1];
};

if (_initialOffset isEqualTo []) then
{
	_initialOffset = [10,0,0];
};
private _maxSegments = getNumber (_objectConfig >> "max_segments");

private _minDistance = getNumber (_objectConfig >> "min_distance");
if (_minDistance isEqualTo 0) then
{
	_minDistance = 5;
};
private _maxDistance = getNumber (_objectConfig >> "max_distance");
if (_maxDistance isEqualTo 0) then
{
	_maxDistance = 10;
};

private _buildingCheckArgs = _buildingCheck # 0;
private _buildingCheckCode = _buildingCheck # 1;

private _pos = player getRelPos [_minDistance, 0];
private _lastDistance = 0;

para_l_placing_object = createVehicle [_initialClass, _pos, [], 0, "CAN_COLLIDE"];
para_l_placing_object setVectorUp [0,0,1];

_objects = [];
_objects pushBack para_l_placing_object;

// bridge or wall
if (_maxSegments > 0) then
{
	private _newOffset = _initialOffset;
	for "_i" from 1 to _maxSegments do
	{
		_tmp = _initialClass createVehicle [0,0,0];
		_objects pushBack _tmp;
		_tmp attachTo [para_l_placing_object, _newOffset];
		_newOffset = _newOffset vectorAdd _initialOffset;
	};
};

["setlocaleh", [_objects]] call para_c_fnc_call_on_server;

para_l_placing = true;
para_l_placing_in_progress = false;
para_l_placing_allowed = true;
para_l_placing_aborted = false;

para_l_building_action_id = [
	player,											// Object the action is attached to
	localize "STR_vn_mf_build",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",				// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",				// Progress icon shown on screen
	"para_l_placing && para_l_placing_allowed",						// Condition for the action to be shown
	"para_l_placing && para_l_placing_allowed",						// Condition for the action to progress
	{
		para_l_placing_in_progress = true;
		playSound selectRandom ["vn_build_1","vn_build_2","vn_build_3"];
		[format["<t font='tt2020base_vn' color='#ff0000' size = '.8'>%1</t>", localize "STR_para_building_placing_in_progress"],0,0,1,0,0,789] spawn BIS_fnc_dynamicText;
	},											// Code executed when action starts
	{},											// Code executed on every progress tick
	{
		params ["_target", "_caller", "_action_id", "_arguments"];
		para_l_placing = false;
		_arguments params ['_class','_neededNearby','_checkPosStart','_checkPosStop'];
		private _removeNext = false;
		// check all attached objects are visible
		{
			if (_removeNext) then
			{
				detach _x;
				deleteVehicle _x;
			};
			[
				_buildingCheckArgs,
				[_x,_neededNearby,_checkPosStart,_checkPosStop]
			] call _buildingCheckCode params ["_xisallowed","_xtext"];
			if (_xisallowed) then
			{
				_removeNext = true;
			};
		} forEach attachedObjects para_l_placing_object;

		private _objects = [para_l_placing_object] + attachedObjects para_l_placing_object;
		private _objectInfo = _objects apply {[_x, getPosWorld _x, getDir _x]};

		// Call out to tutorial system.
		["placedBuilding", [player, []]] call para_g_fnc_event_dispatch;

		["placedbuilding", [_objectInfo, _class]] call para_c_fnc_call_on_server;
		para_l_placing_object = objNull;
		para_l_buildmode = nil;
	},											// Code executed on completion
	{
		para_l_placing_in_progress = false;
		_sound = ASLToAGL [0,0,0] nearestObject "#soundonvehicle";
		if !(isNull _sound) then
		{
			deleteVehicle _sound;
		};
		para_l_placing_aborted = true;

	},												// Code executed on interrupted
	[_class,_neededNearby,_checkPosStart,_checkPosStop],											// Arguments passed to the scripts as _this select 3
	2,												// Action duration [s]
	100,												// Priority
	true,												// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;

para_l_placing_click_handler = (findDisplay 46) displayAddEventHandler ["MouseButtonUp", {
	params ["_displayorcontrol", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
	if (!scriptDone para_l_placing_script && _button <= 2) then {
		//LMB, RMB, Middle
		private _diff = [1, -1, 0] select _button;
		//Wrap around at 3.
		para_l_placing_mode = (para_l_placing_mode + _diff) % 3;
		if (para_l_placing_mode < 0) then {para_l_placing_mode = 2};
		private _content = [
			localize "STR_para_building_position",
			localize "STR_para_building_rotation",
			localize "STR_para_building_height"
		] select para_l_placing_mode;
		[_content, -1, -1, 2, 1, 0] spawn BIS_fnc_dynamicText;
	};
}];

para_l_placing_mode = 0;
para_l_placing_center_pos = [0,0,0];
para_l_placing_last_player_dir = getDir player;
para_l_placing_final_rotation = _initialRotation;
para_l_placing_height = -1;

//Compensate for attachTo using model center.
private _heightOffset = (getPosWorld para_l_placing_object # 2) - (getPosASL para_l_placing_object # 2);

hint parseText format ["<t size='2'>%1</t><br/>%2", localize "STR_para_building_hint_header", localize "STR_para_building_hint_body"];

while {para_l_placing} do
{
	uiSleep 0.02;

	if (currentWeapon player != "") then {
		// holster weapon
		para_l_holstered = currentMuzzle player;
		player action["switchWeapon", player, player, 100];
	};

	if !(para_l_placing_in_progress) then
	{
		private _startPos = AGLtoASL positionCameraToWorld [0,0,1];
		private _endPos = _startPos vectorAdd (getCameraViewDirection player vectorMultiply 40);
		private _intersections = lineIntersectsSurfaces [
			_startPos,
			_endPos,
			player,
			para_l_placing_object,
			true
		];

		//This is the position the player is currently looking at.
		private _lookPos = _intersections + [[_endPos]] select 0 select 0;
		private _playerDir = getDir player;

		switch (para_l_placing_mode) do {
			//Mode 0 - Set object position
			case 0: {
				if (freeLook || _lookPos isEqualTo []) exitWith {};
				para_l_placing_center_pos = _lookPos;
				if (para_l_placing_height >= 0) then {para_l_placing_center_pos set [2, para_l_placing_height]};
			};
			//Mode 1 - Set object rotation
			case 1: {
				if (freeLook) exitWith {};
				private _dirDelta = (_playerDir - para_l_placing_last_player_dir) * 3.5;
				para_l_placing_final_rotation = para_l_placing_final_rotation + _dirDelta;
			};
			//Mode 2 - Set object height
			case 2: {
				if (freeLook) exitWith {};
				para_l_placing_height = (_startPos vectorAdd (getCameraViewDirection player vectorMultiply (_startPos distance2D para_l_placing_center_pos))) select 2;
				para_l_placing_center_pos set [2, para_l_placing_height];
			};
		};

		//Calculate attach position
		private _offset = player worldToModelVisual ASLtoAGL para_l_placing_center_pos vectorAdd [0,0,_heightOffset];
		//We use "attachTo" so that it syncs quickly.
		para_l_placing_object attachTo [player, _offset];

		//Calculate correct rotation
		private _dir = para_l_placing_final_rotation - getDir player;
		para_l_placing_object setDir _dir;
		para_l_placing_last_player_dir = _playerDir;

		// visually calculate distance by segments
		[
			_buildingCheckArgs,
			[para_l_placing_object,_neededNearby,_checkPosStart,_checkPosStop]
		] call _buildingCheckCode params ["_isallowed","_text"];
		para_l_placing_allowed = _isallowed;
		private _hideRemainder = false;
		{
			private _xisallowed = false;
			if (!_hideRemainder) then
			{
				[
					_buildingCheckArgs,
					[_x,_neededNearby,_checkPosStart,_checkPosStop]
				] call _buildingCheckCode params ["_xisallowed","_xtext"];
				_hideRemainder = _xisallowed;
			} else {
				_x setObjectTextureGlobal [0, _transparent];
			};
		} forEach attachedObjects para_l_placing_object;
	}
	else
	{
		detach para_l_placing_object;
		{
			private _textures = getObjectTextures _x;
			if !(_transparent in _textures) then
			{
				_x setObjectTextureGlobal [0, _bluetexture];
			};
		} forEach attachedObjects para_l_placing_object;
		para_l_placing_object setObjectTextureGlobal [0, _bluetexture];
	};
};

if (!isNil "para_l_holstered") then {
	// unholster weapon
	player selectWeapon para_l_holstered;
	para_l_holstered = nil;
};

if !(isNull para_l_placing_object) then
{
	{
		detach _x;
		deleteVehicle _x;
	} forEach attachedObjects para_l_placing_object;
	deleteVehicle para_l_placing_object;

	[player,para_l_building_action_id] call BIS_fnc_holdActionRemove;
};
