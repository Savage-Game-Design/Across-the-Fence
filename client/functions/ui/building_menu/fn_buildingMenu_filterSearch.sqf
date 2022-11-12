/*
	File: fn_buildingMenu_filterSearch.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Filters buildings with a search query.

	Parameter(s):
		_buildables - List of buildings [ARRAY, defaults to [] (empty array)]
		_query - Whatever you are searching [STRING, defaults to "" (empty string)]

	Returns:
		Filtered buildings list [ARRAY]

	Example(s): none
*/

params [
	["_buildables", [], [[]]],
	["_query", "", [""]]
];

private _name = "";
private _localizedName = "";
private _filtered = _buildables select {
	_x params [
		"_config",
		"_categories",
		"_name",
		"_icon",
		"_class"
	];

	(toLower _query) in (toLower _name);
};
_filtered