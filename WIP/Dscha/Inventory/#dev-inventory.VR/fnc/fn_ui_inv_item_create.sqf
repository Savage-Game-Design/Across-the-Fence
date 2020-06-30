/*
	create an Item at clicked position
	
	vn_an_fnc_ui_inv_item_create
	[
		CTRL	ctrlGrp to add to	//grid_personal ("vn_an_inv_player")
		FLOAT	pos inside ctrlGrp
		FLOAT	y pos inside ctrlGrp
		[
			STRING	item name (Classname) //DEV: Currently STRING path to icon!!
			ARRAY	Variables (like attachements, status, rarity, etc)
			BOOL	can be flipped 90°?
		]
		ARRAY	currently used slots (NOT THE OFFSET of the Item itself!) ( e.g: [[0,1],[0,2],[0,3],...] )
	]
*/

#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params["_ctrl_invGrid","_pos_x","_pos_y","_item_class","_usedSlots"];

//get Item data from config
(_item_class call vn_an_fnc_ui_inv_item_getData) params
[
	 "_item_size"
	,"_canFlip"
	,"_cfgBase"
	,"_class_base"
];

private _disp = uinamespace getvariable ["vn_an_inventory", DisplayNull];
//create the Icon
_item_IDC = missionNameSpace getVariable ["vn_an_Item_IDC_count",107441];
private _ctrlGrp_item = _disp ctrlCreate ["inv_icon",_item_IDC,_ctrl_invGrid];
missionNameSpace setVariable ["vn_an_Item_IDC_count",(_item_IDC + 1)];

(ctrlPosition _ctrl_invGrid)params["_grid_x","_grid_y","_grid_w","_grid_h"];


(missionNameSpace getVariable [format["vn_an_inv_grid_size_%1",(ctrlIDC _ctrl_invGrid)],[-1,-1]]) params["_inv_size_x","_inv_size_y"];
// _inv_size_x	-	INT - ixed amout of slots
// _inv_size_y	-	INT - variable amout of slots
if(_inv_size_x < 0 || _inv_size_y < 0)exitWith{systemchat str ["ITEM_CREATE: GRID NOT SET!",[_inv_size_x,_inv_size_y]];};
_tile_W = _grid_w / _inv_size_x;
_tile_H = _grid_h / _inv_size_y;

// systemchat str [!_canFlip, !vn_an_inv_move_placeHorizontal];
if((_canFlip == 0) && !vn_an_inv_move_placeHorizontal)then{vn_an_inv_move_placeHorizontal = true};
//get width and height of selected icon
_ctrlGrp_item_w = if(vn_an_inv_move_placeHorizontal)then{_tile_W*(_item_size#1)}else{_tile_H*(_item_size#0)};
_ctrlGrp_item_h = if(vn_an_inv_move_placeHorizontal)then{_tile_H*(_item_size#0)}else{_tile_W*(_item_size#1)};


//if needed -> "rotate" the main ctrlGroup and adjust the values to 4/3 (Arma Base Resolution)
if(vn_an_inv_move_placeHorizontal)then
{
	_ctrlGrp_item ctrlSetposition [_pos_x,_pos_y,_ctrlGrp_item_w,_ctrlGrp_item_h];
}else{
	_ctrlGrp_item ctrlSetposition [_pos_x,_pos_y,(_ctrlGrp_item_w*0.75),(_ctrlGrp_item_h/0.75)];
};
_ctrlGrp_item ctrlCommit 0;

//Adjust the image and background
{
	private _ctrl = _ctrlGrp_item controlsGroupCtrl _x;
	_ctrl ctrlSetposition [0,0,_ctrlGrp_item_w,_ctrlGrp_item_h];
	_ctrl ctrlCommit 0;
	if(_x == 200)then
	{
		_item_img = getText(configFile >> _cfgBase >> _class_base >> "picture");
		_ctrl ctrlSetText _item_img;
	};
	//if flipped/roated by 90° -> do other stuff
	if !(vn_an_inv_move_placeHorizontal)then
	{
		//rotate the img with the current Width and Height
		_ctrl ctrlSetAngle [90, 0.5, 0.5];
		
		//Adjust the Width and Height afterwards to the baseRes of 4/3 (Don't ask, ctrlSetAngle is "special"... ...)
		_ctrl ctrlSetposition [0,0,(_ctrlGrp_item_w*0.75),(_ctrlGrp_item_h/0.75)];
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

// systemchat str ["ctrlCreate: _item_data: ", _item_data];
_ctrlGrp_item setVariable ["item_data",[[_pos_x,_pos_y,_ctrlGrp_item_w,_ctrlGrp_item_h],_usedSlots,_item_class]];