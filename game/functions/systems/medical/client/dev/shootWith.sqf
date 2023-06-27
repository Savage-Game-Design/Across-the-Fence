/*
    [cursorObject, "vn_762x33"] call compileScript ["functions\systems\medical\client\dev\shootWith.sqf"];

    vn_762x51 = M60
    vn_762x33 - M1
    vn_762x39 - Type 56
    vn_127x108 - DShKM
*/
isNil {
    params ["_unit", "_selection", "_ammoClass"];

    private _hitPointPos = _unit selectionPosition _selection;
    private _hitPointPosWorld = _unit modelToWorldWorld _hitPointPos;
    private _spawnPosWorld = _unit modelToWorldWorld (_hitPointPos vectorAdd [0,1,0]);

    private _projectile = _ammoClass createVehicle [0,0,0];

    private _typicalSpeed  = getNumber (configOf _projectile >> "typicalSpeed");
    private _dirAndUp = [_spawnPosWorld, _hitPointPosWorld] call BIS_fnc_findLookAt;

    _projectile setPosWorld _spawnPosWorld;
    _projectile setVectorDirAndUp _dirAndUp;
    _projectile setVelocityModelSpace [0, _typicalSpeed, 0];
    //_projectile enableSimulation false;
};

nil
