//Land_vn_b_trench_bunker_04_01
isNil{params["_b"];
/*	Client-side version
	private _a="B_Survivor_F"createVehicleLocal[0,0,0];
	_a allowDamage false;_a disableAI"all";
	_a switchMove(selectRandom["Acts_Rifle_Operations_Front","Acts_Rifle_Operations_Left","Acts_Rifle_Operations_Right","AidlPercMstpSlowWrflDnon_G01"]);
	_a addEventHandler["AnimDone",{_this#0 switchMove(selectRandom["Acts_Rifle_Operations_Front","Acts_Rifle_Operations_Left","Acts_Rifle_Operations_Right","AidlPercMstpSlowWrflDnon_G01"])}];
*/
private _dir=getDir _b;
private _a = createVehicle["B_Soldier_VR_F",[0,0,0],[],0,"can_collide"];
private _box=createSimpleObject["vn\objects_f_vietnam\supply\a2_ammo\macv\vn_us_ammo",[0,0,0]];
private _box2=createSimpleObject["vn\objects_f_vietnam\supply\a2_ammo\macv\vn_us_ammo",[0,0,0]];
private _box3=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_us_fort_common_crate_01.p3d",[0,0,0]];
private _gun=createSimpleObject["vn\weapons_f_vietnam\m60\vn_m60_prop.p3d",[0,0,0]];
_b setVariable["PF",[_a,_box,_box2,_box3,_gun]];
_a disableAI"all";
_a setCaptive true;
_a setUnitLoadout[["vn_m60","","","",["vn_m60_100_mag",18],[],""],[],[],["vn_b_uniform_macv_04_01",[["vn_b_item_firstaidkit",2],["vn_m60_100_mag",5,18]]],["vn_b_vest_usarmy_06",[["vn_m60_100_mag",11,18]]],[],"vn_b_helmet_m1_08_01","",[],["","","","","",""]];
private _face=selectRandom baseFaces;
[_a,_face]remoteExecCall["setFace",0,_a];


_a setDir(_dir+90);
_a setPos(_b modelToWorld[4.6,0,0.7]);
{_a enableAI _x}forEach["aimingerror","anim","autocombat","checkvisible","move","target","teamSwitch","weaponaim"];

_a addEventHandler["Killed",{
params["_a"];
_a removeMagazines"vn_m60_100_mag";
_a removeItems"vn_b_item_firstaidkit";
_a removeWeapon(primaryWeapon _a);
private _wh=nearestObjects[_a,["GroundWeaponHolder","WeaponHolderSimulated"],3,false];
{deleteVehicle _x}forEach _wh;
}];

_box setPos(_b modelToWorld[5.5,-0.4,0.682]);
_box setDir(_dir+85);

_box2 setPos(_b modelToWorld[5.47,-0.4,1.125]);
_box2 setDir(_dir-90);

_box3 setPos(_b modelToWorld[5.63,-0.4,1.58]);
_box3 setDir _dir;

_gun setPos(_b modelToWorld[5.71,-0.4,1.797]);
_gun setDir(_dir+180);
}