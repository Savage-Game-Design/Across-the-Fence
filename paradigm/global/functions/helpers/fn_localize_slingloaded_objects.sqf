/*
    File: fn_localize_slingloaded_objects.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Transfers any object attached to the heli to the client where the heli is local.
        Must be run on the server.
    
    Parameter(s):
        _heli - Helicopter to apply slingload localisation to.
    
    Returns:
        Localisation event handled was successfully applied.
    
    Example(s):
        [_myHeli] call para_g_fnc_localize_slingloaded_objects
*/

params ["_heli"];

if (!(_heli isKindOf "Helicopter") || {_heli getVariable ["slingloadLocalisationApplied", false]}) exitWith {false};

_heli addEventHandler ["RopeAttach", {
  params ["_heli", "_rope", "_object"];
  if (!local _heli && fullCrew _object isEqualTo []) then {
    _object setOwner owner _heli;
  }; 
}];

_heli setVariable ["slingloadLocalisationApplied", true];

true