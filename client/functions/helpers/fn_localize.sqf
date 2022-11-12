/*
    File: fn_localize.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Localizes a string if a localization exists, otherwise returns the string.
		Faster than BIS_fnc_localize.
    
    Parameter(s):
		_this - String to localize [String]
    
    Returns:
        Localized string if localization exists, otherwise the original string [String]
    
    Example(s):
        "STR_foo" call para_c_fnc_localize;
*/

if (isLocalized _this) exitWith {
	localize _this
};

_this