//Land_vn_b_tower_01
isNil{params["_b"];
/*	Client-side version
	private _a="B_Survivor_F"createVehicleLocal[0,0,0];
	_a allowDamage false;_a disableAI"all";
	_a switchMove(selectRandom["Acts_Rifle_Operations_Front","Acts_Rifle_Operations_Left","Acts_Rifle_Operations_Right","AidlPercMstpSlowWrflDnon_G01"]);
	_a addEventHandler["AnimDone",{_this#0 switchMove(selectRandom["Acts_Rifle_Operations_Front","Acts_Rifle_Operations_Left","Acts_Rifle_Operations_Right","AidlPercMstpSlowWrflDnon_G01"])}];
*/

private _a = createVehicle["B_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
_b setVariable["PF",[_a]];
_a disableAI"all";
_a setCaptive true;
_a setUnitLoadout[["vn_m16","","","",["vn_m16_20_t_mag",18],[],""],[],[],["vn_b_uniform_macv_04_01",[["vn_b_item_firstaidkit",2],["vn_m16_20_t_mag",5,18]]],["vn_b_vest_usarmy_02",[["vn_m16_20_t_mag",11,18]]],[],"vn_b_helmet_m1_02_01","",[],["","","","","",""]];
private _face=selectRandom baseFaces;
[_a,_face]remoteExecCall["setFace",0,_a];

private _r=if(floor random 2==1)then{true}else{false};
if(_r)then{
private _anim=selectRandom["Acts_Rifle_Operations_Front","Acts_Rifle_Operations_Left","Acts_Rifle_Operations_Right","AidlPercMstpSlowWrflDnon_G01"];
[_a,_anim]remoteExec["switchMove",0,_a];
};


_a setDir(getDir _b);
_a setPos(_b modelToWorld[0,0.2,1.85]);
{_a enableAI _x}forEach["aimingerror","anim","autocombat","checkvisible","move","target","teamSwitch","weaponaim"];

if(_r)then{
_a addEventHandler["AnimDone",{
private _a=_this#0;
private _anim=selectRandom["Acts_Rifle_Operations_Front","Acts_Rifle_Operations_Left","Acts_Rifle_Operations_Right","AidlPercMstpSlowWrflDnon_G01"];
[_a,_anim]remoteExec["switchMove",0,_a];
}];
};

_a addEventHandler["Killed",{
params["_a"];
_a removeAllEventHandlers"AnimDone";
_a removeMagazines "vn_m16_20_t_mag";
_a removeItems "vn_b_item_firstaidkit";
_a removeWeapon(primaryWeapon _a);
private _wh=nearestObjects[_a,["GroundWeaponHolder","WeaponHolderSimulated"],3,false];
{deleteVehicle _x}forEach _wh;
}];}