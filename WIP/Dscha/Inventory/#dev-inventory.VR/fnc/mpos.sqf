
#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params ["_disp", "_btn", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

if!(_btn in [0,1])exitWith{};
if(isNil "vn_an_inv_move_doRotate")then{vn_an_inv_move_doRotate = false};
systemchat str (["Left Mouse Button", "Right Mouse Button"]#_btn);
if(_btn == 1)exitWith{vn_an_inv_move_doRotate = !vn_an_inv_move_doRotate; systemchat str ["place Horizontal?",vn_an_inv_move_doRotate]};

// _ctrl_bg = _disp displayCtrl 123456;
// (ctrlPosition _ctrl_bg) params["_bg_x","_bg_y","_bg_w","_bg_h"];
_ctrlGrp = _disp displayCtrl 1000;
(ctrlPosition _ctrlGrp) params["_bg_x","_bg_y","_bg_w","_bg_h"];


_grid_w = _bg_x + _bg_w;
_grid_h = _bg_y + _bg_h;

_tiles_x = 6;	//0-X (so -1 of the actual ColCount) - FIXED NUMBER - ALWAYS 6!
_tiles_y = 8;	//0-X (so -1 of the actual RowCount)

_mPos_x = _xPos - _bg_x;
_tile_w_size = _bg_w / _tiles_x;

_mPos_y = _yPos - _bg_y;
_tile_h_size = _bg_h / _tiles_y;

_tile_x = floor(_mPos_x / _tile_w_size);
_tile_y = floor(_mPos_y / _tile_h_size);

systemchat str [_tile_x, _tile_y];
if	(
		_tile_x < 0 ||
		_tile_x > (_tiles_x-1) ||
		_tile_y < 0 ||
		_tile_y > (_tiles_y-1)
	)exitWith{systemchat "Out of Bounds";};		//Out of Bounds

_grid = [];
for "_i" from 0 to _tiles_y-1 do
{
	_curRow = [];
	_row = _i;
	for "_i" from 0 to _tiles_x-1 do
	{
		_IDC = parseNumber format["%1%2",_i,_row];
		_curRow pushback [_row,_i,_IDC];
	};
	_grid pushback _curRow;
};

/*
[]spawn 
{ 
	sleep 1; 
	vn_an_tiles_usage = [];
	(findDisplay 46) createDisplay "vn_an_inventory"; 
};
*/

// if(true)exitWith{};
if(vn_an_tiles_usage isEqualto [])then
{
	_ctrlGrp = _disp displayCtrl 1000;
	{
		_ctrl = _ctrlGrp controlsGroupCtrl _x;
		_ctrl ctrlSetTextColor [0,0,0,0.3];
		_ctrl ctrlCommit 0;
	}forEach	[  //YX | 0 = 00 | 1 = 01
					 0,10,20,30,40,50
					,1,11,21,31,41,51
					,2,12,22,32,42,52
					,3,13,23,33,43,53
					,4,14,24,34,44,54
					,5,15,25,35,45,55
				];
};

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
	// systemchat str [_px > (_tiles_x-1),_py > (_tiles_y-1),_coords in vn_an_tiles_usage];
	// systemchat str [_coords,vn_an_tiles_usage];
	
	if	(
				_px > (_tiles_x-1)					//if exceeds grind limit
			||	_px < 0								//if exceeds grind limit
			||	_py > (_tiles_y-1)					//if exceeds grind limit
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