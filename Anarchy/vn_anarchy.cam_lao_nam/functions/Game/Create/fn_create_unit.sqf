/*
 * File: fn_createUnit.sqf
 * Author: Spoffy
 * Description:
 *    Wrapper around scripting command 'createUnit'
 * Params:
 *    Identical to 'createUnit'
 * Returns:
 *    Unit created
 * Example Usage:
 *    [createGroup east, myClass", [0,0,0], [], 10, "NONE"] call vn_an_fnc_create_unit;
 */

params ["_group", "_class", "_position", "_markers", "_placement", "_special"];

_group createUnit [_class, _position, _markers, _placement, _special];