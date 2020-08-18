/*
    File: eh_Killed.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-05-13
    Last Update: 2020-05-26
    Public: No

    Description:
		Player Killed Event Handler.

    Parameter(s):
		_unit - Description [DATATYPE, defaults to DEFAULTVALUE]
		_killer - Description [DATATYPE, defaults to DEFAULTVALUE]
		_instigator - Description [DATATYPE, defaults to DEFAULTVALUE]
		_useEffects - Description [DATATYPE, defaults to DEFAULTVALUE]

    Returns: nothing

    Example(s):
		Not called directly.
*/

params
[
	"_unit",
	"_killer",
	"_instigator",
	"_useEffects"
];

// disable build mode
para_l_buildmode = nil;
para_l_placing = false;
