/*
	File: paradigm.hpp
	Author:  Savage Game Design
	Public: No

	Description:
		Indexes all categories that are present in the passed building list.

	Parameter(s):
		_buildables - List of buildings [ARRAY, defaults to [] (empty array)]

	Returns:
		List of buildings [ARRAY]

	Example(s): none
*/

params [
	["_buildables", [], [[]]]
];

private _mission = getText (missionConfigFile >> "CfgParadigm" >> "missionSuffix");
private _suffix = ["_" + _mission, ""] select (_mission isEqualTo "");

private _baseCategories = [
	["all", _buildables],
	["recent", (localNamespace getVariable ['#para_c_BuidlingMenu_history', []])],
	["favorites", (profileNamespace getVariable ['#para_c_BuidlingMenu_favorites' + _suffix, []])]
];

private _allBuildables = localNamespace getVariable ["#para_c_buildingmenu_buildables", _buildables];

// Fix favorites
private _fixedFavorites = [];
private _index = -1;
private _class = "";
{
	_class = _x;
	_index = _allBuildables findIf { (toLower (_x#4)) isEqualTo (toLower _class) };
	if (_index isNotEqualTo -1) then {
		_fixedFavorites pushBack (_allBuildables#_index);
	};
} forEach (_baseCategories#2#1);
_baseCategories set [2, ["favorites", _fixedFavorites]];

//Cache this value, to save us a few ms. Don't need to recalculate, as config doesn't change during the game.
if (isNil "para_c_buildingMenu_categories") then
{
	private _categories = [];
	{
		{
			_categories pushBackUnique _x;
		} forEach (_x select 1);
	} forEach _allBuildables;
	para_c_buildingMenu_categories = _categories;

	{
		missionNamespace setVariable [format ["para_c_buildingMenu_category_%1", _x], _forEachIndex];
	} forEach _categories;
};

//Cache this value, to save us a few ms. Don't need to recalculate, as config doesn't change during the game.
if (isNil "para_c_buildingMenu_features") then
{
	private _features = [];
	{
		{
			_features pushBackUnique _x;
		} forEach (_x select 5);
	} forEach _allBuildables;
	para_c_buildingMenu_features = _features;

	{
		missionNamespace setVariable [format ["para_c_buildingMenu_features_%1", _x], _forEachIndex];
	} forEach _features;
};

private _categories = para_c_buildingMenu_categories;
private _features = para_c_buildingMenu_features;
//This starts with an initial empty array, which is where "uncategorized" variables go
private _buildingsByCategory = [[]];
private _buildingsByFeature = [];
private _uncategorisedBuildings = [];

{
	_buildingsByCategory pushBack [];
} forEach _categories;

{
	_buildingsByFeature pushBack [];
} forEach _features;

{
	private _buildable = _x;
	_buildable params [
		"_config",
		"_bCategories",
		"_name",
		"_icon",
		"_class",
		["_bFeatures", []]
	];

	{
		//Add 1 here, so if nothing is found, it goes into the first array, which will be our uncategorised array
		//This is performance hack, to avoid any if statements.
		_buildingsByCategory select ((_categories find _x) + 1) pushBack _buildable;
	} forEach _bCategories;

	{
		//Add 1 here, so if nothing is found, it goes into the default category.
		_buildingsByFeature select (_features find _x) pushBack _buildable;
	} forEach _bFeatures;
} forEach _buildables;

//Add the tag for our initial, empty array.
//This has to be done here, rather than above, for the '+1' hack to work properly.
//If we put it in above, categories end up incorrectly shifted by 1.
_categories = ["uncategorized"] + _categories;

private _featureCategories = [];
private _customCategories = [];

{
	_featureCategories pushBack [_x, (_buildingsByFeature select _forEachIndex)];
} forEach _features;

{
	_customCategories pushBack [_x, (_buildingsByCategory select _forEachIndex)];
} forEach _categories;

[_baseCategories, _featureCategories, _customCategories]
