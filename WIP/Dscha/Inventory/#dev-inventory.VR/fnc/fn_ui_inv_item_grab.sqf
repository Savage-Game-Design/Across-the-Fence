disableSerialization;
	
	params ["_ctrl", "_btn", "_xPos", "_yPos", "_btn_shift", "_btn_ctrl", "_btn_alt"];
	(_ctrl getVariable ["item_data",[]]) params ["_pos_data","_usedSlots_item","_item_class"];
	(ctrlPosition _ctrl) params["_p_x","_p_y","_p_w","_p_h"];
	missionNameSpace setVariable ["vn_an_inv_itemActive",_item_class];
	
	getMousePosition params["_mPos_x","_mPos_y"];
	private _disp = uinamespace getvariable ["vn_an_inventory", DisplayNull];
	private _ctrlGrp_item = _disp ctrlCreate ["inv_icon",32123];
	
	_offset_x = _p_x - _xPos;
	_offset_y = _p_y - _yPos;
	// _ctrlGrp_item ctrlSetPosition[_mPos_x+_offset_x,_mPos_y+_offset_y, _p_w, _p_h];
	_ctrlGrp_item ctrlSetPosition[0,0, _p_w, _p_h];
	_ctrlGrp_item ctrlCommit 0;
	_ctrlGrp_item ctrlAddEventhandler ["MouseButtonUp","_this call vn_an_DEV_MouseEH"];
	
	_ctrl_img_old = _ctrl controlsGroupCtrl 200;
	{
		private _ctrl_sub = _ctrlGrp_item controlsGroupCtrl _x;
		_ctrl_sub ctrlSetposition [0,0,_p_w,_p_h];
		_ctrl_sub ctrlCommit 0;
		if(_x == 200)then
		{
			_ctrl_sub ctrlSetText (ctrlText _ctrl_img_old);
		};
	}forEach[100,200];
	
	//hide old one
	[_ctrl] call vn_an_fnc_ui_inv_item_remove_DEV;
	
	
	//DEV DEV DEV
	[_ctrlGrp_item,_offset_x,_offset_y]spawn
	{
		params["_ctrl","_offset_x","_offset_y"];
		
		
		while{!isNull _ctrl}do
		{
			getMousePosition params["_mPos_x","_mPos_y"];
			_ctrl ctrlSetPositionX (_mPos_x-0.001); //(_mPos_x+_offset_x);
			_ctrl ctrlSetPositionY (_mPos_y-0.001); //(_mPos_y+_offset_y);
			_ctrl ctrlCommit 0;
		};
		ctrlDelete _ctrl;
	};