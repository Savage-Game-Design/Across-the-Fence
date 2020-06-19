/*
	create an Item at clicked position
	
	vn_an_fnc_ui_inv_item_create
	[
		CTRL	ctrlGrp to add to	//grid_personal ("vn_an_inv_player")
		FLOAT	pos inside ctrlGrp
		FLOAT	y pos inside ctrlGrp
		ARRAY	item name (Classname) //DEV: Currently STRING path to icon!!
		ARRAY	Variables (like attachements, status, rarity, etc)
		ARRAY	currently used slots (NOT THE OFFSET of the Item itself!) ( e.g: [[0,1],[0,2],[0,3],...] )
	]
*/

#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params["_ctrl_invGrid","_pos_x","_pos_y","_item","_item_size","_canFlip","_usedSlots"];
//_item == placeholder (just a string)

private _disp = uinamespace getvariable ["vn_an_inventory", DisplayNull];
//create the Icon
_item_IDC = missionNameSpace getVariable ["vn_an_Item_IDC_count",107441];
private _ctrlGrp_icon = _disp ctrlCreate ["inv_icon",_item_IDC,_ctrl_invGrid];
missionNameSpace setVariable ["vn_an_Item_IDC_count",(_item_IDC + 1)];

(ctrlPosition _ctrl_invGrid)params["_grid_x","_grid_y","_grid_w","_grid_h"];


(missionNameSpace getVariable [format["vn_an_inv_grid_size_%1",(ctrlIDC _ctrl_invGrid)],[-1,-1]]) params["_inv_size_x","_inv_size_y"];
// _inv_size_x	-	INT - ixed amout of slots
// _inv_size_y	-	INT - variable amout of slots
if(_inv_size_x < 0 || _inv_size_y < 0)exitWith{systemchat str ["ITEM_CREATE: GRID NOT SET!",[_inv_size_x,_inv_size_y]];};
_tile_W = _grid_w / _inv_size_x;
_tile_H = _grid_h / _inv_size_y;

// systemchat str [!_canFlip, !vn_an_inv_move_placeHorizontal];
if(!_canFlip && !vn_an_inv_move_placeHorizontal)then{vn_an_inv_move_placeHorizontal = true};
//get width and height of selected icon
_ctrlGrp_icon_w = if(vn_an_inv_move_placeHorizontal)then{_tile_W*(_item_size#1)}else{_tile_H*(_item_size#0)};
_ctrlGrp_icon_h = if(vn_an_inv_move_placeHorizontal)then{_tile_H*(_item_size#0)}else{_tile_W*(_item_size#1)};

//if needed -> "rotate" the main ctrlGroup and adjust the values to 4/3 (Arma Base Resolution)
if(vn_an_inv_move_placeHorizontal)then
{
	_ctrlGrp_icon ctrlSetposition [_pos_x,_pos_y,_ctrlGrp_icon_w,_ctrlGrp_icon_h];
}else{
	_ctrlGrp_icon ctrlSetposition [_pos_x,_pos_y,(_ctrlGrp_icon_w*0.75),(_ctrlGrp_icon_h/0.75)];
};
_ctrlGrp_icon ctrlCommit 0;

//Adjust the image and background
{
	private _ctrl = _ctrlGrp_icon controlsGroupCtrl _x;
	_ctrl ctrlSetposition [0,0,_ctrlGrp_icon_w,_ctrlGrp_icon_h];
	_ctrl ctrlCommit 0;
	if(_x == 200)then
	{
		_ctrl ctrlSetText _item;
	};
	//if flipped/roated by 90° -> do other stuff
	if !(vn_an_inv_move_placeHorizontal)then
	{
		//rotate the img with the current Width and Height
		_ctrl ctrlSetAngle [90, 0.5, 0.5];
		
		//Adjust the Width and Height afterwards to the baseRes of 4/3 (Don't ask, ctrlSetAngle is "special"... ...)
		_ctrl ctrlSetposition [0,0,(_ctrlGrp_icon_w*0.75),(_ctrlGrp_icon_h/0.75)];
		_ctrl ctrlCommit 0;
	};
}forEach[100,200];


/*
	Store data if this Item:
	[
		curent pos in Grid
		occupied slots
	]
*/

_ctrlGrp_icon setVariable ["item_data",[[_pos_x,_pos_y,_ctrlGrp_icon_w,_ctrlGrp_icon_h],_usedSlots]];