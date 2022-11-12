/*
    File: fn_ui_hints_acknowledgeHintKeypress.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Handles the "acknowledge hint" key being pressed, including double presses.
    
    Parameter(s):
        None
    
    Returns:
		Hint [HashMap]
    
    Example(s):
		[] call para_c_fnc_ui_hints_acknowledgeHint
*/

// Double press behaviour

private _doublePressTime = 0.2;
private _lastKeypress = localNamespace getVariable ["para_c_ui_hints_last_acknowledge_keypress", 0];

if (time < _lastKeypress + _doublePressTime) exitWith {
  private _lastHint = localNamespace getVariable "para_c_ui_hints_last_acknowledged_hint";
  if (isNil "_lastHint") exitWith {};
  [_lastHint get "category", _lastHint get "hint"] call para_c_fnc_ui_hints_openFieldManual; 
};

// Single press behaviour - fires on the first press of a double press.

private _activeHints = uiNamespace getVariable ["para_c_activeHints", []];
if (count _activeHints <= 0) exitWith {};

localnamespace setVariable ["para_c_ui_hints_last_acknowledged_hint", _activeHints select 0];
localNamespace setVariable ["para_c_ui_hints_last_acknowledge_keypress", time];

[] call para_c_fnc_ui_hints_pop_hint;


