/*
    File: eh_HandleRating.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-01-29
    Last Update: 2020-05-26
    Public: No

    Description:
	    HandleRating Event Handler, to force rating to stay at 0 to prevent players being marked as enemy.

    Parameter(s):
        _unit - Description [DATATYPE, defaults to DEFAULTVALUE]
        _rating - Description [DATATYPE, defaults to DEFAULTVALUE]

    Returns:
	    Always returns 0 [NUMBER]

    Example(s):
	    Not called directly.
*/

params
[
	"_unit",
	"_rating"
];

0
