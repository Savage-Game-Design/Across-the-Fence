//Land_vn_hut_01
isNil{params["_b"];
_b setVariable["PF",[]];
if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B","h1_1b"]};
private _dir = getDir _b;

private _bkt=createSimpleObject["Land_vn_plasticbucket_01_open_f",[0,0,0]];
private _bowl=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_01.p3d",[0,0,0]];
private _box=createSimpleObject["vn\vn_structures_e\misc\misc_market\vn_crates_stack_ep1.p3d",[0,0,0]];
private _cloth=createSimpleObject["vn\vn_structures_f_exp_04\civilian\accessories\vn_clothesline_01_short_f.p3d",[0,0,0]];
private _desk=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bar\vn_bar_01_table_01.p3d",[0,0,0]];
private _junk=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_square3_f.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
private _rug2=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
private _sack=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_sack_ep1.p3d",[0,0,0]];
private _wood=createSimpleObject["a3\structures_f\civ\accessories\woodpile_f.p3d",[0,0,0]];
{(_b getVariable"PF")pushBack _x}forEach[_bkt,_bowl,_box,_cloth,_desk,_junk,_rug,_rug2,_sack,_wood];

_bkt setPos(_b modelToWorld[-1,3.3,1.74]);

_bowl setPos(_b modelToWorld[-0.898,-1.5,1.758]);

_box setPos(_b modelToWorld[-0.906,0.5,1.296]);
_box setDir _dir;

_cloth setPos(_b modelToWorld[1.92,0.67,5]);
_cloth setDir(_dir+90);

_desk setPos(_b modelToWorld[-0.898,-1.3,1.3]);
_desk setDir _dir;

_junk setPos(_b modelToWorld[0.7,-0.5,1.395]);
_junk setDir _dir;

_sack setPos(_b modelToWorld[-0.898,-0.35,1.3]);

_wood setPos(_b modelToWorld[2.31,-1.14,1.88]);
_wood setDir _dir;

_rug setPos(_b modelToWorld[0,2,1.277]);
_rug setDir (_dir+7);

_rug2 setPos(_b modelToWorld[0.8,2.8,1.277]);
_rug2 setDir (_dir+33);
}