//vn_campfire_f ~ vn_fireplace_f
//BUG: Dedicated server has JIP issues with rendering/spawning fire & smoke particle effects
isNil{params["_b","_t","_id"];
private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );
_b hideObjectGlobal true;
private _type=switch(_t)do{
case"vn_campfire_f.p3d":{"vn_campfire_burning_f"};
case"vn_fireplace_f.p3d":{"vn_fireplace_burning_f"};
};
private _nb=createVehicle[_type,(getPosATL _b),[],0,"can_collide"];

( ( PF_MapObjs # _i ) # 2 ) pushBack _nb;


private _colorRed=0.8;
private _colorGreen=0.8;
private _colorBlue=0.8;
private _colorAlpha=0.6;
private _particleLifetime=12;
private _particleDensity=3;
private _particleSize=1;
private _particleSpeed=1;
private _particleLifting=1;
private _windEffect=0.5;
private _effectSize=0.1;
private _expansion=0.75;
private _smk=createVehicle["#particlesource",_b,[],0,"can_collide"];
( ( PF_MapObjs # _i ) # 2 ) pushBack _smk;

[_smk,[["\A3\data_f\ParticleEffects\Universal\Universal_02",8,0,40,1],"","billboard",1,_particleLifeTime,[0,0,0],[0,0,2*_particleSpeed],0,0.05,0.04*_particleLifting,0.05*_windEffect,[1 *_particleSize + 1,1.8 * _particleSize + 15],
[[0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.7*_colorAlpha],[0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.6*_colorAlpha],[0.7*_colorRed,0.7*_colorGreen,0.7*_colorBlue,0.45*_colorAlpha],
[0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.28*_colorAlpha],[0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.16*_colorAlpha],[0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.09*_colorAlpha],
[0.84*_colorRed,0.84*_colorGreen,0.84*_colorBlue,0.06*_colorAlpha],[1*_colorRed,1*_colorGreen,1*_colorBlue,0.02*_colorAlpha],[1*_colorRed,1*_colorGreen,1*_colorBlue,0*_colorAlpha]],
[1,0.55,0.35], 0.1, 0.08*_expansion, "", "", ""]]remoteExec["setParticleParams",0,_smk];
[_smk,[_particleLifeTime/2, [0.5*_effectSize,0.5*_effectSize,0.2*_effectSize], [0.3,0.3,0.5], 1, 0, [0,0,0,0.06], 0, 0]]remoteExec["setParticleRandom",0,_smk];
[_smk,(1/_particleDensity)]remoteExec["setDropInterval",0,_smk];

private _seats=(nearestObjects[_b,[],3])select{ "vn_bench_05_f.p3d"in str _x || { "vn_bench_f.p3d"in str _x || { "vn_bench_ep1.p3d"in str _x || { "vn_us_common_bench_01.p3d"in str _x } } } };
if(_seats isNotEqualTo[])exitWith{};
_rPos=random 120;
for"_x"from 0 to(floor random 2+1)do{
private _c=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
_c disableAI"all";

( ( PF_MapObjs # _i ) # 2 ) pushBack _c;

_rPos=_rPos+random 120;
{_c call _x}forEach[civF,civH,civU,civG];
_c enableStamina false;
_c setPos(_b getPos[1.5,_rPos]);
_c setDir(_c getDir _b);
_c setDamage 0;
if(floor random 3==1)then{_c enableAI"anim";_c playAction"SitDown"}else
{
	private _anim = selectRandom["passenger_flatground_generic02","Acts_AidlPercMstpSnonWnonDnon_warmup_4_loop","passenger_flatground_2_Idle_Unarmed_Idling","passenger_flatground_3_Idle_Unarmed_Idling"];
	[_c,_anim]remoteExec["switchMove",0,_c];
};

_c addEventHandler["FiredNear",{
params["_a","_f"];_a removeEventHandler["FiredNear",_thisEventHandler];
{_a enableAI _x}forEach["anim","teamSwitch","move","path"];
switch(floor random 2)do{
case 0:{[_a,"ApanPercMstpSnonWnonDnon_G01"]remoteExec["switchMove",0,_a]};
case 1:{[_a,"ApanPknlMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]};
case 2:{[_a,"ApanPpneMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]}};
_a forceWalk false;_a forceSpeed 13;
_a setDestination[(_a getPos[99 , (getDir _f) ]),"LEADER PLANNED",true];
}];
};
}