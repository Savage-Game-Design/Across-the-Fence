/*
	File: fn_optionsMenu_open.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Opens the OptionsMenu.
	
	Parameter(s):
		_display - Display [DISPLAY, defaults to displayNull]

	Returns: nothing

	Example(s):
		call para_c_fnc_optionsMenu_open:
*/

#include "..\..\..\configs\ui\ui_def_base.inc"

params [["_display", displayNull, [displayNull]]];

if (_display isEqualTo displayNull) then {
	createDialog "para_optionsMenu";
} else {
	_display createDisplay "para_optionsMenu";
};

private _ctrlTable = uiNamespace getVariable "Table";
private _display = ctrlParent _ctrlTable;

private _config = missionConfigFile >> "para_CfgOptions";
private _configs = "true" configClasses _config;

private _controls = [];
{
	private _ctrlGroup = _display ctrlCreate ["RscControlsGroup", -1, _ctrlTable];
	_ctrlGroup ctrlSetPosition [0, (UIH(1.1)) * _forEachIndex, UIW(39.2), UIH(1.2)];
	_ctrlGroup ctrlCommit 0;

	private _ctrlBackground = _display ctrlCreate ["IGUIBack", -1, _ctrlGroup];
	_ctrlBackground ctrlSetPosition [0, 0, UIW(39.2), UIH(1)];
	private _backgroundColor = [[0,0,0,0], [0,0,0,0.1]]#(_forEachIndex % 2);
	_ctrlBackground ctrlSetBackgroundColor _backgroundColor;
	_ctrlBackground ctrlCommit 0;

	private _ctrlName = _display ctrlCreate ["RscTextNoShadowLeft", -1, _ctrlGroup];
	_ctrlName ctrlSetPosition [0, 0, UIW(20), UIH(1)];
	_ctrlName ctrlCommit 0;

	private _configName = configName _x;
	private _name = getText (_x >> "name");
	private _tooltip = getText (_x >> "tooltip");
	private _type = getText (_x >> "type");
	private _default = getNumber (_x >> "default");
	
	private _value = [_configName] call para_c_fnc_optionsMenu_getValue;

	_ctrlName ctrlSetTooltip _tooltip;
	_ctrlName ctrlSetText _name;

	switch (toLower _type) do {
		case "checkbox": {
			private _ctrlCheckbox = _display ctrlCreate ["RscCheckbox", -1, _ctrlGroup];
			_ctrlCheckbox ctrlSetPosition [UIW(32.7), 0, UIW(1), UIH(1)];

			_ctrlCheckbox cbSetChecked _value;

			_ctrlCheckbox ctrlCommit 0;
			_ctrlCheckbox ctrlAddEventHandler ["CheckedChanged", para_c_fnc_optionsMenu_onCheckedChanged];
			_ctrlCheckbox setVariable ["#data", [_name, _configName, _type, _default, _value, _ctrlName, _ctrlBackground, _ctrlGroup]];
			_controls pushBack _ctrlCheckbox;
			#define PARSE_BOOL(N) ([false,true] select N)
			_ctrlCheckbox ctrlSetTooltip format ["Default: %1\nCurrent: %2", PARSE_BOOL(_default), _value];
			#undef PARSE_BOOL
		};
		case "slider": {
			private _ctrlSlider = _display ctrlCreate ["RscXSliderH", -1, _ctrlGroup];
			_ctrlSlider ctrlSetPosition [UIW(28.2), UIH(0.15), UIW(10), UIH(0.7)];

			private _speed = getNumber (_x >> "step");
			_ctrlSlider sliderSetRange (getArray (_x >> "range"));
			_ctrlSlider sliderSetSpeed [_speed, _speed];
			_ctrlSlider sliderSetPosition _value;

			_ctrlSlider ctrlCommit 0;

			private _ctrlValue = _display ctrlCreate ["RscTextNoShadowRight", -1, _ctrlGroup];
			_ctrlValue ctrlSetPosition [UIW(22.4), 0, UIW(5), UIH(1)];
			_ctrlValue ctrlCommit 0;

			_ctrlSlider ctrlAddEventHandler ["SliderPosChanged", para_c_fnc_optionsMenu_onSliderPosChanged];
			_ctrlSlider setVariable ["#data", [_name, _configName, _type, _default, _value, _ctrlName, _ctrlBackground, _ctrlGroup, _ctrlValue]];
			_controls pushBack _ctrlSlider;
			_ctrlSlider ctrlSetTooltip format ["Default: %1\nCurrent: %2", _default, _value];
		};

		case "combobox": {
			private _ctrlCombo = _display ctrlCreate ["RscCombo", -1, _ctrlGroup];
			_ctrlCombo ctrlSetPosition [UIW(28.2), UIH(0), UIW(10), UIH(1)];

			private _values = getArray (_x >> "values");
			private _index = -1;
			{
				// _x params ["_name", "_data"];
				_index = _ctrlCombo lbAdd _x;
				// _ctrlCombo lbSetData [_index, _data];
			} forEach _values;
			_ctrlCombo lbSetCurSel _value;

			_ctrlCombo ctrlCommit 0;

			_ctrlCombo ctrlAddEventHandler ["LBSelChanged", para_c_fnc_optionsMenu_onLBSelChanged];
			_ctrlCombo setVariable ["#data", [_name, _configName, _type, _default, _value, _ctrlName, _ctrlBackground, _ctrlGroup, _values]];
			_controls pushBack _ctrlCombo;
			_ctrlCombo ctrlSetTooltip format ["Default: %1\nCurrent: %2", _values#_default, _values#_value];
		};
	};
} forEach _configs;

_display setVariable ["#controls", _controls];
