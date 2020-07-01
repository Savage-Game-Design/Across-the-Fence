
params["_ctrl_gridCur","_grid_size_x","_grid_size_y","_pos_toCheck","_tiles_toCheck"];
//get grid Data from currently active "Grid ctrl"
private _grid_data = missionNameSpace getVariable [format["vn_an_inv_grid_%1",(ctrlIDC _ctrl_gridCur)],[]];
//ToDo: Reload previous tiles_usage
private _tile_list = [];
{
	_x params ["_px","_py"];
	private _gridPos = [_px,_py];
	//Check if pos is within grid
	if	(
				_px > (_grid_size_x-1)
			||	_px < 0
			||	_py > (_grid_size_y-1)
			||	_py < 0
			||	_gridPos in _tiles_toCheck		//if something is already placed there
		)exitWith{_tile_list = [];};
	
	private _tile_idc = _grid_data#_py#_px#2;
	_tile_list pushback [_tile_idc,_gridPos];
}forEach _pos_toCheck;

_tile_list