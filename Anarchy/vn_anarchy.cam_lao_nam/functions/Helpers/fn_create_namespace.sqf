/*
  Author: Spoffy

  Description:
	Creates an entity which variables can be stored in.

  Example Usage:
	true call vn_mf_fnc_create_namespace;

  Returns:
	A namespace (either a Location if local, or a simpleObject if global)

  Parameter(s):
	_isGlobal - Whether the namespace should only be created globally.
*/

params [["_global", false]];

if (!_global) exitWith {
	createLocation ["Invisible", [-1, -1, -1], 0, 0]
};

createSimpleObject ["a3\weapons_f\empty.p3d", [-1, -1, -1], true]


