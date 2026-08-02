//land_vn_b_trench_bunker_05_02
isNil{params["_b"];
_b setVariable["PF",[]];
private _dir=getDir _b;

private _patch = [
["\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f_01_ca.paa","\vn\characters_f_vietnam\common\insignia\vn_b_insignia_75_ranger_f.rvmat"],
[]
];

private _anims = ["UnconsciousReviveDefault_C","passenger_injured_medevac_truck03"];
private _anim = selectRandom _anims;

private _a = "vn_b_men_army_28"createVehicleLocal[0,0,0];
_a disableAI"all"; 
_a allowDamage false;
_a setUnitLoadout[[],[],[],[],[],[],"","",[],["","","","","",""]];
_a switchMove _anim;
_a setMimic"unconscious";
_a setFace(selectRandom baseFaces);
_a enableSimulation false;
if(_anim isEqualTo _anims#0)then{_a setDir _dir+180}else{_a setDir _dir};
_a setPos(_b modelToWorld[0.5,-1.2,-0.4]);

}