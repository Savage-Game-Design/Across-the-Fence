/*
	create an Item at clicked position
	
	vn_an_fnc_ui_inv_item_create
	[
		CTRL	ctrlGrp to add to
		FLOAT	pos inside ctrlGrp
		FLOAT	y pos inside ctrlGrp
		ARRAY	item name (Classname) //DEV: Currently STRING path to icon!!
		ARRAY	Variables (like attachements, status, rarity, etc)
		ARRAY	currently used slots (NOT THE OFFSET of the Item itself!) ( e.g: [[0,1],[0,2],[0,3],...] )
	]
*/
params["_ctrl_invGrid","_pos_x","_pos_y","_item",["_vars",[],[[]]],"_usedSlots"];
//_item = placeholder

private _disp = uinamespace getvariable ["vn_an_inventory", DisplayNull];
//create the Icon
private _ctrlGrp_icon = _disp ctrlCreate ["inv_icon",987654,_ctrl_invGrid];

//ToDo: Check if horizontal or vertical ( Var: vn_an_inv_move_doRotate )
(ctrlPosition _ctrl_invGrid)params["_grid_x","_grid_y","_grid_w","_grid_h"];
// vn_an_inv_size_x	-	INT - ixed amout of slots
// vn_an_inv_size_y	-	INT - variable amout of slots
_tile_W = _grid_w / vn_an_inv_size_x;
_tile_H = _grid_h / vn_an_inv_size_y;

//get width and height of selected icon
_ctrlGrp_icon_w = (_tile_W*6);
_ctrlGrp_icon_h = (_tile_H*3);
_ctrlGrp_icon ctrlSetposition [_pos_x,_pos_y,_ctrlGrp_icon_w,_ctrlGrp_icon_h];
_ctrlGrp_icon ctrlCommit 0;
{
	_ctrl = _ctrlGrp_icon controlsGroupCtrl _x;
	_ctrl ctrlSetposition [0,0,_ctrlGrp_icon_w,_ctrlGrp_icon_h];
	_ctrl ctrlCommit 0;
}forEach[100,200];
/*
	curent pos in Grid
	occupied slots
*/
_ctrlGrp_icon setVariable ["item_data",[[_pos_x,_pos_y,_ctrlGrp_icon_w,_ctrlGrp_icon_h],_usedSlots]];