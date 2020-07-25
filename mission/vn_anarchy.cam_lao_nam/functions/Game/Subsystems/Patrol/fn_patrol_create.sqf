/*
 * File: fn_createPatrol.sqf
 * Author: Spoffy
 * Description:
 *    Creates a patrol that scouts the perimeter of a given point
 * Params:
 *    _position - Position to patrol around
 * 	  _radius - Radius to patrol within around point
 *	  _patrolDifficulty - Difficulty of the patrol. 
 * Returns:
 *    Group of the units created for the patrol.
 * Example Usage:
 *    Example usage goes here
 */

params ["_position", "_radius", ["_unitCount", 2], ["_side", east]];

private _startPos = [[[_position, _radius]]] call BIS_fnc_randomPos;

private _result = [
		_unitCount call vn_an_fnc_squad_patrol, 
		_side,
		_startPos
	] call vn_an_fnc_create_squad;

private _group = _result select 1;

[_group, _position, _radius] call vn_an_fnc_patrol_assign_group;

_group;