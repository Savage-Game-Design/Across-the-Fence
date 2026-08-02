//vn_clothesline_01_short_f
isNil{params["_b","_t","_id"];

//if(floor random 4==1)exitWith{};
private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );

private _c=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
_c disableAI"all";

( ( PF_MapObjs # _i ) # 2 ) pushBack _c;

{_c call _x}forEach[civF,civH,civU,civG];
_c enableStamina false;
private _off=selectRandom [ 0.7 , -0.7 ];
_c setPos(_b modelToWorld [ ( selectRandom [ random 1 , random -1 ] ) , _off , -1 ]);

if(_off == 0.7) then
{
	_c setDir(getDir _b+180);
}else{
	_c setDir(getDir _b);
};
_c setDamage 0;
[_c,"InBaseMoves_assemblingVehicleErc"]remoteExec["switchMove",0,_c];

_c addEventHandler["Killed",{params["_a"];_a removeAllEventHandlers"AnimDone";_a removeAllEventHandlers"FiredNear";}];

_c addEventHandler["FiredNear",{
params["_a","_f"];_a removeEventHandler["FiredNear",_thisEventHandler];_a removeAllEventHandlers"AnimDone";
{_a enableAI _x}forEach["anim","teamSwitch","move","path"];
switch(floor random 2)do{
case 0:{[_a,"ApanPercMstpSnonWnonDnon_G01"]remoteExec["switchMove",0,_a]};
case 1:{[_a,"ApanPknlMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]};
case 2:{[_a,"ApanPpneMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]}};
_a forceWalk false;_a forceSpeed 13;

_a setDestination[(_a getPos[99 , (getDir _f) ]),"LEADER PLANNED",true];
}];
}