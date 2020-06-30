/*

	TODO: Split to two functions: REMOVE ITEM && REMOVE FROM GRID

*/

disableSerialization;

params ["_ctrl", ["_btn",1,[0]]];//, "_xPos", "_yPos", "_btn_shift", "_btn_ctrl", "_btn_alt"];
// _xPos,_yPos = pos relative to GridPos
if(_btn != 1)exitWith{};

//get the used slots from that Item
(_ctrl getVariable ["item_data",[]]) params ["_pos_data","_usedSlots_item"];
_ctrl_grid = ctrlParentControlsGroup _ctrl;
_ctrl_grid_idc = ctrlIDC _ctrl_grid;
// systemchat str ["FNC_TEST: ", _ctrl_grid," - _usedSlots = ",_usedSlots];

//get Grid for used IDC
private _grid = missionNameSpace getVariable [format["vn_an_inv_grid_%1",_ctrl_grid_idc],[]];
//_grid == [y,x,IDC]

//get used slots from grid
_varName_activeCtrl = format["vn_an_inv_tileUsage_%1",_ctrl_grid_idc];
_grid_usedSlots = missionNameSpace getVariable [_varName_activeCtrl,[]];

while{!(_usedSlots_item isEqualTo [])}do
{
	_usedSlots_item#0 params["_p_x","_p_y"];
	
	_idc = _grid#_p_y#_p_x#2;
	private _ctrl_grid = _ctrl_grid controlsGroupCtrl _idc;
	_ctrl_grid ctrlSetTextColor [0,0,0,1];
	_ctrl_grid ctrlCommit 0;
	
	_index = _grid_usedSlots findIf {_x isEqualTo [_p_x,_p_y]};
	if(_index >= 0)then
	{
		_grid_usedSlots deleteAt _index;
		_usedSlots_item deleteAt 0;
	};
};

missionNameSpace setVariable [_varName_activeCtrl,_grid_usedSlots];
//////////// WARNING:
//NOT SPAWNING the ctrlDelete (executing in the same frame(?)) -> !! ARMA CRASH !!
_ctrl spawn {ctrlDelete _this;};

// systemchat str ["_usedSlots_item: ",_usedSlots_item];
// systemchat str ["_grid_usedSlots: ",_grid_usedSlots];