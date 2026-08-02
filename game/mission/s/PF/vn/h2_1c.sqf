//Land_vn_hut_02
isNil{params["_b"];
if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B","h2_1c"]};
private _dir = getDir _b;
private _bkt=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_04.p3d",[0,0,0]];
private _bkt2=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_04.p3d",[0,0,0]];
private _bkt3=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_04.p3d",[0,0,0]];
private _bench=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_us_common_bench_01.p3d",[0,0,0]];
private _cloth=createSimpleObject["vn\vn_structures_f_exp_04\civilian\accessories\vn_clothesline_01_short_f.p3d",[0,0,0]];
private _pan=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_03.p3d",[0,0,0]];
private _rice=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_wicker_basket_ep1.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
private _rug2=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
private _rugs=createSimpleObject["vn\vn_structures_e\misc\misc_market\vn_carpet_rack_ep1.p3d",[0,0,0]];
_b setVariable["PF",[_bench,_bkt,_bkt2,_bkt3,_cloth,_pan,_rice,_rug,_rug2,_rugs]];

_bench setPos(_b modelToWorld[-1.6,-0.37,1.42]);
_bench setDir(_dir-95);

_bkt setPos(_b modelToWorld[-1.24,0.35,1.415]);
_bkt setDir(_dir+100);

_bkt2 setPos(_b modelToWorld[0.66,-1.33,1.415]);
_bkt2 setDir(_dir+84);

_bkt3 setPos(_b modelToWorld[-1.6,3.42,1.415]);
_bkt3 setDir(_dir+10);

_cloth setPos(_b modelToWorld[0,1.66,5]);
_cloth setDir(_dir+307.530);

_rice setPos(_b modelToWorld[-1.55,2.9,1.424]);
_rice setDir(_dir+0);

_rug setPos(_b modelToWorld[-0.8,3.3,1.396]);
_rug setDir(_dir+70);

_rug2 setPos(_b modelToWorld[1,2.65,1.396]);
_rug2 setDir(_dir+100);

_pan setPos(_b modelToWorld[0.4,3.2,1.418]);
_pan setDir(_dir+0);

_rugs setPos(_b modelToWorld[1.375,-0.367,1.47]);
_rugs setDir(_dir-90);
if(floor random 11==5)then{[_b,"vill"]call PF_snd};
}