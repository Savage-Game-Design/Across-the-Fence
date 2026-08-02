//Land_vn_pen_village_01
/*	TODO:
		1. Remotely create animals, execFSM on each player (Animal animations & sounds are client-side?)
*/
isNil{params["_b","_t","_id"];
_dir=getDir _b;
_b setVariable["PF",[]];

private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );

for"_x"from 0 to(random 3+3)do{
private _c=createAgent["Cock_random_F",[0,0,0],[],0,"can_collide"];
_c setVariable["BIS_fnc_animalBehaviour_disable",true];
_c disableAI"FSM";
_c setDir(random 359);
_c setPos(_b getPos[2.5,random 359]);
( ( PF_MapObjs # _i ) # 2 ) pushBack _c;
};

PF_Ambient pushBack [ _b , _id , ( ( PF_MapObjs # _i ) # 2 ) ];
[_b,"chk"]call PF_snd;
}