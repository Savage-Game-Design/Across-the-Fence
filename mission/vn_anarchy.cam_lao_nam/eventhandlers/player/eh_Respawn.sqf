/*
    File: eh_Respawn.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-05-13
    Last Update: 2020-05-26
    Public: No

    Description:
	    Respawn Event Handler.

    Parameter(s):
        _unit - Alive Player [OBJECT, defaults to DEFAULTVALUE]
        _corpse - Dead Player [OBJECT, defaults to DEFAULTVALUE]

    Returns: nothing

    Example(s):
	    Not called directly.
*/

params
[
	"_unit",
	"_corpse"
];


// restart master loop
0 spawn vn_mf_fnc_master_loop_init;
