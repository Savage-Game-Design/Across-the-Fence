//vn_rice_plant_sapling_02.p3d ~ vn_rice_plant_med_02.p3d — Ambient Buffalos
isNil{params["_b","_t","_id"];

if(floor random 4>0)exitWith{};
private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );

private _pos = getPosATL _b;
private _spawnPos = _pos getPos [5 + random 10, random 360];
_spawnPos set [2, 0];

private _module = "ModuleAnimalsBuffalos_F" createVehicle _spawnPos;

( ( PF_MapObjs # _i ) # 2 ) pushBack _module;
}