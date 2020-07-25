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
vn_an_fnc_ui_inv_grid_check_freeTiles = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_check_freeTiles.sqf";
vn_an_fnc_ui_inv_grid_updateTiles = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_updateTiles.sqf";

// DEBUG function:
vn_an_fnc_ui_inv_grid_resetColor = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_resetColor.sqf";

//handling
vn_an_fnc_ui_inv_mPos_check = compile preprocessFileLineNumbers "fnc\fn_ui_inv_mPos_check.sqf";
vn_an_fnc_ui_inv_mpos = compile preprocessFileLineNumbers "fnc\fn_ui_inv_mpos.sqf";
vn_an_fnc_ui_inv_item_create = compile preprocessFileLineNumbers "fnc\fn_ui_inv_item_create.sqf";
vn_an_fnc_ui_inv_item_remove_DEV = compile preprocessFileLineNumbers "fnc\fn_ui_inv_item_remove_DEV.sqf";
vn_an_fnc_ui_inv_item_getData = compile preprocessFileLineNumbers "fnc\fn_ui_inv_item_getData.sqf";
vn_an_fnc_ui_inv_item_grab = compile preprocessFileLineNumbers "fnc\fn_ui_inv_item_grab.sqf";


private _disp = _this#0;

vn_an_inv_size_x = 8;	//0-X (so -1 of the actual ColCount) - FIXED SIZE - ALWAYS 8!
vn_an_inv_size_y = call vn_an_fnc_ui_inv_grid_getSize;

vn_an_inv_move_placeHorizontal = true;
vn_an_ui_inv_grabActive = false;

////// Create Inventory for Player and Ground
//create Player Inventory grid array
private _ctrlGrp_pers = uinamespace getvariable ["vn_an_inv_player", controlNull];
[_disp,_ctrlGrp_pers,vn_an_inv_size_x, vn_an_inv_size_y] call vn_an_fnc_ui_inv_grid_create;

//DEV: Create Items in a Grid
//TODO: Use gridPos, instead of mousePosition!
{
	missionNameSpace setVariable ["vn_an_inv_itemActive",(_x#0)];
	[_ctrlGrp_pers,0,(_x#1),(_x#2),false,false,false] call vn_an_fnc_ui_inv_mPos;
}forEach
[
	 ["arifle_MX_F"			,0.0160714,0.0146826]
	,["magazine"			,0.0116071,0.173413]
	,["magazine"			,0.105357,0.177381]
	,["magazine"			,0.190179,0.175397]
	,["magazine"			,0.041369,0.256746]
	,["magazine"			,0.135119,0.250794]
	,["magazine"			,0.190179,0.252778]
	,["magazine"			,0.18869,0.379762]
	,["magazine"			,0.191667,0.455159]
	,["magazine"			,0.185714,0.570238]
	,["B_AssaultPack_blk"	,0.0130952,0.340079]
];

diag_log "-----------------------------------------------";
//create "Ground Inventory" grid array
private _ctrlGrp_cont = uinamespace getvariable ["vn_an_inv_player_b", controlNull];
[_disp,_ctrlGrp_cont,vn_an_inv_size_x, 10] call vn_an_fnc_ui_inv_grid_create;





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
	if(_key in [2,3,4,5,6])then
	{
		if(_key isEqualTo 2)exitWith{missionNameSpace setVariable ["vn_an_inv_itemActive",DEV_ITEMTOPLACE_LIST#0]; call _BD;};
		if(_key isEqualTo 3)exitWith{missionNameSpace setVariable ["vn_an_inv_itemActive",DEV_ITEMTOPLACE_LIST#1]; call _BD;};
		if(_key isEqualTo 4)exitWith{missionNameSpace setVariable ["vn_an_inv_itemActive",DEV_ITEMTOPLACE_LIST#2]; call _BD;};
		// if(_key isEqualTo 5)then{DEV_ITEMTOPLACE = 3;};
		if(_key isEqualTo 6)then
		{
			//if RMB -> set Var to request rotate by 90°
			vn_an_inv_move_placeHorizontal = !vn_an_inv_move_placeHorizontal;
			 call _BD;
		};
		systemchat str [" DEV_ITEMTOPLACE : ", missionNameSpace getVariable ["vn_an_inv_itemActive",[]], " - Place Horizontal?", vn_an_inv_move_placeHorizontal];
	};
	_buttonDisabled
}];



vn_an_DEV_MouseEH =
{
	//executed from grabbed Item ctrl
	disableSerialization;
	params ["_ctrl", "_btn", "_xPos", "_yPos", "_btn_shift", "_btn_ctrl", "_btn_alt"];
	// systemchat str ["Btn:",_btn];
	
	//RMB - Reset to old Pos
	if(_btn == 1 && vn_an_ui_inv_grabActive)then
	{
		private _data_prev = _ctrl getVariable ["item_data_prev",[]];
		_data_prev spawn vn_an_fnc_ui_inv_item_create;
		vn_an_ui_inv_grabActive = false;	//triggers the deletion of the temp Item
	};
	//LMB - Place Item
	if(_btn == 0)then
	{
		_this call vn_an_fnc_ui_inv_mPos_check;
	};
	
	//NEEDED!
	true
};