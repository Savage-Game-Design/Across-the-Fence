/*
  Author: Aaron Clark

  Description:
	update loading screen text

  Example Usage:
	"" call vn_an_fnc_update_loading_screen;
	or
	["vn/objects_f_vietnam/civ/signs/data/billboards/vn_ui_billboard_01_ca.paa",5040] call vn_an_fnc_update_loading_screen;

  Parameter(s):
*/
params [
	["_text","",["",parseText ""]], // STRING : text to display
	["_idc",5050]
];
disableSerialization;
private _display = uiNameSpace getVariable ["vn_an_loadingScreen",displayNull];
if (!isNull _display) then
{
	if (_text isEqualType parseText "") then
	{
		(_display displayCtrl _idc) ctrlSetStructuredText _text;
	} else {
		(_display displayCtrl _idc) ctrlSetText _text;
	};

	diag_log format["loading text %1", _text];
};
