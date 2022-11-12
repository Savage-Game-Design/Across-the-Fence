/*
	File: fn_ui_hints_setup.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Sets up the hint system for use - loads the display layer, and calculates positions.
	
	Parameter(s):
		None
	
	Returns:
		None
	
	Example(s):
		[] call para_c_fnc_hints_setup_display
*/

"para_survival_cards" cutRsc ["para_RscSurvivalHints", "PLAIN"];

private _survivalCardConfig = createHashMap;
private _positions = [];

{
	private _cardConfig = (call para_g_fnc_paradigm_config_file) >> "RscTitles" >> "para_RscSurvivalHints" >> "Controls" >> _x;
	_positions pushBack [
		compile getText (_cardConfig >> "x"),
		compile getText (_cardConfig >> "y")
	];

} forEach ["SurvivalCardTop", "SurvivalCardMiddle", "SurvivalCardBottom"];

_survivalCardConfig set ["positions", _positions];

localNamespace setVariable ["para_c_survivalCardConfig", _survivalCardConfig];
uiNamespace setVariable ["para_c_activeHints", []];