/*
	Move the ctrl up and down.
	ToDo: Alot...

*/


#include "\vn\ui_f_vietnam_c\ui\vn_uiDefines.inc"

params ["_displayorcontrol", "_scroll"];
_mode = if(_scroll < 0)then{UIY(1)}else{UIY((-1))};
_disp = uinamespace getvariable ["vn_an_inventory", DisplayNull];


_ctrlGrp = _disp displayCtrl 1000;
_p = ctrlPosition _ctrlGrp;
_y_new = ((_p#1) + _mode);
_ctrlGrp ctrlSetPositionY _y_new;
_ctrlGrp ctrlCommit 0.05;
if(_y_new > 0)exitWith{};