mf_an_fnc_getConfig =
{
	_weapon = configFile >> "CfgWeapons" >> _x;
	if (isClass _weapon) exitWith
	{
		_weapon
	};
	_mag = configFile >> "CfgMagazines" >> _x;
	if (isClass _mag) exitWith
	{
		_mag
	};
};

mf_an_rarity = [
	["Rare", [0,1,1]],
	["Junk", [0,0,0]]
];

[] spawn
{
	disableSerialization;


	_weapons = weapons player;
	_weapons append magazines player;


	_display = findDisplay 46 createDisplay "RscDisplayEmpty";

	_menu = _display ctrlCreate ["RscControlsGroupNoHScrollbars", 5641];
	_menu ctrlSetPosition [0, 0, 0, 0];
	_menu ctrlSetBackgroundColor [0,0,0,1];
	_menu ctrlCommit 0;

	_grid_size = 0.125;
	_grid_x = 0;
	_grid_y = 0;
	_grid_rows = 8;
	_row_counter = 0;

	{
		_ctrlButton = _display ctrlCreate ["RscStructuredText", -1, _menu];
		_ctrlButton ctrlSetPosition [_grid_x, _grid_y, _grid_size, _grid_size];
		_ctrlButton ctrlSetBackgroundColor [0,1,1,0.5];
		_ctrlButton ctrlCommit 0;
		_text = text getText(_x call mf_an_fnc_getConfig >> "displayName");
		_text setAttributes ["align","center", "font","VeteranTypewriter", "size","0.5"];
		_image = image getText(_x call mf_an_fnc_getConfig >> "picture");
		_image setAttributes ["align", "center", "size","2"];
		_txt1 = text "left";
		_txt1 setAttributes ["align", "left", "font","VeteranTypewriter", "size","0.25"];
		_txt2 = text "right";
		_txt2 setAttributes ["align", "right", "font","VeteranTypewriter", "size","0.25"];
		_structuredText = composeText [_image, lineBreak, _txt1, _txt2];

		_ctrlButton ctrlSetStructuredText _structuredText;
		_ctrlButton ctrlAddEventHandler ["ButtonClick",
		{
			params ["_ctrl"];
			_display = ctrlParent _ctrl;
			_text = ctrlText (_display displayCtrl IDD_EDIT_BOX);
			if (_text == "") then { _text = "EMPTY" };
			hint _text;
			_display closeDisplay 1;
		}];

		_ctrlButton ctrlAddEventHandler ["MouseEnter",
		{
			params ["_control"];
			_control ctrlSetBackgroundColor [0,0,0,1];
		}];

		_ctrlButton ctrlAddEventHandler ["MouseExit",
		{
			params ["_control"];
			_control ctrlSetBackgroundColor [0,0,0,0.5];
		}];

		_grid_x = _grid_x + _grid_size;
		if (_row_counter >= _grid_rows) then
		{
			_grid_x = 0;
			_row_counter = 0;
			_grid_y = _grid_y + _grid_size;
		};
		_row_counter = _row_counter + 1;
	} forEach _weapons;



	_menu ctrlSetPosition [0, 0, 1, 1];
	_menu ctrlCommit 0.1;
};
