/*
	File: fn_buildingMenu_onBuild.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Handles the "Build" button action.
	
	Parameter(s):
		_isUser - Was the function triggered by the user or by script [BOOLEAN, defaults to FALSE]
	
	Returns: nothing

	Example(s): none
*/

params [
	["_isUser", false, [false]]
];

private _classname = localNamespace getVariable ["#para_c_BuildingMenu_class", ""];
if !(_classname isEqualTo '') then {
	private _buildables = localNamespace getVariable ["#para_c_buildingmenu_buildables", []];
	private _building = (_buildables select {
		_x params [
			"_config",
			"_categories",
			"_name",
			"_icon",
			"_class"
		];
		_class isEqualTo _classname
	})#0;

	_building params [
		"_config",
		"_categories",
		"_name",
		"_icon",
		"_class"
	];

	private _history = localNamespace getVariable ['#para_c_BuidlingMenu_history', []];
	if (_building in _history) then {
		private _index = _history find _building;
		if !(_index isEqualTo -1) then {
			_history deleteAt _index;
			_history pushBack _building;
		};
	} else {
		if (count _history >= 6) then {
			reverse _history;
			_history = _history select [0,5];
			reverse _history;
			_history pushBack _building;
		} else {
			_history pushBack _building;
		};
	};

	_history pushBackUnique _building;
	localNamespace setVariable ['#para_c_BuidlingMenu_history', _history];
	closeDialog 2;
	[_classname, [[_config], para_c_fnc_building_check]] spawn para_c_fnc_place_object;
};
