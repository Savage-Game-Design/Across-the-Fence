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

_disp = _this#0;

systemchat str [_disp];