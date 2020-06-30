
#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params ["_ctrlGrp", "_btn", "_mPos_x", "_mPos_y", "_btn_shift", "_btn_ctrl", "_btn_alt"];

if!(_btn in [0])exitWith{};

(missionNameSpace getVariable [format["vn_an_inv_grid_size_%1",(ctrlIDC _ctrlGrp)],[-1,-1]]) params["_inv_size_x","_inv_size_y"];
if(_inv_size_x < 0 || _inv_size_y < 0)exitWith{systemchat str ["ITEM_CREATE: GRID NOT SET!",[_inv_size_x,_inv_size_y]];};
private _gridSize_x = _inv_size_x;	//INT - fixed amout of slots
private _gridSize_y = _inv_size_y;	//INT - variable amout of slots


//Check if given pos is valid in the Grid. If so -> Return [x,y] pos in Grid
// systemchat str [ _ctrlGrp ,_mPos_x ,_gridSize_x ,_mPos_y ,_gridSize_y ];
([_ctrlGrp,_mPos_x,_gridSize_x,_mPos_y,_gridSize_y] call vn_an_fnc_ui_inv_grid_getPos) params["_tile_x","_tile_y"];
if([_tile_x, _tile_y] isEqualto [-1,-1])exitWith{};//systemchat str["gridPos - out of Bounds",[_tile_x, _tile_y]];};


private _varName_activeCtrl = format["vn_an_inv_tileUsage_%1",(ctrlIDC _ctrlGrp)];
private _usedSlots = missionNameSpace getVariable [_varName_activeCtrl,[]];

//////////////////////////////////////////////
//DEV: Reset whole grid to standard Colors
if(_usedSlots isEqualto [])then
{
	for "_idc_mod" from 0 to ((_gridSize_y-1)*10) step 10 do
	{
		for "_idc" from 0 to (_inv_size_x-1) do
		{
			private _ctrl = _ctrlGrp controlsGroupCtrl (_idc_mod + _idc);
			_ctrl ctrlSetTextColor [0,0,0,1];
			_ctrl ctrlCommit 0;
		};
	};
};




//////////////////////////////////////////////
private _item_class = missionNameSpace getVariable ["vn_an_inv_itemActive",[]];
private _item_data = _item_class call vn_an_fnc_ui_inv_item_getData;
_item_data params
[
	 "_item_data_size"
	,"_item_data_canFlip"
	,"_item_data_cfgBase"
	,"_item_data_class_base"
];

private _offset_data = [];
for "_row" from 0 to ((_item_data_size#0)-1) do	//Index start 0 == -1 = correct Index Pos
{
	for "_col" from 0 to ((_item_data_size#1)-1) do	//Index start 0 == -1 = correct Index Pos
	{
		_offset_data pushback [_row,_col];
	};
};

//_usedSlots == taken positions in Grid, needed to free up the needed Slots later
private _offset_pos = [[_tile_x,_tile_y]];	//store first Pos (needed, since the offset will determined from this position)
{
	_x params["_px","_py"];
	if(vn_an_inv_move_placeHorizontal)then
	{
		_offset_pos pushbackUnique [ (_tile_x - (_py*-1)), (_tile_y + _px) ];
	}else{
		_offset_pos pushbackUnique [ (_tile_x + _px), (_tile_y + _py) ];
	};
}forEach _offset_data;



//get grid Data from currently active "Grid ctrl"
private _grid = missionNameSpace getVariable [format["vn_an_inv_grid_%1",(ctrlIDC _ctrlGrp)],[]];

//ToDo: Reload previous tiles_usage
private _canAdd = true;
private _tile_list = [];
{
	_x params ["_px","_py"];
	private _gridPos = [_px,_py];
	if	(
				_px > (_gridSize_x-1)				//if exceeds grind limit
			||	_px < 0								//if exceeds grind limit
			||	_py > (_gridSize_y-1)				//if exceeds grind limit
			||	_py < 0								//if exceeds grind limit
			||	_gridPos in _usedSlots		//if something is already placed there
		)exitWith{_canAdd = false;};
	
	private _tile_idc = _grid#_py#_px#2;
	_tile_list pushback [_tile_idc,_gridPos];
}forEach _offset_pos;

// systemchat str [[_tile_x, _tile_y], _canAdd, _tile_list,_usedSlots];
if(_canAdd)then
{
	{
		_x params ["_idc","_gridPos"];
		private _tile = _ctrlGrp controlsGroupCtrl _idc;
		_tile ctrlSetTextColor [0.2,0.2,0.2,0.5];
		_usedSlots pushbackUnique _gridPos;
	}forEach _tile_list;
	
	missionNameSpace setVariable [_varName_activeCtrl,_usedSlots];
	
	//get position of TopLeft grid slot (will always be used)
	private _ctrl_topLeft = _ctrlGrp controlsGroupCtrl (_tile_list#0#0);
	(ctrlPosition _ctrl_topLeft) params["_px","_py","_pw","_ph"];
	
	//Add icon to this position
	[_ctrlGrp,_px,_py,_item_class,_offset_pos] call vn_an_fnc_ui_inv_item_create;
};



