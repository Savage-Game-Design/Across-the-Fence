/*
	get grid Position ([0,0]/[10,5]/etc) from the mousePos of the given gridCtrl
	!! WARNING !!
	Can return negative or "out of bounds" values!!
	Needs counterchecking the result for a "[-1,-1]" return (out of bounds), after executing this function!
*/

params["_ctrl","_mPos_x","_grid_x","_mPos_y","_grid_y"];

(ctrlPosition _ctrl) params["_x","_y","_w","_h"];
private _mP_x = _mPos_x - _x;	//get mousePos X, relative to X of ctrl
private _t_w = _w / _grid_x;	//get tileSize Width
private _mP_y = _mPos_y - _y;	//get mousePos Y, relative to Y of ctrl
private _t_h = _h / _grid_y;	//get tileSize Height

//calc the gridPos
private _t_x = floor(_mP_x / _t_w);		//[X,..]
private _t_y = floor(_mP_y / _t_h);		//[..,Y]

//Check if within existing/given grid
private _inGrid = [_t_x,_grid_x,_t_y,_grid_y] call vn_an_fnc_ui_inv_grid_isPosIn;
private _ret = [-1,-1];
systemchat str [_t_x,_t_y];
if(_inGrid)then{_ret = [_t_x,_t_y]};
_ret