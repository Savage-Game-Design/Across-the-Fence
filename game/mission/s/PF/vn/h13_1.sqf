//land_vn_hut_mont_02
isNil{params["_b"];
private _dir=getDir _b;
private _bench=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_us_common_bench_01.p3d",[0,0,0]];
private _dagr=createSimpleObject["vn\characters_f_vietnam\OPFOR\vests\items\vn_o_item_vc_knife_02.p3d",[0,0,0]];
private _jug=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_vase_loam_2_ep1.p3d",[0,0,0]];
private _jug2=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_vase_loam_3_ep1.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_carpet_ep1.p3d",[0,0,0]];
private _rug2=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_carpet_ep1.p3d",[0,0,0]];
private _rug3=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_carpet_ep1.p3d",[0,0,0]];
private _rug4=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_carpet_ep1.p3d",[0,0,0]];
private _rug5=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_b_prop_rugs_02.p3d",[0,0,0]];
private _rugs=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_blankets_ep1.p3d",[0,0,0]];
private _shoe=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_boots_ep1.p3d",[0,0,0]];
private _shoe2=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_boots_ep1.p3d",[0,0,0]];
private _urn=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_vase_loam_ep1.p3d",[0,0,0]];
private _wax=createSimpleObject["vn\objects_f_vietnam\civ\furniture\candle\vn_candle_01.p3d",[0,0,0]];
private _wax2=createSimpleObject["vn\objects_f_vietnam\civ\furniture\candle\vn_candle_01.p3d",[0,0,0]];
_b setVariable["PF",[_bench,_dagr,_jug,_jug2,_rug,_rug2,_rug3,_rug4,_rug5,_rugs,_shoe,_shoe2,_urn,_wax,_wax2]];

_bench setPos(_b modelToWorld[6.4,0.9,0.417]);
_bench setDir _dir+90;

_dagr setPos(_b modelToWorld[6.4,0.3,0.829]);
_dagr setDir _dir+112;

_jug setPos(_b modelToWorld[6.4,-0.1,0.417]);

_jug2 setPos(_b modelToWorld[6.4,1.95,0.417]);

_rug setPos(_b modelToWorld[2,-0.1,0.54]);
_rug setDir _dir+90;

_rug2 setPos(_b modelToWorld[2,1.8,0.54]);
_rug2 setDir _dir+90;

_rug3 setPos(_b modelToWorld[-1.5,1.8,0.54]);
_rug3 setDir _dir+90;

_rug4 setPos(_b modelToWorld[-1.5,-0.1,0.54]);
_rug4 setDir _dir+90;

_rug5 setPos(_b modelToWorld[5.3,0.9,0.42]);
_rug5 setDir _dir;

_rugs setPos(_b modelToWorld[-0.8,3.4,1.1]);
_rugs setDir _dir;

_shoe setPos(_b modelToWorld[-2.82,3.8,0.554]);
_shoe setDir _dir+90;

_shoe2 setPos(_b modelToWorld[-2.13,3.55,0.554]);
_shoe2 setDir _dir+80;

_urn setPos(_b modelToWorld[6.4,0.9,0.832]);

_wax setPos(_b modelToWorld[5.9,1.7,0.42]);

_wax2 setPos(_b modelToWorld[5.9,0.1,0.42]);
}