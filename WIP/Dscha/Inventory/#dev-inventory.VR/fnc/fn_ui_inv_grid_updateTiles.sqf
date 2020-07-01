

params["_ctrl_grid","_grid_tiles_used","_item_tiles_used"];
{
	_x params ["_idc","_gridPos"];
	private _tile = _ctrl_grid controlsGroupCtrl _idc;
	_tile ctrlSetTextColor [0.2,0.2,0.2,0.5];
	_grid_tiles_used pushbackUnique _gridPos;
}forEach _item_tiles_used;

private _varName_activeCtrl = format["vn_an_inv_tileUsage_%1",(ctrlIDC _ctrl_grid)];
missionNameSpace setVariable [_varName_activeCtrl,_grid_tiles_used];