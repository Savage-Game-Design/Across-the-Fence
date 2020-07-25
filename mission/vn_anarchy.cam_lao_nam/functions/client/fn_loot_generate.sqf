/*
    File: fn_loot_generate.sqf
    Author: Aaron Clark
    Date: 2020-06-15
    Last Update: 2020-06-15
    Public: No

    Description:
	No description added yet.

    Parameter(s):
	_localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]

    Returns:
	Function reached the end [BOOL]

    Example(s):
	[parameter] call vn_fnc_myFunction
*/
_item = "Item1";
_seed = 90382;
_mainrng = _seed random [2,2];
_rarity = floor(linearConversion [0,1,_mainrng,0,4,true]);

EP = _rarity;
EP1 = _durability;
