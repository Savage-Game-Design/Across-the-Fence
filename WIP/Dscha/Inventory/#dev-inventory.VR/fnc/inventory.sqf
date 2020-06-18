/*

[]spawn 
{ 
	sleep 1; 
	vn_an_tiles_usage = [];
	(findDisplay 46) createDisplay "vn_an_inventory"; 
};

*/

#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"


vn_an_fnc_mpos = compile preprocessFileLineNumbers "fnc\mpos.sqf";
vn_an_fnc_list_move = compile preprocessFileLineNumbers "fnc\fn_list_move.sqf";
vn_an_fnc_ui_inv_get_GridPos = compile preprocessFileLineNumbers "fnc\fn_ui_inv_get_GridPos.sqf";
vn_an_fnc_ui_inv_check_posInGrid = compile preprocessFileLineNumbers "fnc\fn_ui_inv_check_posInGrid.sqf";
vn_an_fnc_ui_inv_grid_create = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_create.sqf";
vn_an_fnc_ui_inv_grid_getSize = compile preprocessFileLineNumbers "fnc\fn_ui_inv_grid_getSize.sqf";
vn_an_fnc_ui_inv_item_create = compile preprocessFileLineNumbers "fnc\fn_ui_inv_item_create.sqf";

_disp = _this#0;
_ctrlGrp = _disp displayCtrl 1000;

vn_an_inv_size_x = 6;	//0-X (so -1 of the actual ColCount) - FIXED SIZE - ALWAYS 6!
vn_an_inv_size_y = call vn_an_fnc_ui_inv_grid_getSize;

//create grid array
[_disp,_ctrlGrp,vn_an_inv_size_x, vn_an_inv_size_y] call vn_an_fnc_ui_inv_grid_create;



systemchat str [_disp];

_disp displayAddEventhandler ["KeyDown",
{
	params ["_disp", "_key", "_shift", "_ctrl", "_alt"];
	if(isNil "vn_an_inv_move_placeHorizontal")then{DEV_ITEMTOPLACE = 0};
	if(_key isEqualTo 2)then{DEV_ITEMTOPLACE = 0;};
	if(_key isEqualTo 3)then{DEV_ITEMTOPLACE = 1;};
	if(_key isEqualTo 4)then{DEV_ITEMTOPLACE = 2;};
	systemchat str ["DEV_ITEMTOPLACE: ", DEV_ITEMTOPLACE];
}];