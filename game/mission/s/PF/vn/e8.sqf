//BAMBOO
isNil{params["_b","_t","_id"];
if(floor random 9==1)then{
private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );
private _dir = getDir _b;


private _c=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
_c disableAI"all";

( ( PF_MapObjs # _i ) # 2 ) pushBack _c;

{_c call _x}forEach[civF,civH,civU,civG];
_c enableStamina false;

_a disableCollisionWith _b;
[_a,"InBaseMoves_Lean1"]remoteExec["switchMove",0,_a];
_a setDir(getDir _b-60);
_a setPos(_b modelToWorld[0,0.25,-0.53]);

_c addEventHandler["Killed",{params["_a"];_a removeAllEventHandlers"FiredNear";}];

_c addEventHandler["FiredNear",{
params["_a","_f"];_a removeEventHandler["FiredNear",_thisEventHandler];
_a enableAI "anim";
if(floor random 2==0)then{[ _a , "Acts_CivilHiding_2" ] remoteExec [ "switchMove" , 0 , _a ];}else{[ _a , "Acts_CivilHiding_1" ] remoteExec [ "switchMove" , 0 , _a ];};
_a forceWalk false;_a forceSpeed 13;
}];
};
}