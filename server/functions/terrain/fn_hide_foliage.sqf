 /*
	File: fn_hide_foliage.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Hides foliage in the given area and radius
	
	Parameter(s):
		_position - Center of area to hide foliage [Object, PositionAGL or Position 2D]
		_radius - Radius to hide foliage in [Number]
		_2d - 2D search if true, else 3D search. Defaults to 2D. [Boolean]
	
	Returns:
		Foliage hidden
	
	Example(s):
		[allPlayers # 0, 20] call para_s_fnc_hide_foliage;
*/

params ["_position", "_radius", ["_2D", true]];

private _objectsToHide = nearestTerrainObjects [_position, ["TREE", "BUSH", "FENCE"], _radius, false, _2D];
{
	_x hideObjectGlobal true;
} forEach _objectsToHide;

_objectsToHide