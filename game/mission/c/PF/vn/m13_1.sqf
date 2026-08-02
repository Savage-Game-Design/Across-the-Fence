//Land_vn_guardhouse_01
isNil{params["_b"];
_b setVariable["PF",[]];
private _dir=getDir _b;

private _patch = [
["\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f_01_ca.paa","\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f.rvmat"],
[]
];

private _a="C_Soldier_VR_F"createVehicleLocal[0,0,0];
_b setVariable["PF",[_a]];
_a disableAI"all";
_a setCaptive true;
_a allowDamage false;
_a setUnitLoadout[["vn_m16","","","",["vn_m16_20_t_mag",18],[],""],[],[],["vn_b_uniform_macv_04_01",[["vn_b_item_firstaidkit",2],["vn_m16_20_t_mag",5,18]]],["vn_b_vest_usarmy_02",[["vn_m16_20_t_mag",11,18]]],[],"vn_b_helmet_m1_02_01","",[],["","","","","",""]];
private _face=selectRandom baseFaces;
[_a,_face]remoteExecCall["setFace",0,_a];

_a setDir _dir;
_a setPosATL(_b buildingPos 2);
{_a enableAI _x}forEach[ "anim" , "move" , "path" , "teamSwitch" ];
_a setBehaviour"careless";

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