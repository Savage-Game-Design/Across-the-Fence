
#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params ["_displayorcontrol", "_scroll"];
_mode = if(_scroll < 0)then{UIY(1)}else{UIY((-1))};
_disp = uinamespace getvariable ["vn_an_inventory", DisplayNull];

//Check first Ctrl:
// _ctrl = _disp displayCtrl 100;
// _p = ctrlPosition _ctrl;
// _y_new = ((_p#1) + _mode);
// systemchat str[_y_new];
// if(_y_new > 0)exitWith{};


_ctrlGrp = _disp displayCtrl 1000;
_p = ctrlPosition _ctrlGrp;
_y_new = ((_p#1) + _mode);
_ctrlGrp ctrlSetPositionY _y_new;
_ctrlGrp ctrlCommit 0.05;
if(_y_new > 0)exitWith{};



/*
{
	_ctrl = _disp displayCtrl _x;
	_p = ctrlPosition _ctrl;
	
	_y_new = ((_p#1) + _mode);
	// if(_y_new < 0)exitWith{};
	_ctrl ctrlSetPositionY _y_new;
	_ctrl ctrlCommit 0;
	systemchat str [((_p#1) + _mode)];
}forEach [100,101];
*/