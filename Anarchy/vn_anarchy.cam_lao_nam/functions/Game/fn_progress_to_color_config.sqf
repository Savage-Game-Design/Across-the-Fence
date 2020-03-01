/*
  Author: Aaron Clark

  Description:
	Adds progress markers, and sets up inital task

  Example Usage:
	[33] call vn_an_fnc_progress_to_color_config;

  Returns:
	STRING - Color Config String

  Parameter(s):
*/
params [
	["_progress",0] //	0: NUMBER - progress range of 0 - 100
];

private _colorstr = switch (floor (_progress * 0.1) * 10) do
{
	case (100):
	{
		"ColorGreen"
	};
	case (90):
	{
		"ColorKhaki"
	};
	case (80);
	case (70):
	{
		"ColorYellow"
	};
	case (60);
	case (50):
	{
		"ColorOrange"
	};
	case (40);
	case (30):
	{
		"ColorBrown"
	};
	case (20);
	case (10):
	{
		"ColorRed"
	};
	default
	{
		"Default"
	};
};

_colorstr
