//Land_vn_hut_05
isNil{params["_b"];
_dir=getDir _b;
private _cloth=createSimpleObject["vn\vn_structures_f_exp_04\civilian\accessories\vn_clothesline_01_short_f.p3d",[0,0,0]];
private _food=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_wicker_basket_ep1.p3d",[0,0,0]];
private _food2=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_basket_ep1.p3d",[0,0,0]];
private _jug=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_04.p3d",[0,0,0]];
private _rugs=createSimpleObject["vn\vn_structures_e\misc\misc_market\vn_carpet_rack_ep1.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
private _rug2=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
_b setVariable["PF",[_cloth,_food,_food2,_jug,_rugs,_rug,_rug2,_rug2]];

_cloth setPos(_b modelToWorld[-0.3, -1, 4.8]);
_cloth setDir(_dir+53.921);

_food setPos(_b modelToWorld[1.24, 2.38, 1.3]);

_food2 setPos(_b modelToWorld[-1.6, -3, 1.973]);

_jug setPos(_b modelToWorld[0.65, 2.4, 1.27]);
_jug setDir(_dir+45);

_rugs setPos(_b modelToWorld[-1.48, 1.25, 1.32]);
_rugs setDir(_dir+90);

_rug setPos(_b modelToWorld[0.7, 0.5, 1.28]);
_rug setDir(_dir+105);

_rug2 setPos(_b modelToWorld[-1, -1.5, 1.28]);
_rug2 setDir(_dir+70);
if(floor random 11==5)then{[_b,"vill"]call PF_snd};
}