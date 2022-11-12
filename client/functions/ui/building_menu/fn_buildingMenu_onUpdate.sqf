/*
	File: paradigm.hpp
	Author:  Savage Game Design
	Public: No

	Description:
		Handles the UI update event.

	Parameter(s):
		_builds - Unused, saved BuildingsList state [ARRAY]
		_statequery - Unused, saved Query state [STRING]
		_stateavail - Unused, saved Available CB state [UNKOWN]
		_statecat - saved SelectedCategory state [NUMBER]
		_statepage - Unused, saved Page state [NUMBER]
		_statebuilding - Unused, saved SelectedBuildingIndex state [UNKONUMBERWN]

	Returns: nothing

	Example(s): none
*/

params [
	"_builds",
	"_statequery",
	"_stateavail",
	"_statecat",
	"_statepage",
	"_statebuilding"
];

// Just get all of those controls
private _searchControl = uiNamespace getVariable ["#para_c_BuildingMenu_Search", controlNull];
private _availableControl = uiNamespace getVariable ["#para_c_BuildingMenu_Available", controlNull];
private _categoryControl = uiNamespace getVariable ["#para_c_BuildingMenu_Select", controlNull];
private _tableControl = uiNamespace getVariable ["#para_c_BuildingMenu_Table", controlNull];
private _btn = uiNamespace getVariable ['#para_c_BuildingMenu_Build', controlNull];
private _favbtn = uiNamespace getVariable ['#para_c_BuildingMenu_FavBtn', controlNull];
private _favico = uiNamespace getVariable ['#para_c_BuildingMenu_FavIcon', controlNull];

// Removing EHs so we can do our stuff in peace
_btn ctrlEnable false;
_availableControl ctrlRemoveAllEventHandlers "CheckedChanged";
_categoryControl ctrlRemoveAllEventHandlers "LBSelChanged";
_tableControl ctrlRemoveAllEventHandlers "LBSelChanged";
_favbtn ctrlRemoveAllEventHandlers "ButtonClick";
_favbtn ctrlRemoveAllEventHandlers "MouseEnter";
_favbtn ctrlRemoveAllEventHandlers "MouseExit";

private _buildables = localNamespace getVariable ["#para_c_buildingmenu_buildables", []];

// Applying search filters
private _searchQuery = ctrlText _searchControl;
private _searched = [_buildables, _searchQuery] call para_c_fnc_buildingMenu_filterSearch;

// Applying availability filters
private _availableState = cbChecked _availableControl;
private _available = [_searched, _availableState] call para_c_fnc_buildingMenu_filterAvailable;

