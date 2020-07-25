

params["_inv_size_x","_gridSize_y"];

for "_idc_mod" from 0 to ((_gridSize_y-1)*10) step 10 do
{
	for "_idc" from 0 to (_inv_size_x-1) do
	{
		private _ctrl = _ctrl_grid controlsGroupCtrl (_idc_mod + _idc);
		_ctrl ctrlSetTextColor [0,0,0,1];
		_ctrl ctrlCommit 0;
	};
};