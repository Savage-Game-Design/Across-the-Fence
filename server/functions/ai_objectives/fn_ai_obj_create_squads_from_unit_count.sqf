/*
    File: fn_ai_create_squads_from_unit_count.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Takes a number of units and a squad size, and attempts to create X squads, where X is optimal
		for the total number of units, and the desired squad size.
    
    Parameter(s):
        _unitCount - Number of units to spawn [NUMBER]
		_squadSize - Maximum squad size
    
    Returns:
        None
    
    Example(s):
        [32, 4, { params ["_squadSize"]; Squad creation code here}] call para_s_fnc_ai_obj_create_squads_from_unit_count;
*/

params ["_unitCount", "_squadSize", "_fnc_createSquad"];

while {_unitCount > 0} do {
	//If we've got to make 2 more groups, but can't fully fill them - divide the troops more evenly.
	//Helps avoid having 1 small squad and 1 large squad.
	if (_squadSize < _unitCount && _unitCount < 2 * _squadSize) exitWith {
		private _squadSize1 = floor (_unitCount / 2);
		[_squadSize1] call _fnc_createSquad;
		private _squadSize2 = ceil (_unitCount / 2);
		[_squadSize2] call _fnc_createSquad;
	};

	private _squadSize = _squadSize min _unitCount max 0;
	//Always subtract at least 1 - then we guarantee that our while loop will end.
	_unitCount = _unitCount - (_squadSize max 1);
	[_squadSize] call _fnc_createSquad;
};