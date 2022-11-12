/*
	File: fn_ui_initEscapeMenu.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Automatically adds buttosn to the escape menu which opens the keybindings menu. Called from CfgFunctions with postInit = 1.
	
	Parameter(s): none
	
	Returns: nothing
	
	Example(s): none
*/

#include "..\..\configs\ui\ui_def_base.inc"

[missionNamespace, "OnGameInterrupt", {
	params ["_display"];

	// Keybindings
	_newBtn = _display ctrlCreate ["para_RscButtonMenu", -1];
	_newBtn ctrlSetPosition [safeZoneX + UIW(1), safeZoneY + UIH(1), UIW(15), UIH(1)];
	_newBtn ctrlCommit 0;
	_newBtn ctrlSetText "GAMEMODE KEYBINDINGS";
	_newBtn ctrlAddEventHandler ["ButtonClick",{
		params ["_btn"];
		_escDisplay = ctrlParent _btn;
		_escDisplay createDisplay "para_RscDisplayKeybindingsMenu";
	}];

    // Options
	[] call para_c_fnc_optionsMenu_init;
	_optsBtn = _display ctrlCreate ["para_RscButtonMenu", -1];
	_optsBtn ctrlSetPosition [safeZoneX + UIW(1), safeZoneY + UIH(2.1), UIW(15), UIH(1)];
	_optsBtn ctrlCommit 0;
	_optsBtn ctrlSetText "GAMEMODE OPTIONS";
	_optsBtn ctrlAddEventHandler ["ButtonClick",{
		params ["_btn"];
		_escDisplay = ctrlParent _btn;
		[_escDisplay] call para_c_fnc_optionsMenu_open;
	}];

	_startBtn = _display ctrlCreate ["para_RscButtonMenu", -1];
	_startBtn ctrlSetPosition [safeZoneX + UIW(1), safeZoneY + UIH(3.2), UIW(15), UIH(1)];
	_startBtn ctrlCommit 0;
	_startBtn ctrlSetText "WELCOME MENU";
	_startBtn ctrlAddEventHandler ["ButtonClick",{
		params ["_btn"];
		createDialog "para_WelcomeScreen";
	}];

    // Bug Report
	/*
	_bugBtn = _display ctrlCreate ["para_RscButtonMenu", -1];
	_bugBtn ctrlSetPosition [safeZoneX + UIW(1), safeZoneY + UIH(3.2), UIW(15), UIH(1)];
	_bugBtn ctrlCommit 0;
	_bugBtn ctrlSetText "BUG REPORT";
	_bugBtn ctrlAddEventHandler ["ButtonClick",{
		params ["_btn"];
		_escDisplay = ctrlParent _btn;
		[_escDisplay] call para_c_fnc_bugReport_init;
	}];
	*/
}] call BIS_fnc_addScriptedEventHandler;