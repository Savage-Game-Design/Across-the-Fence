/*
    ["GrenadeHand", 15] call compileScript ["functions\systems\medical\client\dev\testExplosive.sqf"];

    vn_grenadehand - VN grenade
    GrenadeHand - vanilla grenade
*/

params ["_class", "_distance"];

diag_log text format ["========= EXPOSIVE TEST - %1 | %2 =========", _class, _distance];

createVehicle [_class, player getPos [_distance, getDir player], [], 0, "CAN_COLLIDE"];
