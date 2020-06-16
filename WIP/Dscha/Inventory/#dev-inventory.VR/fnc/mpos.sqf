
#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params ["_disp", "_btn", "_mPos_x", "_mPos_y", "_shift", "_ctrl", "_alt"];

if!(_btn in [0,1])exitWith{};
if(isNil "vn_an_inv_move_doRotate")then{vn_an_inv_move_doRotate = false};
systemchat str (["Left Mouse Button", "Right Mouse Button"]#_btn);
if(_btn == 1)exitWith{vn_an_inv_move_doRotate = !vn_an_inv_move_doRotate; systemchat str ["place Horizontal?",vn_an_inv_move_doRotate]};



_gridSize_x = 6;	//0-X (so -1 of the actual ColCount) - FIXED NUMBER - ALWAYS 6!
_gridSize_y = 11;	//0-X (so -1 of the actual RowCount)


_ctrlGrp = _disp displayCtrl 1000;	//ToDo: get active Grid ctrl dynamicaly
//Check if given pos is valid in the Grid. If so -> Return [x,y] pos in Grid
([_ctrlGrp,_mPos_x,_gridSize_x,_mPos_y,_gridSize_y] call vn_an_fnc_ui_inv_get_GridPos) params["_tile_x","_tile_y"];
systemchat str [_tile_x, _tile_y];
if([_tile_x, _tile_y] isEqualto [-1,-1])exitWith{};//systemchat str["gridPos - out of Bounds",[_tile_x, _tile_y]];};


//////////////////////////////////////////////
//ToDo: DEV: Get size of grid from Var, depending on given Gear
_grid = [];
for "_i" from 0 to _gridSize_y-1 do
{
	_curRow = [];
	_row = _i;
	for "_i" from 0 to _gridSize_x-1 do
	{
		_IDC = parseNumber format["%2%1",_i,_row];
		_curRow pushback [_row,_i,_IDC];
	};
	_grid pushback _curRow;
};

if(vn_an_tiles_usage isEqualto [])then
{
	_ctrlGrp = _disp displayCtrl 1000;
	{
		_ctrl = _ctrlGrp controlsGroupCtrl _x;
		_ctrl ctrlSetTextColor [0,0,0,0.3];
		_ctrl ctrlCommit 0;
	}forEach	[  //YX | 0 = 00 | 1 = 01
					 0,1,2,3,4,5
					,10,11,12,13,14,15
					,20,21,22,23,24,25
					,30,31,32,33,34,35
					,40,41,42,43,44,45
					,50,51,52,53,54,55
					,60,61,62,63,64,65
					,70,71,72,73,74,75
					,80,81,82,83,84,85
					,90,91,92,93,94,95
					,100,101,102,103,104,105
				];
};
//////////////////////////////////////////////

_offset_tmp =	[
						  [0,1],[0,2],[0,3],[0,4],[0,5],
					[1,0],[1,1],[1,2],[1,3],[1,4],[1,5]
				];
_offset = [[_tile_x,_tile_y]];
{
	_px = _x#0;
	_py = _x#1;
	if(vn_an_inv_move_doRotate)then
	{
		_offset pushback [ (_tile_x - (_py*-1)), (_tile_y + _px) ];
	}else{
		_offset pushback [ (_tile_x + _px), (_tile_y + _py) ];
	};
}forEach _offset_tmp;


// vn_an_tiles_usage = [];
if(isNil "vn_an_tiles_usage")then{ vn_an_tiles_usage = []; };
_canAdd = true;
_tile_list = [];
{
	_x params ["_px","_py"];
	_coords = [_px,_py];
	// systemchat str [_px > (_gridSize_x-1),_py > (_gridSize_y-1),_coords in vn_an_tiles_usage];
	// systemchat str [_coords,vn_an_tiles_usage];
	
	if	(
				_px > (_gridSize_x-1)					//if exceeds grind limit
			||	_px < 0								//if exceeds grind limit
			||	_py > (_gridSize_y-1)					//if exceeds grind limit
			||	_py < 0								//if exceeds grind limit
			||	_coords in vn_an_tiles_usage		//if something is already placed there
		)exitWith{_canAdd = false;};
	
	_tile_idc = _grid#_py#_px#2;
	_tile_list pushback [_tile_idc,_coords];
}forEach _offset;

// systemchat str [[_tile_x, _tile_y], _canAdd, _tile_list,vn_an_tiles_usage];
if(_canAdd)then
{
	_ctrlGrp = _disp displayCtrl 1000;
	{
		_x params ["_idc","_coords"];
		// private _tile = _disp displayCtrl _idc;
		private _tile = _ctrlGrp controlsGroupCtrl _idc;
		_tile ctrlSetTextColor [1,0,0,0.3];
	vn_an_tiles_usage pushbackUnique _coords;
	}forEach _tile_list;
};