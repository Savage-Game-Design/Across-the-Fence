/*
    ["vn_762x33"] call compileScript ["functions\systems\medical\client\dev\testAmmo.sqf"];
*/
_this spawn {
    params ["_ammoClass", ["_vest", ""]];

    private _agent = [] call compileScript ["functions\systems\medical\client\dev\createDummy.sqf"];
    _agent enableSimulationGlobal false;
    _agent setPosASL [1000, 1000, 500];

    if (_vest != "") then {_agent addVest _vest};

    private _fnc_shootWith = compileScript ["functions\systems\medical\client\dev\shootWith.sqf"];
    private _hitPointsCfg = configOf _agent >> "HitPoints";

    diag_log text format ["========= START AMMO TEST - %1 =========", _ammoClass];

    {
        private _selection = getText (_hitPointsCfg >> _x >> "name");
        [_agent, _selection, _ammoClass] call _fnc_shootWith;
        sleep 0.1;
    } forEach (keys vgm_c_medical_hitPointBodyPartMap);

    deleteVehicle _agent;

    diag_log text format ["========= END AMMO TEST - %1 ==========", _ammoClass];
};
