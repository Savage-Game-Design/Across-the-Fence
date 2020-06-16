
#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params ["_disp", "_btn", "_mPos_x", "_mPos_y", "_shift", "_ctrl", "_alt"];

if!(_btn in [0,1])exitWith{};
if(isNil "vn_an_inv_move_doRotate")then{vn_an_inv_move_doRotate = false};
systemchat str (["Left Mouse Button", "Right Mouse Button"]#_btn);
if(_btn == 1)exitWith{vn_an_inv_move_doRotate = !vn_an_inv_move_doRotate; systemchat str ["place Horizontal?",vn_an_inv_move_doRotate]};



private _gridSize_x = vn_an_inv_size_x;	//fixed
private _gridSize_y = vn_an_inv_size_y;	//variable size


private _ctrlGrp = _disp displayCtrl 1000;	//ToDo: get active Grid ctrl dynamicaly
//Check if given pos is valid in the Grid. If so -> Return [x,y] pos in Grid
([_ctrlGrp,_mPos_x,_gridSize_x,_mPos_y,_gridSize_y] call vn_an_fnc_ui_inv_get_GridPos) params["_tile_x","_tile_y"];
systemchat str [_tile_x, _tile_y];
if([_tile_x, _tile_y] isEqualto [-1,-1])exitWith{};//systemchat str["gridPos - out of Bounds",[_tile_x, _tile_y]];};

//get grid Data from currently active "Grid ctrl"
private _grid = missionNameSpace getVariable [format["vn_an_inv_grid_%1",(ctrlIDC _ctrlGrp)],[]];


//////////////////////////////////////////////
//DEV: Reset whole grid to standard Colors
if(vn_an_tiles_usage isEqualto [])then
{
	private _ctrlGrp = _disp displayCtrl 1000;
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
//ToDo: a shitload of stuff... get Type, get offset, icon... omg...
private _offset_tmp =	[
						  [0,1],[0,2],[0,3],[0,4],[0,5],
					[1,0],[1,1],[1,2],[1,3],[1,4],[1,5]
				];
private _offset = [[_tile_x,_tile_y]];	//store first Pos (needed, since the offset will determined from this position)
{
	_x params["_px","_py"];
	if(vn_an_inv_move_doRotate)then
	{
		_offset pushback [ (_tile_x - (_py*-1)), (_tile_y + _px) ];
	}else{
		_offset pushback [ (_tile_x + _px), (_tile_y + _py) ];
	};
}forEach _offset_tmp;


// vn_an_tiles_usage = [];
//ToDo: Reload previous tiles_usage
if(isNil "vn_an_tiles_usage")then{ vn_an_tiles_usage = []; };
private _canAdd = true;
private _tile_list = [];
{
	_x params ["_px","_py"];
	private _gridPos = [_px,_py];
	// systemchat str [_px > (_gridSize_x-1),_py > (_gridSize_y-1),_gridPos in vn_an_tiles_usage];
	// systemchat str [_gridPos,vn_an_tiles_usage];
	
	if	(
				_px > (_gridSize_x-1)					//if exceeds grind limit
			||	_px < 0								//if exceeds grind limit
			||	_py > (_gridSize_y-1)					//if exceeds grind limit
			||	_py < 0								//if exceeds grind limit
			||	_gridPos in vn_an_tiles_usage		//if something is already placed there
		)exitWith{_canAdd = false;};
	
	private _tile_idc = _grid#_py#_px#2;
	_tile_list pushback [_tile_idc,_gridPos];
}forEach _offset;

// systemchat str [[_tile_x, _tile_y], _canAdd, _tile_list,vn_an_tiles_usage];
if(_canAdd)then
{
	private _ctrlGrp = _disp displayCtrl 1000;
	{
		_x params ["_idc","_gridPos"];
		private _tile = _ctrlGrp controlsGroupCtrl _idc;
		_tile ctrlSetTextColor [1,0,0,0.3];
	vn_an_tiles_usage pushbackUnique _gridPos;
	}forEach _tile_list;
};