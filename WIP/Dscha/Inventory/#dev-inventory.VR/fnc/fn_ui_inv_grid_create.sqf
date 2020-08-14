/*
	create a grid in given controlGroup

*/

#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params["_disp","_ctrlGrp","_size_x", "_size_y"];

private _grid_w = (ctrlPosition _ctrlGrp)#2;
private _grid_h = ((_grid_w / 0.75) / 8) * _size_y;	//adjust to 4/3 Value - 8 == fixed grid Width
// systemchat str[_grid_w,_grid_h];
private _tile_W = _grid_w/_size_x;
private _tile_H = _grid_h/_size_y;


//adjust height of ctrlGroup (grid)
_ctrlGrp ctrlSetPositionH _grid_h;
_ctrlGrp ctrlCommit 0;

//also of the Background (DEV IDC)
_ctrlGrp_bg = _ctrlGrp controlsGroupCtrl 99999;
_ctrlGrp_bg ctrlSetPositionH _grid_h;
_ctrlGrp_bg ctrlCommit 0;


private _grid = [];
for "_p_y" from 0 to (_size_y-1)do
{
	private _curRow = [];
	private _row = _p_y;
	for "_p_x" from 0 to (_size_x-1)do	//should always be 5
	{
		_idc = parseNumber (format["%1%2",_p_y,_p_x]);
		_curRow pushback [_row,_p_x,_idc];
		_ctrl = _disp ctrlCreate ["tile_base",_idc,_ctrlGrp];
		
		_ctrl ctrlSetposition [(_tile_W*_p_x),(_tile_H*_p_y),_tile_W,_tile_H];
		_ctrl ctrlCommit 0;
	};
	_grid pushback _curRow;
};

missionNameSpace setVariable [format["vn_an_inv_grid_size_%1",(ctrlIDC _ctrlGrp)],[_size_x,_size_y]];
missionNameSpace setVariable [format["vn_an_inv_grid_%1",(ctrlIDC _ctrlGrp)],_grid];