/*
    File: fn_ui_hints_pop_hint.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Remove the topmost hint.
    
    Parameter(s):
        None
    
    Returns:
		Hint [HashMap]
    
    Example(s):
		[] call para_c_fnc_ui_hints_pop_hint
*/

private _activeHints = uiNamespace getVariable ["para_c_activeHints", []];

if (count _activeHints == 0) exitWith {};

private _hintQueue = localNamespace getVariable ["para_c_hintQueue", []];
private _cardConfig = localNamespace getVariable "para_c_survivalCardConfig";
private _cardPositionFuncs = _cardConfig get "positions";

// Delete the card
private _hintToRemove = _activeHints select 0;
private _cardControl = _hintToRemove get "control";

_cardControl ctrlSetPositionX (safeZoneW - safeZoneX);
_cardControl ctrlCommit 0.2;
_cardControl spawn {
	uiSleep 0.2;
	ctrlDelete _this;
};

_activeHints = _activeHints select [1, count _activeHints];
uiNamespace setVariable ["para_c_activeHints", _activeHints];

if (count _hintQueue > 0) then {
  private _nextHint = _hintQueue select 0;
  _nextHint call para_c_fnc_ui_hints_show_hint;
  _activeHints = uiNamespace getVariable ["para_c_activeHints", []];
  private _tempHintQ = _hintQueue select [1, count _hintQueue];
  localNamespace setVariable ["para_c_hintQueue", _tempHintQ];
};

// Animate down other cards
{
	private _control = _x get "control";
	_control ctrlSetPosition (_cardPositionFuncs select _forEachIndex apply {call _x});
	_control ctrlCommit 0.3;
} forEach _activeHints;