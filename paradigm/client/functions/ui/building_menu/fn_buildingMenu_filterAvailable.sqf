/*
	File: fn_buildingMenu_filterAvailable.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Filters available buildings.

	Parameter(s):
		_buildables - List of buildings [ARRAY, defaults to [] (empty array)]
		_show - If we keep unavailable buildings or not [BOOLEAN, defaults to false]

	Returns:
		Filtered buildings list [ARRAY]

	Example(s): none
*/

params [
	["_buildables", [], [[]]],
	["_show", false, [false]]
];

if (_show) then {
	_buildables
} else {
	_buildables select {
		_x params [
			"_config",
			"_categories",
			"_name",
			"_icon",
			"_class"
		];
		private _conditionsPre = getArray (_config >> "conditions");
		private _conditions = _conditionsPre apply { [_x#0, (call compile (_x#1))] };
		private _canBuild = !(false in (_conditions apply { _x#1 }));
		_canBuild
	};
};