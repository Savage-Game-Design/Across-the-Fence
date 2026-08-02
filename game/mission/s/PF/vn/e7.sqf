//vn boats
isNil{params["_b","_t","_id"];
if(floor random 3==1)then{
private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );
private _dir = getDir _b;


private _c=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
_c disableAI"all";

( ( PF_MapObjs # _i ) # 2 ) pushBack _c;

{_c call _x}forEach[civF,civH,civU,civG];
_c enableStamina false;

private _anim=selectRandom["passenger_flatground_1_Idle_Unarmed_Idling","passenger_flatground_2_Idle_Unarmed_Idling","passenger_flatground_3_Idle_Unarmed_Idling","passenger_flatground_4_Idle_Unarmed_Idling","passenger_boat_4_Idle_Unarmed_Idling"];
_c switchMove _anim;
_c setDir (_dir + 180);
_c setPos (_b modelToWorld[0,2.5,0]);

_c addEventHandler["Killed",{params["_a"];_a removeAllEventHandlers"AnimDone";_a removeAllEventHandlers"FiredNear";}];

_c addEventHandler["AnimDone",{
	params["_a","_an"];
	if(!alive _a)exitWith{_a removeEventHandler["AnimDone",_thisEventHandler];};
	[ _a , _an ] remoteExec [ "switchMove" , 0 , _a ];
}];

_c addEventHandler["FiredNear",{
params["_a","_f"];_a removeEventHandler["FiredNear",_thisEventHandler];_a removeAllEventHandlers"AnimDone";
_a enableAI "anim";
if(floor random 2==0)then{[ _a , "Acts_CivilHiding_2" ] remoteExec [ "switchMove" , 0 , _a ];}else{[ _a , "Acts_CivilHiding_1" ] remoteExec [ "switchMove" , 0 , _a ];};
_a forceWalk false;_a forceSpeed 13;
}];
};
}