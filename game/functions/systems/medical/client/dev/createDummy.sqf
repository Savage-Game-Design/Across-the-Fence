/*
_agent = [] call compileScript ["functions\systems\medical\client\dev\createDummy.sqf"];

_agent addVest "vn_b_vest_usmc_01";
_agent addVest "V_PlateCarrierGL_blk";
*/

private _pos = positionCameraToWorld [0,10,0];
private _agent = createAgent ["vn_b_men_sf_01", _pos, [], 0, "CAN_COLLIDE"];
_agent setUnitLoadout [[],[],[],[],[],[],"","",[],["","","","","",""]];

_agent call vgm_c_fnc_medical_unitInit;

player reveal _agent;

_agent // return
