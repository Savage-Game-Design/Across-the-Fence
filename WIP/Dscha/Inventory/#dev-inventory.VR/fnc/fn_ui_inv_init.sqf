/*

[]spawn 
{ 
	sleep 1; 
	vn_an_tiles_usage = [];
	(findDisplay 46) createDisplay "vn_an_inventory"; 
};

	///////////////////////////////////////////////////
	///////// ReCompiled at onLoad of Display /////////
	///////////////////////////////////////////////////
*/

//DEV: reset inv usage Var
{
	missionNameSpace setVariable [(format["vn_an_inv_tileUsage_%1",_x]),[]];
}forEach [1000,1001];

#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

//Grid
vn_an_fnc_ui_inv_grid_getSize = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_getSize.sqf";
vn_an_fnc_ui_inv_grid_create = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_create.sqf";
vn_an_fnc_ui_inv_grid_isPosIn = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_isPosIn.sqf";
vn_an_fnc_ui_inv_grid_getPos = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_getPos.sqf";

//handling
vn_an_fnc_ui_inv_mPos_check = compile preprocessFileLineNumbers "fnc\fn_ui_inv_mPos_check.sqf";
vn_an_fnc_ui_inv_mpos = compile preprocessFileLineNumbers "fnc\fn_ui_inv_mpos.sqf";
vn_an_fnc_ui_inv_item_create = compile preprocessFileLineNumbers "fnc\fn_ui_inv_item_create.sqf";
vn_an_fnc_ui_inv_item_remove_DEV = compile preprocessFileLineNumbers "fnc\fn_ui_inv_item_remove_DEV.sqf";
vn_an_fnc_ui_inv_item_grab = compile preprocessFileLineNumbers "fnc\fn_ui_inv_item_grab.sqf";


private _disp = _this#0;

vn_an_inv_size_x = 8;	//0-X (so -1 of the actual ColCount) - FIXED SIZE - ALWAYS 8!
vn_an_inv_size_y = call vn_an_fnc_ui_inv_grid_getSize;

vn_an_inv_move_placeHorizontal = true;

////// Create Inventory for Player and Ground
//create Player Inventory grid array
private _ctrlGrp_pers = uinamespace getvariable ["vn_an_inv_player", controlNull];
[_disp,_ctrlGrp_pers,vn_an_inv_size_x, vn_an_inv_size_y] call vn_an_fnc_ui_inv_grid_create;

//DEV: Create an Item in the Container Grid
{
	missionNameSpace setVariable ["vn_an_inv_itemActive",(_x#0)];
	[_ctrlGrp_pers,0,(_x#1),(_x#2),false,false,false] call vn_an_fnc_ui_inv_mPos;
}forEach
[
	 [[[4,8],"data\gun.paa",true]	,0.0160714,0.0146826]
	,[[[1,1],"data\magazine.paa",false]	,0.0160714,0.0146826]
	,[[[1,1],"data\magazine.paa",false]	,0.0190476,0.0285715]
	,[[[1,1],"data\magazine.paa",false]	,0.0205356,0.189286]
	,[[[1,1],"data\magazine.paa",false]	,0.0607142,0.185317]
	,[[[1,1],"data\magazine.paa",false]	,0.0979165,0.185317]
	,[[[1,1],"data\magazine.paa",false]	,0.142559,0.193254]
	,[[[1,1],"data\magazine.paa",false]	,0.0160713,0.244841]
	,[[[1,1],"data\magazine.paa",false]	,0.0681546,0.24881]
	,[[[4,4],"data\backpack.paa",false]	,0.0130952,0.298413]
];


//create "Ground Inventory" grid array
private _ctrlGrp_cont = uinamespace getvariable ["vn_an_inv_player_b", controlNull];
[_disp,_ctrlGrp_cont,vn_an_inv_size_x, 9] call vn_an_fnc_ui_inv_grid_create;





DEV_ITEMTOPLACE_LIST =
[
	 [[4,8],"data\gun.paa",true]
	,[[1,1],"data\magazine.paa",false]
	,[[4,4],"data\backpack.paa",false]
];
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
///////DEV

_disp displayAddEventhandler ["KeyDown",
{
	params ["_disp", "_key", "_shift", "_ctrl", "_alt"];
	_buttonDisabled = false;
	_BD = {_buttonDisabled = true};
	private _item_sel = [];
	if(_key isEqualTo 2)then{DEV_ITEMTOPLACE = DEV_ITEMTOPLACE_LIST#0; call _BD;};
	if(_key isEqualTo 3)then{DEV_ITEMTOPLACE = DEV_ITEMTOPLACE_LIST#1; call _BD;};
	if(_key isEqualTo 4)then{DEV_ITEMTOPLACE = DEV_ITEMTOPLACE_LIST#2; call _BD;};
	// if(_key isEqualTo 5)then{DEV_ITEMTOPLACE = 3;};
	
	missionNameSpace setVariable ["vn_an_inv_itemActive",DEV_ITEMTOPLACE];
	if(_key isEqualTo 6)then
	{
		//if RMB -> set Var to request rotate by 90°
		vn_an_inv_move_placeHorizontal = !vn_an_inv_move_placeHorizontal;
		 call _BD;
	};
	systemchat str [" DEV_ITEMTOPLACE : ", DEV_ITEMTOPLACE, " - Place Horizontal?", vn_an_inv_move_placeHorizontal];
	_buttonDisabled
}];



vn_an_DEV_MouseEH =
{
	params ["_ctrl", "_btn", "_xPos", "_yPos", "_btn_shift", "_btn_ctrl", "_btn_alt"];
	// systemchat str ["Btn:",_btn];
	
	//TODO: Reset to old Pos, instead of deleting
	if(_btn == 1)exitWith
	{
		ctrlDelete _ctrl;
	};
	
	if(_btn == 0)exitWith
	{
		// ctrlDelete _ctrl;
		_this call vn_an_fnc_ui_inv_mPos_check;
		ctrlDelete _ctrl;
	};
};