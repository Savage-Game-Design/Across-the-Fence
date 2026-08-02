//vn_bench_05_f ~ vn_bench_f ~ vn_us_common_bench_01
isNil{params["_b","_t","_id"];
if(floor random 2==1)then{
private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );
private _dir = if(_t in["vn_bench_f.p3d","vn_bench_ep1.p3d"])then{getDir _b+90}else{getDir _b};
private _faceDir = if(_t isEqualTo"vn_bench_f.p3d")then{[3,0,1.5]}else{[0,3,1.5]};

//Facing away from wall or face toward campfire
private _intFront=lineIntersectsObjs[ ATLtoASL(_b modelToWorld[0,0,1.5]) , ATLtoASL(_b modelToWorld _faceDir) , _b, objNull , false , 4 ];
private _isFront=_intFront isNotEqualTo[];

private _dir=if(_isFront)then{_dir+180}else{_dir};
private _fire=(nearestObjects[_b,[],5,false]-[_b])select{("vn_campfire_f.p3d"in str _x)||("vn_fireplace_f.p3d"in str _x)};
private _dir=if(_fire isNotEqualTo[])then{ (_b getDir (_fire#0) ) } else {_dir};
private _dir=(linearConversion[0,180,_dir,0,180]);

_xx = switch(_t)do
{
	case"vn_us_common_bench_01.p3d":{-0.55};
	case"vn_bench_f.p3d":{0};
	default{-0.65};
};

private _y=switch(_t)do
{
	case"vn_bench_05_f.p3d":{if(_isFront)then{-0.1}else{0.1};};
	case"vn_bench_ep1.p3d":{if(_isFront)then{-0.1}else{0.1};};
	case"vn_bench_f.p3d":{if(_isFront)then{-0.1}else{0.1};};
	case"vn_us_common_bench_01.p3d":{if(_isFront)then{-0.1}else{0.1};};
};

private _z=switch(_t)do
{
	case"vn_bench_05_f.p3d":{-1};
	case"vn_bench_f.p3d":{-1};
	case"vn_us_common_bench_01.p3d":{-1};
	default{0.5};
};

for"_x"from 0 to(floor random 3)do
{
if(floor random 2==1)then{
private _c=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
_c disableAI"all";
( ( PF_MapObjs # _i ) # 2 ) pushBack _c;
{_c call _x}forEach[civF,civH,civU,civG];
[ _c , "Crew" ] remoteExec [ "switchMove" , 0 , _c ];
_c setDir _dir;
_c setPos ( _b modelToWorld [ _xx , _y , _z ] );

_c addEventHandler["Killed",{params["_a"];_a removeAllEventHandlers"FiredNear";}];

_c addEventHandler["FiredNear",{
params["_a","_f"];_a removeEventHandler["FiredNear",_thisEventHandler];_a removeAllEventHandlers"AnimDone";
{_a enableAI _x}forEach["anim","teamSwitch","move","path"];
switch(floor random 3)do{
case 0:{[_a,"ApanPercMstpSnonWnonDnon_G01"]remoteExec["switchMove",0,_a]};
case 1:{[_a,"ApanPknlMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]};
case 2:{[_a,"ApanPpneMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]};};
_a forceWalk false;_a forceSpeed 13;
_a setDestination[(_a getPos[99 , _f getDir _a ]),"LEADER PLANNED",true];
}];
};_xx=if(_t isEqualTo"vn_us_common_bench_01.p3d")then{_xx+0.55}else{_xx+0.65};
};
};
}