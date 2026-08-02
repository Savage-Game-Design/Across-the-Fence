//Land_vn_hut_01
isNil{params["_b"];
_b setVariable["PF",[]];
if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B","h1_1c"]};
private _dir = getDir _b;

private _bag=createSimpleObject["Land_vn_foodsacks_01_small_brown_f",[0,0,0]];
private _bkt=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_04.p3d",[0,0,0]];
private _bkt2=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_04.p3d",[0,0,0]];
private _bkt3=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_04.p3d",[0,0,0]];
private _box=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_crates_ep1.p3d",[0,0,0]];
private _food=createSimpleObject["vn\vn_structures_f\civ\market\vn_sacks_goods_f.p3d",[0,0,0]];
private _rice=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_wicker_basket_ep1.p3d",[0,0,0]];
private _sack=createSimpleObject["vn\vn_structures_f\civ\market\vn_sacks_heap_f.p3d",[0,0,0]];
private _sack2=createSimpleObject["vn\vn_structures_f\civ\market\vn_sack_f.p3d",[0,0,0]];
_b setVariable["PF",[_bag,_bkt,_bkt2,_bkt3,_box,_food,_rice,_sack,_sack2]];

_bag setPos(_b modelToWorld[1.6,3.4,1.73]);
_bag setDir _dir;

_bkt setPos (_b modelToWorld[-1.04,2.3,1.3]);
_bkt setDir (_dir+60);

_bkt2 setPos (_b modelToWorld[-0.8,3.25,1.3]);
_bkt2 setDir (_dir+80);

_bkt3 setPos (_b modelToWorld[-0.33,3.4,1.3]);
_bkt3 setDir (_dir-40);

_box setPos(_b modelToWorld[2.31,0.47,1.762]);
_box setDir (_dir+76);

_food setPos(_b modelToWorld[-0.45,-1.675,1.33]);
_food setDir _dir;

_rice setPos (_b modelToWorld[-0.95,1.5,1.305]);

_sack setPos(_b modelToWorld[-0.45,-0.28,1.33]);
_sack setDir (_dir+20);

_sack2 setPos(_b modelToWorld[0.84,3.43,1.335]);
_sack2 setDir (_dir-38);
}