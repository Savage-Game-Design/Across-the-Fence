/*
	File: fn_createVote.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Creates a vote.
	
	Parameter(s):
		_title - Title of the vote [String]
		_content - Body of the vote. Will be text parsed after [String]
		_options - String array of options [String[]]
		_timeout - Duration of the vote [Number]
		_callback - Function called when a player chose an option [Code]
		_shouldSuspend - Whether the vote countdown should be paused when the vote is in the queue [Boolean, default false]
	
	Returns:
		True if the vote was created, false if a vote was already ongoing.
	
	Example(s):
		[
			"Vote Initialized",
			"What's your favorite game?",
			["Arma 3", "Other"],
			0,
			{ systemChat str _this }
		] call para_c_fnc_createVote
*/

// Probably not the best code, but hey, it works :)


#include "..\..\..\configs\ui\ui_def_base.inc"

params [
	"_title",
	"_content",
	"_options",
	"_timeout",
	"_callback",
	["_shouldSuspend", false]
];

// Add vote to the queue if there's already an active vote.
private _data = missionNamespace getVariable '#para_c_VoteData';
if !(isNil "_data") exitWith { 
	private _queue = localNamespace getVariable ["para_c_vote_queue", []];
	private _entry = [time, [_title, _content, _options, _timeout, _callback, _shouldSuspend]];

	// Suspend items go to the back, non-suspend go as close to the front as possible without breaking other votes.
	if (_shouldSuspend) then {
		_queue pushBack _entry;
	} else {
		private _ourEndTime = time + _timeout;
		private _insertionIndex = _queue findIf {
			private _itemStartTime = _x # 0;
			private _itemDuration = _x # 1 # 3;
			private _itemShouldSuspend = _x # 1 # 5;
			_itemShouldSuspend || _itemStartTime + _itemDuration > _ourEndTime
		};
		_insertionIndex = _insertionIndex max 0;
		_queue = [_entry] + _queue;
	};

	localNamespace setVariable ["para_c_vote_queue", _queue];

	false 
};

_title = _title call para_c_fnc_localize;
_content = _content call para_c_fnc_localize;
_options = _options apply {_x call para_c_fnc_localize};

private _voteData = createHashMapFromArray [
	["title", _title],
	["content", _content],
	["options", _options],
	["timeout", _timeout],
	["callback", _callback],
	["shouldSuspend", _shouldSuspend]
];

missionNamespace setVariable ['#para_c_VoteData', _voteData];

"para_VoteOverlay" cutRsc ["para_VoteOverlay", "PLAIN", -1, false];

// Controls
private _holder = uiNamespace getVariable ['#para_c_VoteoOverlay_Holder', controlNull];
private _body = uiNamespace getVariable ['#para_c_VoteoOverlay_Body', controlNull];
private _titleControl = uiNamespace getVariable ['#para_c_VoteOverlay_Title', controlNull];
private _votesControl = uiNamespace getVariable ['#para_c_VoteOverlay_Votes', controlNull];
private _progressControl = uiNamespace getVariable ['#para_VoteOverlay_Progress', controlNull];
private _contentControl = uiNamespace getVariable ['#para_c_VoteOverlay_Text', controlNull];
private _backgroundControl = uiNamespace getVariable ['#para_c_VoteOverlay_Background', controlNull];
private _primaryControl = uiNamespace getVariable ['#para_c_VoteOverlay_Primary', controlNull];
private _primaryKeyControl = uiNamespace getVariable ['#para_c_VoteOverlay_Primary_Key', controlNull];
private _primaryTextControl = uiNamespace getVariable ['#para_c_VoteOverlay_Primary_Text', controlNull];
private _secondaryControl = uiNamespace getVariable ['#para_c_VoteOverlay_Secondary', controlNull];
private _secondaryTextControl = uiNamespace getVariable ['#para_c_VoteOverlay_Secondary_Text', controlNull];
private _secondaryKeyControl = uiNamespace getVariable ['#para_c_VoteOverlay_Secondary_Key', controlNull];

private _useMenu = count _options > 2;

// Some other things
private _keyControls = [
	[_primaryKeyControl, _primaryTextControl, _primaryControl],
	[_secondaryKeyControl, _secondaryTextControl, _secondaryControl]
];

private _keybind1 = ["para_vote_1"] call para_c_fnc_get_key_bind;
private _keybind2 = ["para_vote_2"] call para_c_fnc_get_key_bind;
private _keys = [
	[_keybind1#0] call para_c_fnc_getKeyName,
	[_keybind2#0] call para_c_fnc_getKeyName
];

_titleControl ctrlSetText _title;

private _contentText = if (_useMenu) then {localize "STR_vn_mf_voteMenu_voteInitBody"} else {_content};
_contentControl ctrlSetStructuredText (parseText _contentText);
private _textHeight = ctrlTextHeight _contentControl;
_contentControl ctrlSetPositionH _textHeight;
_contentControl ctrlCommit 0;

private _finalControl = _keyControls select (!_useMenu) select 2;
private _totalHeight = (ctrlPosition _finalControl select 1) + (ctrlPosition _finalControl select 3) + (UIH(0.1));
_body ctrlSetPositionH _totalHeight;
_body ctrlCommit 0;
_backgroundControl ctrlSetPositionH _totalHeight;
_backgroundControl ctrlCommit 0;

if (_useMenu) then {
	private _keybind3 = ["para_vote_3"] call para_c_fnc_get_key_bind;
	_primaryKeyControl ctrlSetText ([_keybind3#0] call para_c_fnc_getKeyName);
	_primaryTextControl ctrlSetText localize "STR_vn_mf_voteMenu_open";

	_secondaryControl ctrlShow false;
} else {
	{
		private _data = _keyControls # _forEachIndex;
		_data params ["_keyCtrl", "_textCtrl", "_groupCtrl"];
		_groupCtrl ctrlShow true;
		_keyCtrl ctrlSetText (_keys#_forEachIndex);
		_textCtrl ctrlSetText _x;
	} forEach _options;
};

[0.3] call para_c_fnc_showVote;


private _durationHandler = _timeout spawn {
	private _progressBarControl = uiNamespace getVariable ['#para_c_VoteOverlay_ProgressBar', controlNull];
	_progressBarControl ctrlSetPositionW UIW(0);
	_progressBarControl ctrlCommit _this;
	uiSleep (_this / 3);
	_progressBarControl ctrlSetBackgroundColor [0.53, 0.53, 0.06, 1];
	uiSleep (_this / 3);
	_progressBarControl ctrlSetBackgroundColor [0.53, 0.06, 0.06, 1];
	uiSleep (_this / 3);
	[] spawn para_c_fnc_endVote;
};

missionNamespace setVariable ['#para_c_VoteDurationHandler', _durationHandler];
true;
