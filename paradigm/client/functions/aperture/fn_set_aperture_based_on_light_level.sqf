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

private _base = 3;
private _threshold = 35;

private _lightBrightness = getLighting select 1;

if (_lightBrightness > _threshold) exitWith { setAperture -1 };

private _scaling1 = linearConversion [0, _threshold, _lightBrightness, 0.8, 1, true];
private _scaling2 = linearConversion [3, 5, _lightBrightness, 0.75, 1, true];
private _scaling3 = linearConversion [0, 2, _lightBrightness, 0.5, 1, true];
private _scaling4 = linearConversion [0, 0.7, _lightBrightness, 0.5, 1, true];


setApertureNew [_base * _scaling1 * _scaling2 *_scaling3 * _scaling4, 6, 9, 0.9];
