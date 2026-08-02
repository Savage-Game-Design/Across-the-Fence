//vn_dyke_10.p3d
isNil{params["_b","_t","_id"];
if(floor random 50==5)then{
private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );


private _c=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
_c disableAI"all";

( ( PF_MapObjs # _i ) # 2 ) pushBack _c;

{_c call _x}forEach[civF,civH,civU,civG];
if(floor random 4==1)then{_c addBackpack "vn_c_pack_01"};
_c addHeadgear ( selectRandom [ "vn_c_conehat_01" , "vn_c_conehat_02"] );
_c enableStamina false;

private _anim=selectRandom["passenger_flatground_1_Idle_Unarmed_Idling","passenger_flatground_2_Idle_Unarmed_Idling","passenger_flatground_3_Idle_Unarmed_Idling","passenger_flatground_4_Idle_Unarmed_Idling","passenger_boat_4_Idle_Unarmed_Idling"];
_c switchMove _anim;
_c setDir random 359;
_c setPos ( _b modelToWorld [ 0 , ( selectRandom [ random -4 , random 4 ] ) , 1.2 ] );

_c addEventHandler["Killed",{params["_a"];_a removeAllEventHandlers"AnimDone";_a removeAllEventHandlers"FiredNear";}];

_c addEventHandler["AnimDone",
{
	params[ "_c" , "_an" ];
	if ( !alive _c ) exitWith { _c removeEventHandler ["AnimDone",_thisEventHandler]; };
	[_c,_an]remoteExec["switchMove",0,_c];
}];

_c addEventHandler["FiredNear",{
params["_a","_f"];_a removeEventHandler["FiredNear",_thisEventHandler];_a removeAllEventHandlers"AnimDone";
{_a enableAI _x}forEach["anim","teamSwitch","move","path"];
switch(floor random 2)do{
case 0:{[_a,"ApanPercMstpSnonWnonDnon_G01"]remoteExec["switchMove",0,_a]};
case 1:{[_a,"ApanPknlMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]};
case 2:{[_a,"ApanPpneMstpSnonWnonDnon_G01"]remoteExec["playMoveNow",0,_a]}};
_a forceWalk false;_a forceSpeed 13;
_a setDestination[(_a getPos[99 , _f getDir _a ]),"LEADER PLANNED",true];
}];
};
}