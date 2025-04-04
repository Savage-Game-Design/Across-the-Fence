/*
    File: fn_virtsquad_scaleComposition.sqf
    Author: Savage Game Design
    Date: 2025-04-04
    Last Update: 2025-04-04
    Public: Yes

    Description:
        Creates a list of unit classes to spawn, based on a composition and a number of units desired.

    Parameter(s):
        _composition - List of unit classes [ARRAY]
        _unitCount - Number of units in resulting class list [NUMBER]

    Returns:
        Array of unit classes [ARRAY]

    Example(s):
        [["vn_man", "vn_man_1"], 10] call vgm_s_fnc_virtsquad_scaleComposition;
 */

params ["_composition", "_unitCount"];

private _squad = [];
for "_i" from 1 to _unitCount do
{
    // Select randomly to avoid favouring early entries.
	private _class = selectRandom _composition;
	_squad pushBack _class;
};

_squad
