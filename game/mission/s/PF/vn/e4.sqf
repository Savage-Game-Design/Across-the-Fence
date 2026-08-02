//vn_rice_plant_sapling_02.p3d ~ vn_rice_plant_med_02.p3d
isNil{params["_b","_t","_id"];

if(floor random 4>0)exitWith{};
private _i = ( PF_MapObjs findIf { _id isEqualTo (_x#1) } );


//for"_x"from 0 to(floor random 3+1)do{
private _c=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
_c disableAI"all";

( ( PF_MapObjs # _i ) # 2 ) pushBack _c;

{_c call _x}forEach[civF,civH,civU,civG];
if(floor random 2==1)then{_c addBackpack "vn_c_pack_01"};
_c addHeadgear ( selectRandom [ "vn_c_conehat_01" , "vn_c_conehat_02"] );
_c enableStamina false;

if(_t in["vn_rice_plant_sapling_02.p3d","vn_rice_plant_med_02.p3d"])then
{
	_c setPos(_b modelToWorld [ ( selectRandom [ random 4.5 , random -4.5 ] ) , ( selectRandom [ random 4.5 , random -4.5 ] ) , -1 ]);
}else{
	_c setPos(_b modelToWorld [ ( selectRandom [ random 2.5 , random -2.5 ] ) , ( selectRandom [ random 2.5 , random -2.5 ] ) , -1 ]);
};

_c setDir(getDir _b+(selectRandom[0,180]));
_c setDamage 0;

private _anim=selectRandom["AinvPknlMstpSnonWnonDnon_medic_1","AinvPknlMstpSnonWnonDnon_medic_2"];
[_c,_anim]remoteExec["switchMove",0,_c];

_c addEventHandler["Killed",{params["_a"];_a removeAllEventHandlers"AnimDone";_a removeAllEventHandlers"FiredNear";}];


if(floor random 2==0)then{
	private _anim=selectRandom["AinvPknlMstpSnonWnonDnon_medic0","AinvPknlMstpSnonWnonDnon_medic1","AinvPknlMstpSnonWnonDnon_medic2","AinvPknlMstpSnonWnonDnon_medic3","AinvPknlMstpSnonWnonDnon_medic4","AinvPknlMstpSnonWnonDnon_medic5"];
	[_c,_anim]remoteExec["switchMove",0,_c];

	_c addEventHandler["AnimDone",{
	private _c=_this#0;
	if(!alive _c)exitWith{_c removeEventHandler["AnimDone",_thisEventHandler];};
	private _anim=selectRandom["AinvPknlMstpSnonWnonDnon_medic0","AinvPknlMstpSnonWnonDnon_medic1","AinvPknlMstpSnonWnonDnon_medic2","AinvPknlMstpSnonWnonDnon_medic3","AinvPknlMstpSnonWnonDnon_medic4","AinvPknlMstpSnonWnonDnon_medic5"];
	[_c,_anim]remoteExec["switchMove",0,_c];
	}];
}else{
	private _anim=selectRandom["AinvPknlMstpSnonWnonDnon_medic_1","AinvPknlMstpSnonWnonDnon_medic_2"];
	[_c,_anim]remoteExec["switchMove",0,_c];

	_c addEventHandler["AnimDone",{
	private _c=_this#0;
	if(!alive _c)exitWith{_c removeEventHandler["AnimDone",_thisEventHandler];};
	private _anim=selectRandom["AinvPknlMstpSnonWnonDnon_medic_1","AinvPknlMstpSnonWnonDnon_medic_2"];
	[_c,_anim]remoteExec["switchMove",0,_c];
	}];
};

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
//};
/*
private _yum=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_wicker_basket_ep1.p3d",[0,0,0]];
private _bkt=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_basket_ep1.p3d",[0,0,0]];

_yum setPos(_c modelToWorld[0.5,-0.5,0.70]);
_bkt setPos(_c modelToWorld[-0.5,-0.5,1]);

( ( PF_MapObjs # _i ) # 2 ) pushBack _yum;
( ( PF_MapObjs # _i ) # 2 ) pushBack _bkt;

_yum setDir (random 359);
_bkt setDir (getDir _yum);
*/
}