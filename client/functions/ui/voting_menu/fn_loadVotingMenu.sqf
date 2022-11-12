/*
	File: fn_loadVotingMenu.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Loads the voting menu.
	
	Parameter(s): none
	
	Returns: nothing

	Example(s): none
*/

private _titleCtrl = uiNamespace getVariable ['#para_c_VoteMenu_TitleControl', controlNull];
private _bodyCtrl = uiNamespace getVariable ['#para_c_VoteMenu_Body', controlNull];
private _optionsCtrl = uiNamespace getVariable ['#para_c_VoteMenu_Options', controlNull];
private _voteCtrl = uiNamespace getVariable ['#para_c_VoteMenu_Vote', controlNull];

private _data = missionNamespace getVariable '#para_c_VoteData';
if (isNil "_data") exitWith {};

_titleCtrl ctrlSetText (_data get "title");
_bodyCtrl ctrlSetStructuredText parseText (_data get "content");

{
	private _i = _optionsCtrl lbAdd format ['- %1', _x];
	_optionsCtrl lbSetPictureRight [_i, '\vn\ui_f_vietnam\ui\taskroster\img\box_unchecked.paa']
} forEach (_data get "options");

_optionsCtrl ctrlAddEventHandler ['LBSelChanged', {
	for '_i' from 0 to (lbSize (_this#0)) - 1 do {
		(_this#0) lbSetPictureRight [_i, '\vn\ui_f_vietnam\ui\taskroster\img\box_unchecked.paa']
	};
	(_this#0) lbSetPictureRight [(_this#1), '\vn\ui_f_vietnam\ui\taskroster\img\box_checked.paa']
}];

_voteCtrl ctrlAddEventHandler ['ButtonClick', {
	private _sel = lbCurSel (uiNamespace getVariable ['#para_c_VoteMenu_Options', controlNull]);
	if (_sel isEqualTo -1) exitWith { hint localize "STR_vn_mf_voteMenu_selectOptionPrompt" };
	_sel call para_c_fnc_submitVote;
}];