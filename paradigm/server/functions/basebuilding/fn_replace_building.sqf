/*
    File: fn_create_building.sqf
    Author:  Savage Game Design
    Public: No

    Description:
	creates replacement object and finalizes swap on server

    Parameter(s):
	_class - New class name [STRING]
	_object - Object to be replaced [OBJECT]

    Returns:
	newly created object [OBJECT]

    Example(s):
	[_class,_object] call para_s_fnc_replace_building
*/
params
[
	"_class",
	"_object"
];

//Don't need to do anything if we're already the correct type!
if (typeOf _object isEqualTo _class) exitWith {_object};

_pos = getPosWorld _object;
private _veh = createVehicle [_class, _pos, [], 0, 'CAN_COLLIDE'];
_veh setVectorDirAndUp [vectorDir _object, vectorUp _object];
_veh setPosWorld _pos;

deleteVehicle _object;

_veh
