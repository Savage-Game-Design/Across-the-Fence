params ["_key", "_id", "_data"];

missionProfileNamespace setVariable [format ["vgm_%1_%2", _key, _id], _data] // return