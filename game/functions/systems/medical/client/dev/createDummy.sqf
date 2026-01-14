#include "../script_component.inc"
/*
_agent = [true] call compileScript ["functions\systems\medical\client\dev\createDummy.sqf"];

_agent addVest "vn_b_vest_usmc_01";
_agent addVest "V_PlateCarrierGL_blk";
*/

params [["_wounded", false]];

private _pos = positionCameraToWorld [0,10,0];
private _agent = createAgent ["vn_b_men_sf_01", _pos, [], 0, "CAN_COLLIDE"];
_agent setUnitLoadout [[],[],[],[],[],[],"","",[],["","","","","",""]];

_agent call vgm_c_fnc_medical_unitInit;

player reveal _agent;

if (_wounded) then {
    {
        [_agent, _x, 2] call vgm_c_fnc_medical_addWound;
    } forEach BODY_PARTS_ARR
};

// [_agent, "limbInjuryEffectResistance", "dev"] call vgm_c_fnc_statusEffect_set;
// [_agent, "injuryEffectImmunity", "dev"] call vgm_c_fnc_statusEffect_set;

[_agent, "bleeding", "medical"] call vgm_c_fnc_statusEffect_remove;

_agent // return
