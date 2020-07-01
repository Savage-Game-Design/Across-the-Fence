
#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params ["_ctrl_grid", "_btn", "_mPos_x", "_mPos_y", "_btn_shift", "_btn_ctrl", "_btn_alt"];

if!(_btn in [0])exitWith{};

(missionNameSpace getVariable [format["vn_an_inv_grid_size_%1",(ctrlIDC _ctrl_grid)],[-1,-1]]) params["_grid_size_x","_grid_size_y"];
if(_grid_size_x < 0 || _grid_size_y < 0)exitWith{systemchat str ["ITEM_CREATE: GRID NOT SET!",[_grid_size_x,_grid_size_y]];};


//Check if given pos is valid in the Grid. If so -> Return [x,y] pos in Grid
// systemchat str [ _ctrl_grid ,_mPos_x ,_grid_size_x ,_mPos_y ,_grid_size_y ];
([_ctrl_grid,_mPos_x,_grid_size_x,_mPos_y,_grid_size_y] call vn_an_fnc_ui_inv_grid_getPos) params["_tile_x","_tile_y"];
if([_tile_x, _tile_y] isEqualto [-1,-1])exitWith{/* DEV */ systemchat str["gridPos - out of Bounds",[_tile_x, _tile_y]];};


//Check if DragAndDrop is active. If so -> a suitable pos was found, so we can delete the temp Item, "attached" to the Mouse
if(vn_an_ui_inv_grabActive)then{ vn_an_ui_inv_grabActive = false; };


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

//_tiles_used == taken positions in Grid, needed to free up the needed Slots later
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



//Check of all tiles are free
private _varName_activeCtrl = format["vn_an_inv_tileUsage_%1",(ctrlIDC _ctrl_grid)];
private _grid_tiles_used = missionNameSpace getVariable [_varName_activeCtrl,[]];
private _item_tile_usage = [_ctrl_grid,_grid_size_x,_grid_size_y,_offset_pos,_grid_tiles_used] call vn_an_fnc_ui_inv_grid_check_freeTiles;


//////////////////////////////////////////////
//DEV: Reset whole grid to standard Colors (COLORS ONLY!)
if(_grid_tiles_used isEqualto [])then{  [_grid_size_x, _grid_size_y] call vn_an_fnc_ui_inv_grid_resetColor;  };
//////////////////////////////////////////////

if!(_item_tile_usage isEqualto [])then
{
	//add all tiles to the "blocked tiles"-array and store it in the Grid-ctrl itself
	[_ctrl_grid,_grid_tiles_used,_item_tile_usage] call vn_an_fnc_ui_inv_grid_updateTiles;
	
	//get position of TopLeft grid slot (will always be used)
	private _ctrl_topLeft = _ctrl_grid controlsGroupCtrl (_item_tile_usage#0#0);
	(ctrlPosition _ctrl_topLeft) params["_px","_py","_pw","_ph"];
	
	//Add icon to this position
	[_ctrl_grid,_px,_py,_item_class,_offset_pos] call vn_an_fnc_ui_inv_item_create;
	
}else{
	private _ctrl = uinamespace getVariable ["vn_an_ctrl_active",controlNull];
	if(isNull _ctrl)exitWith{};
	private _data_prev = _ctrl getVariable ["item_data_prev",[]];
	if(_data_prev isEqualto [])exitWith{};
	_data_prev call vn_an_fnc_ui_inv_item_create;
};



