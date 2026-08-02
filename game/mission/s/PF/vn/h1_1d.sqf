//Land_vn_hut_01
isNil{params["_b"];
_b setVariable["PF",[]];
if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B","h1_1d"]};
_dir=getDir _b;

private _desk=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_table_ep1.p3d",[0,0,0]];
private _chair=createSimpleObject["vn\vn_structures_f\furniture\vn_chairwood_f.p3d",[0,0,0]];
private _chair2=createSimpleObject["vn\vn_structures_f\furniture\vn_chairwood_f.p3d",[0,0,0]];
private _cloth=createSimpleObject["vn\vn_structures_f_exp_04\civilian\accessories\vn_clothesline_01_short_f.p3d",[0,0,0]];
private _jug=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_vase_loam_ep1.p3d",[0,0,0]];
private _junk=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_square5_f.p3d",[0,0,0]];
private _pot=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_vase_loam_2_ep1.p3d",[0,0,0]];
private _rack=createSimpleObject["vn\vn_structures_f_epb\furniture\vn_shelveswooden_f.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\vn_props_f_orange\furniture\vn_rug_01_f.p3d",[0,0,0]];
private _tea=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_teapot_ep1.p3d",[0,0,0]];
private _urn=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_vase_loam_3_ep1.p3d",[0,0,0]];
_b setVariable["PF",[_chair,_chair2,_cloth,_desk,_jug,_junk,_pot,_rack,_rug,_tea,_urn]];

_chair setPos(_b modelToWorld[4.07,-3.65,1.4]);
_chair setDir _dir+165;

_chair2 setPos(_b modelToWorld[3.3,-3.72,1.37]);
_chair2 setDir _dir+185;

_cloth setPos(_b modelToWorld[4.33,0.9,4.27]);
_cloth setDir _dir-90;

_desk setPos(_b modelToWorld[-0.5,-1.35,2.158]);
_desk setDir _dir-15;

_jug setPos(_b modelToWorld[-0.75,3.35,1.305]);

_junk setPos(_b modelToWorld[0.8,1.2,1.36]);
_junk setDir _dir;

_pot setPos(_b modelToWorld[-1,0.2,1.305]);

_rack setPos(_b modelToWorld[-1,0.9,1.305]);
_rack setDir _dir;

_rug setPos(_b modelToWorld[0.8,0.5,1.296]);
_rug setDir(_dir-10);

_tea setPos(_b modelToWorld[-0.9,1.1,2.249]);
_tea setDir _dir+17;

_urn setPos(_b modelToWorld[2.45,2.2,1.305]);
}