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

private _disp = _this#0;

vn_an_inv_size_x = 6;	//0-X (so -1 of the actual ColCount) - FIXED SIZE - ALWAYS 6!
vn_an_inv_size_y = call vn_an_fnc_ui_inv_grid_getSize;


////// Create Inventory for Player and Ground
//create Player Inventory grid array
private _ctrlGrp = uinamespace getvariable ["vn_an_inv_player", controlNull];
[_disp,_ctrlGrp,vn_an_inv_size_x, vn_an_inv_size_y] call vn_an_fnc_ui_inv_grid_create;

//create "Ground Inventory" grid array
private _ctrlGrp = uinamespace getvariable ["vn_an_inv_player_b", controlNull];
[_disp,_ctrlGrp,vn_an_inv_size_x, 9] call vn_an_fnc_ui_inv_grid_create;



DEV_ITEMTOPLACE = 0;
vn_an_inv_move_placeHorizontal = true;
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
///////DEV
_disp displayAddEventhandler ["KeyDown",
{
	params ["_disp", "_key", "_shift", "_ctrl", "_alt"];
	_buttonDisabled = false;
	_BD = {_buttonDisabled = true};
	if(_key isEqualTo 2)then{DEV_ITEMTOPLACE = 0; call _BD;};
	if(_key isEqualTo 3)then{DEV_ITEMTOPLACE = 1; call _BD;};
	if(_key isEqualTo 4)then{DEV_ITEMTOPLACE = 2; call _BD;};
	// if(_key isEqualTo 5)then{DEV_ITEMTOPLACE = 3;};
	if(_key isEqualTo 6)then
	{
		//if RMB -> set Var to request rotate by 90°
		vn_an_inv_move_placeHorizontal = !vn_an_inv_move_placeHorizontal;
		 call _BD;
	};
	systemchat str ["DEV_ITEMTOPLACE: ", DEV_ITEMTOPLACE, " - Place Horizontal?", vn_an_inv_move_placeHorizontal];
	_buttonDisabled
}];



vn_an_FNC_TEST =
{

};