/*
  Author: Aaron Clark

  Description:
	initialize player stats progress bars using stance indicator as hook

  Example Usage:
	0 spawn vn_mf_fnc_ui_create;

*/
disableSerialization;

waitUntil{!isNull (findDisplay 46)};

// hunger / thirst
private _gui = (uiNamespace getVariable ["IGUI_displays",""]) select {(ctrlIdd _x) isEqualTo 303};

if !(_gui isEqualTo []) then
{
	private _display = _gui select 0;
	private _stance_ctrl = _display displayCtrl 188;
	private _stance_ctrl_pos = ctrlPosition _stance_ctrl;
	_stance_ctrl_pos set [1,(_stance_ctrl_pos select 1) + (_stance_ctrl_pos select 3)];

	// init new empty display
	("healthGUILayer" call BIS_fnc_rscLayer) cutRsc ["RscTitleDisplayEmpty", "PLAIN"];
	private _display = uiNamespace getVariable "RscTitleDisplayEmpty";

	private _stats = getArray(missionConfigFile >> "gamemode" >> "health" >> "gui_progress_bars" );
	private _width = (_stance_ctrl_pos select 2) / count _stats;
	_stance_ctrl_pos set [2,_width];

	{
		_x params ["_name", "_color"];
		private _control = _display ctrlCreate ["RscStatProgress", -1];

		uiNamespace setVariable [format["vn_mf_%1_ctrl",_name], _control];

		_control ctrlSetPosition _stance_ctrl_pos;
		_control ctrlSetBackgroundColor [0,0,0,0.5];
		_control ctrlSetTextColor _color;
		_control ctrlCommit 0;
		_control progressSetPosition (player getVariable [format["vn_mf_%1",_name], 1]);

		_stance_ctrl_pos set [0,(_stance_ctrl_pos select 0) + _width];


	} forEach _stats;

} else {
	diag_log "Error: no display found.";
};
