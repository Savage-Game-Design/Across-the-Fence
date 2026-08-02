 //Land_vn_b_trench_firing_04
isNil{params["_b","_t"];
_b setVariable["PF",[]];

private _patch = [
["\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f_01_ca.paa","\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f.rvmat"],
[]
];

private _a = "C_Soldier_VR_F"createVehicleLocal[0,0,0];
_b setVariable["PF",[_a]];
_a disableAI"all";
_a allowDamage false;
if(floor random 2==0)then{_a setUnitLoadout[["vn_m60","","","",["vn_m60_100_mag",18],[],""],[],[],["vn_b_uniform_macv_04_01",[["vn_b_item_firstaidkit",2],["vn_m60_100_mag",5,18]]],["vn_b_vest_usarmy_06",[["vn_m60_100_mag",11,18]]],[],"vn_b_helmet_m1_08_01","",[],["","","","","",""]]}else{_a setUnitLoadout[["vn_m16","","","",["vn_m16_20_t_mag",18],[],""],[],[],["vn_b_uniform_macv_04_01",[["vn_b_item_firstaidkit",2],["vn_m16_20_t_mag",5,18]]],["vn_b_vest_usarmy_02",[["vn_m16_20_t_mag",11,18]]],[],"vn_b_helmet_m1_02_01","",[],["","","","","",""]];};
_a setFace (selectRandom baseFaces);
//private _face=selectRandom baseFaces;
//[_a,_face]remoteExecCall["setFace",0,_a];

if (_t isNotEqualTo"land_vn_b_foxhole_01") then
{
	private _r=if(floor random 2==1)then{true}else{false};
	if(_r)then{
		private _anim=selectRandom["Acts_Rifle_Operations_Front","Acts_Rifle_Operations_Left","Acts_Rifle_Operations_Right","AidlPercMstpSlowWrflDnon_G01"];
		//[_a,_anim]remoteExec["switchMove",0,_a];
		_a switchMove _anim;
	};
	
	if(_r)then{
		_a addEventHandler["AnimDone",{
		private _a=_this#0;
		private _anim=selectRandom["Acts_Rifle_Operations_Front","Acts_Rifle_Operations_Left","Acts_Rifle_Operations_Right","AidlPercMstpSlowWrflDnon_G01"];
		//[_a,_anim]remoteExec["switchMove",0,_a];
		_a switchMove _anim;
		}];
	};
};

switch(_t)do
{
	case"land_vn_b_foxhole_01":
	{
		_a setDir(getDir _b+180);
		_a setPos(_b modelToWorld[0,-0.5,0.32]);
	};
	case"land_vn_b_trench_firing_01":
	{
		_a setDir _dir;
		_a setPos(_b modelToWorld[3,0.3,0.68]);
	};
	case"land_vn_b_trench_firing_04":
	{
		_a setDir(getDir _b+90);
		_a setPos(_b modelToWorld[1.89,0,-0.13]);
	};
	case"land_vn_b_trench_firing_05":
	{
		_a setDir(getDir _b+90);
		_a setPos(_b modelToWorld[1.89,0,-0.06]);
	};
};

/*
{_a enableAI _x}forEach["aimingerror","anim","autocombat","checkvisible","move","target","teamSwitch","weaponaim"];

_a addEventHandler["Killed",{
params["_a"];
_a removeMagazines "vn_m16_20_t_mag";
_a removeItems "vn_b_item_firstaidkit";
_a removeWeapon(primaryWeapon _a);
private _wh=nearestObjects[_a,["GroundWeaponHolder","WeaponHolderSimulated"],3,false];
{deleteVehicle _x}forEach _wh;
}];
*/

}