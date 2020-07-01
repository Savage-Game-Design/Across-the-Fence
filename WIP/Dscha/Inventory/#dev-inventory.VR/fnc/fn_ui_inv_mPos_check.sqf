/*
	Used for Drag&Drop Events! (EH MB Down/UP don't work/trigger propery while MB is keeping pressed)

*/

params ["_ctrl", "_btn", "_mPos_x", "_mPos_y", "_btn_shift", "_btn_ctrl", "_btn_alt"];


if(_btn == 1)exitWith{};	//DEV: For now
//Only allow LMB
if!(_btn in [0])exitWith{};

uinameSpace setVariable ["vn_an_grid_active",controlNull];
private _mPos = [_mPos_x,_mPos_y];
{
	_x params["_var_toCheck","_var_toPass"];
	private _ctrl = uinamespace getvariable [_var_toCheck,controlNull];
	if(!isNull _ctrl)then
	{
		(ctrlPosition _ctrl) params["_p_x","_p_y","_p_w","_p_h"];
		_w_halved = _p_w / 2;
		_h_halved = _p_h / 2;
		_x_center = _p_x + _w_halved;
		_y_center = _p_y + _h_halved;
		
		_check = _mPos inArea [[_x_center,_y_center], _w_halved, _h_halved, 0, true];
		// systemchat str ["_check: ",_check];
		if(_check)exitWith
		{
			_ctrl_toPass = uinameSpace getVariable [_var_toPass,controlNull];
			[_ctrl_toPass,_btn,(_mPos_x - _p_x),(_mPos_y - _p_y),_btn_shift,_btn_ctrl,_btn_alt] call vn_an_fnc_ui_inv_mpos;
			// diag_log [(_mPos_x - _p_x),(_mPos_y - _p_y)];
		};
	};
}forEach[
			 ["vn_an_inv_player_area","vn_an_inv_player"]
			,["vn_an_inv_player_b_area","vn_an_inv_player_b"]
		];