// Applying categorization filters
// Array of arrays of categories, so we can sort each group independently.
private _categoryGroups = [_available] call para_c_fnc_buildingMenu_indexcategories;
private _localizedCategoryGroups = _categoryGroups apply {
	_x apply {
		[
			_x#0,
			_x#1,
			(format ["STR_vn_mf_buildingMenu_category_%1", _x # 0]) call para_c_fnc_localize,
			_x#2
		]
	}
};

{
	_x sort true;
} forEach (_localizedCategoryGroups select [1, count _localizedCategoryGroups]);

//Flatten into a list of categories
private _categories = [];
{ _categories append _x } forEach _localizedCategoryGroups;

// Saving the old index before clearing the LB so we can reselect it later
private _categorySel = (lbCurSel _categoryControl) max 0;

// Check if an index was saved in the state previously
// For whatever reason it sometimes becomes a bool and I'm to lazy to locate the issue
if (!(isnil "_statecat") && { _statecat isEqualType 0 }) then {
	_categorySel = _statecat;
};

// Populating the category box
lbClear _categoryControl;
private _index = -1;

private _counts = _categories apply {
	private _category = _x#0;
	if (_category isEqualTo "all") then {
		continueWith (count _buildables);
	};
	private _count = { _category in ((_x#1) + (_x#5)) } count _buildables;
	_count
};

private _extra = "";
private _bCnt = -1;
private _tCnt = -1;
{
	_x params ["_name", "_buildables", "_localized", "_total"];
	_bCnt = count _buildables;
	_tCnt = _counts#_forEachIndex;
	_extra = [" / " + (str _tCnt), ""] select (_name in ["recent", "favorites"] || (_searchQuery isEqualTo "" && _availableState));
	_index = _categoryControl lbAdd format ["%1 (%2%3)", _localized, _bCnt, _extra];
	_categoryControl lbSetData [_index, _name];
} forEach _categories;
_categoryControl lbSetCurSel _categorySel;

// Selecting our buildings
private _category = _categories # _categorySel # 0;
private _categorized = _categories select (_categories findIf {_x # 0 == _category}) select 1;

// Setting some variables taht we'll use later
private _count = count _categorized;
private _page = localNamespace getVariable ["#para_c_buildingmenu_page", 0];
private _firstBuildingIndex = (6 * _page) min (_count - 1);
private _lastBuildingIndex = (_firstBuildingIndex + 5) min (_count - 1);
private _shown = _categorized select [_firstBuildingIndex, 6];

localNamespace setVariable ["#para_c_buildingmenu_currList", _categorized];

// And now let's populate the table
ctClear _tableControl;
private _row = 0;
private _building = [];

private _data = localNamespace getVariable ["#para_c_BuildingMenu_class", ""];
private _indexSel = -1;

// But first, we need to update the page display so it shows the correct amount
private _max = ceil ((count _categorized) / 6) - 1;
private _pageCtrl = uiNamespace getVariable ["#para_c_BuildingMenu_Page", controlNull];
_pageCtrl ctrlSetText format ["%1 %2 / %3", localize "STR_vn_mf_buildingMenu_ui_pageAbrev", (_page max 0) + 1, ((_max max 0) + 1) max 1];

// If ther are more than 0 buildings to show
if !((count _shown) isEqualTo 0) then {
	for "_i" from _firstBuildingIndex max 0 to _lastBuildingIndex do {
		_row = ctAddRow _tableControl;
		_row params ["_index", "_controls"];
		_controls params ["_backgroundCtrl", "_pictureCtrl", "_nameCtrl"];
		_building = _categorized#_i;
		_building params [
			"_config",
			"_categories",
			"_name",
			"_icon",
			"_class",
			"_features"
		];
		if (_class isEqualTo _data) then { _indexSel = _index };
		_tableControl ctSetData [_index, _class];
		_pictureCtrl ctrlSetText ([_icon, "\vn\ui_f_vietnam\ui\debrief\sticky.paa"] select (_icon isEqualTo ""));
		_nameCtrl ctrlSetStructuredText (parseText format ["<t color='#000000'>%1</t>", _name]);
	};

	_tableControl ctSetCurSel _indexSel;

	if (_page < 0) then {
		[true, 0, false] call para_c_fnc_buildingMenu_onPageChange;
	};
	if ((_page max 0) > (_max max 0)) then {
		[true, (_max max 0), false] call para_c_fnc_buildingMenu_onPageChange;
	};
} else {
	// If there are none, go back to page 0
	// TODO: Maybe display some text that says "No building matching your query"?
	if !(_page isEqualTo 0) then {
		[true, 0, false] call para_c_fnc_buildingMenu_onPageChange;
	};
};

// Checks if a building is selected or not
if !(_data isEqualTo "") then {
	private _config = missionConfigFile >> "gamemode" >> "buildables" >> _data;
	private _texture = [getText (configFile >> "CfgVehicles" >> _data >> "editorPreview"), (getText (_x >> "picture"))] select !((getText (_config >> "picture")) isEqualTo "");

	private _categories = (getArray (_config >> "categories")) apply {
		private _loc = localize (format ["STR_vn_mf_buildingMenu_category_%1", _x]);
		if (_loc isEqualTo "") then { _loc = _x };
		_loc
	};

	private _title = uiNamespace getVariable ['#para_c_BuildingMenu_Title', controlNull];
	private _picture = uiNamespace getVariable ['#para_c_BuildingMenu_Picture', controlNull];
	private _cost = uiNamespace getVariable ['#para_c_BuildingMenu_Cost', controlNull];

	private _text = format ["%1:<br/><t color='#323232' size='0.75'>%2</t>", "Categories", (_categories joinString ", ")];
	_text = _text + format ["<br/><br/>%1:<br/>", localize "STR_vn_mf_buildingMenu_conditions"];

	private _supplyCapacity = getNumber (_config >> "supply_capacity");
	private _supplyConsumptionPerHour = getNumber (_config >> "supply_consumption") * 3600;
	private _supplyType = getText (_config >> "resupply");
	private _supplyTypeName = localize (format ["STR_para_supply_%1", _supplyType]);

	private _conditionsPre = getArray (_config >> "conditions");
	
	// Variables
	private _pos = getPos player;
	private _conditions = _conditionsPre apply {[_x#0, (call compile (_x#1))] };

	_text = _text + (_conditions apply {
		_x params ["_name", "_checked"];
		format [
			"<t color='#%3' size='0.75'>- [%1] %2</t>",
			['  ', 'X'] select _checked,
			_name,
			['FF0000', '323232'] select _checked
		]
	} joinString "<br/>");

	private _costs = [
		[
			_supplyConsumptionPerHour toFixed 1,
			_supplyTypeName,
			localize "STR_vn_mf_buildingMenu_per_hour"
		],
		[
			str ceil _supplyCapacity,
			_supplyTypeName,
			localize "STR_vn_mf_buildingMenu_total_capacity"
		]
	] apply { format ["<t color='#323232' size='0.75'>- %1 %2 %3</t>", _x#0, _x#1, _x#2] };

	_text = _text + format [
		"<br/><br/>%1:<br/>%2",
		localize "STR_vn_mf_buildingMenu_ui_costs",
		_costs joinString "<br/>"
	];
	_cost ctrlSetStructuredText parseText _text;

	private _name = getText (_config >> "name");
	if (_name isEqualTo "") then {
		_name = getText (configFile >> "CfgVehicles" >> _data >> "displayName");
	} else {
		_name = _name call para_c_fnc_localize;
	};

	_title ctrlSetText (_name);
	if (_picture isEqualTo controlNull) then {
		_texture spawn {
			uiSleep diag_deltaTime;
			private _picture = uiNamespace getVariable ['#para_c_BuildingMenu_Picture', controlNull];
			_picture ctrlSetText ([_this, "\vn\ui_f_vietnam\ui\debrief\sticky.paa"] select (_this isEqualTo ""));
		};
	} else {
		_picture ctrlSetText ([_texture, "\vn\ui_f_vietnam\ui\debrief\sticky.paa"] select (_texture isEqualTo ""));
	};

	private _canBuild = !(false in (_conditions apply { _x#1 }));
	_btn ctrlEnable _canBuild;

	private _colors = [[0.8,0.8,0.8,1], [1,1,0,1]];

	private _mission = getText (missionConfigFile >> "CfgParadigm" >> "missionSuffix");
	private _suffix = ["_" + _mission, ""] select (_mission isEqualTo "");

	private _classname = localNamespace getVariable ["#para_c_BuildingMenu_class", ""];
	private _favorites = profileNamespace getVariable ['#para_c_BuidlingMenu_favorites' + _suffix, []];
	private _index = _favorites find _classname;
	private _isFavorite = !(_index isEqualTo -1);

	private _colors = [[0.5,0.5,0.5,1], [1,1,0,1]] select _isFavorite;
	_favico ctrlSetTextColor _colors;

	// Fav button action
	_favbtn ctrlAddEventHandler ["ButtonClick", {
		private _mission = getText (missionConfigFile >> "CfgParadigm" >> "missionSuffix");
		private _suffix = ["_" + _mission, ""] select (_mission isEqualTo "");

		private _classname = localNamespace getVariable ["#para_c_BuildingMenu_class", ""];
		private _favorites = profileNamespace getVariable ['#para_c_BuidlingMenu_favorites' + _suffix, []];
		private _index = _favorites find _classname;
		if (_index isEqualTo -1) then {
			_favorites pushBack _classname;
		} else {
			_favorites deleteAt _index;
		};

		profileNamespace setVariable ['#para_c_BuidlingMenu_favorites' + _suffix, _favorites];
		saveProfileNamespace;
		call para_c_fnc_buildingMenu_onUpdate;
	}];

	// Fav button color changes
	_favbtn ctrlAddEventHandler ["MouseEnter", {
		private _mission = getText (missionConfigFile >> "CfgParadigm" >> "missionSuffix");
		private _suffix = ["_" + _mission, ""] select (_mission isEqualTo "");

		private _favico = uiNamespace getVariable ['#para_c_BuildingMenu_FavIcon', controlNull];
		private _colors = [[0.8,0.8,0.8,1], [1,1,0,1]];

		private _classname = localNamespace getVariable ["#para_c_BuildingMenu_class", ""];
		private _favorites = profileNamespace getVariable ['#para_c_BuidlingMenu_favorites' + _suffix, []];
		private _index = _favorites find _classname;
		private _isFavorite = !(_index isEqualTo -1);

		private _colors = [[0.8,0.8,0.8,1], [1,1,0,1]] select !_isFavorite;
		_favico ctrlSetTextColor _colors;
	}];
	_favbtn ctrlAddEventHandler ["MouseExit", {
		private _mission = getText (missionConfigFile >> "CfgParadigm" >> "missionSuffix");
		private _suffix = ["_" + _mission, ""] select (_mission isEqualTo "");

		private _favico = uiNamespace getVariable ['#para_c_BuildingMenu_FavIcon', controlNull];

		private _classname = localNamespace getVariable ["#para_c_BuildingMenu_class", ""];
		private _favorites = profileNamespace getVariable ['#para_c_BuidlingMenu_favorites' + _suffix, []];
		private _index = _favorites find _classname;
		private _isFavorite = !(_index isEqualTo -1);

		private _colors = [[0.8,0.8,0.8,1], [1,1,0,1]] select _isFavorite;
		_favico ctrlSetTextColor _colors;
	}];
};

// Saving the state so we can reuse it later
private _state = [_buildables, _searchQuery, _availableState, _categorySel, _page, _data];
localNamespace setVariable ["#para_c_buildingMenu_state", _state];

// Re-adding EHs
_availableControl ctrlAddEventHandler ["CheckedChanged", { call para_c_fnc_buildingMenu_onCheckedChanged }];
_categoryControl ctrlAddEventHandler ["LBSelChanged", { call para_c_fnc_buildingMenu_onCategoryChange }];
_tableControl ctrlAddEventHandler ["LBSelChanged", { [true, _this#1] call para_c_fnc_buildingMenu_onSelect }];