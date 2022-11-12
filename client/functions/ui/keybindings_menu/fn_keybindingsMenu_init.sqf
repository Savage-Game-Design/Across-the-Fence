/*
	File: fn_keybindingsMenu_init.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Automatically adds a button to the escape menu which opens the keybindings menu. Called from CfgFunctions with postInit = 1.
	
	Parameter(s):
		None
	
	Returns:
		Nothing
	
	Example(s):
		[] call para_c_fnc_keybindingsMenu_init;
*/
// #include "..\..\..\configs\ui\ui_def_base.inc"

// [missionNamespace, "OnGameInterrupt", {
// 	params ["_display"];

// 	// Keybindings
// 	_newBtn = _display ctrlCreate ["para_RscButtonMenu", -1];
// 	_newBtn ctrlSetPosition [safeZoneX + UIW(1), safeZoneY + UIH(1), UIW(15), UIH(1)];
// 	_newBtn ctrlCommit 0;
// 	_newBtn ctrlSetText "GAMEMODE KEYBINDINGS";
// 	_newBtn ctrlAddEventHandler ["ButtonClick",{
// 		params ["_btn"];
// 		_escDisplay = ctrlParent _btn;
// 		_escDisplay createDisplay "para_RscDisplayKeybindingsMenu";
// 	}];

// 	// Todo: Eh, probably move things away from there?
// 	_optsBtn = _display ctrlCreate ["para_RscButtonMenu", -1];
// 	_optsBtn ctrlSetPosition [safeZoneX + UIW(1), safeZoneY + UIH(2.1), UIW(15), UIH(1)];
// 	_optsBtn ctrlCommit 0;
// 	_optsBtn ctrlSetText "GAMEMODE OPTIONS";
// 	_optsBtn ctrlAddEventHandler ["ButtonClick",{
// 		params ["_btn"];
// 		_escDisplay = ctrlParent _btn;
// 		[_escDisplay] call para_c_fnc_optionsMenu_open;
// 	}];

// 	_bugBtn = _display ctrlCreate ["para_RscButtonMenu", -1];
// 	_bugBtn ctrlSetPosition [safeZoneX + UIW(1), safeZoneY + UIH(3.2), UIW(15), UIH(1)];
// 	_bugBtn ctrlCommit 0;
// 	_bugBtn ctrlSetText "BUG REPOR";
// 	_bugBtn ctrlAddEventHandler ["ButtonClick",{
// 		params ["_btn"];
// 		_escDisplay = ctrlParent _btn;
// 		[_escDisplay] call para_c_fnc_bugReport_init;
// 	}];
// }] call BIS_fnc_addScriptedEventHandler;


// call para_c_fnc_optionsMenu_open: