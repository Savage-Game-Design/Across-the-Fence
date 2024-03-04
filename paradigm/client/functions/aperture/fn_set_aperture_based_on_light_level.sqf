/*
	File: fn_setApertureBasedOnLightLevel.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Sets the aperture based on ambient light levels to allow for night fighting.

	Parameter(s):
		None

	Returns:
		None

	Example(s):
		[] call para_c_fnc_set_aperture_based_on_light_level
*/

private _lightBrightness = getLighting select 1;

if (_lightBrightness > 4 && _lightBrightness < 120) exitWith {
	setApertureNew [4, 6, 9, 0.9];
};

if (_lightBrightness <= 4) exitWith {
	private _overcastCoef = linearConversion [0, 1, overcast, 1, 0.75];
	private _minAperture = linearConversion [0, 4, _lightBrightness, 1, 3, true];
	setApertureNew [_minAperture * _overcastCoef, 6, 9, 0.9];
};

setAperture -1;
