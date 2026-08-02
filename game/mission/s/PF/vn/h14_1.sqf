//land_vn_hut_river_01
isNil{params["_b"];
private _dir=getDir _b;
private _bag=createSimpleObject["vn\vn_structures_f\civ\market\vn_sack_f.p3d",[0,0,0]];
private _bkt=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_basket_ep1.p3d",[0,0,0]];
private _bkt2=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_04.p3d",[0,0,0]];
private _bowl=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_01.p3d",[0,0,0]];
private _pilo=createSimpleObject["A3\Structures_F\Civ\Camping\Pillow_old_F.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
private _tire=createSimpleObject["vn\vn_structures\nav_pier\vn_nav_pier_pneu.p3d",[0,0,0]];
_b setVariable["PF",[_bag,_bkt,_bkt2,_bowl,_pilo,_rug,_tire]];

_bag setPos(_b modelToWorld[-2.3,-7.74,3.42]);
_bag setDir _dir+15;

_bkt setPos(_b modelToWorld[-4.56,-7.7,4.055]);
_bkt setDir _dir+77;

_bkt2 setPos(_b modelToWorld[-5.64,-6.5,3.381]);
_bkt2 setDir _dir+77;

_bowl setPos(_b modelToWorld[-2.2,-7.15,3.384]);

_pilo setPos(_b modelToWorld[-2.3,-5.3,3.435]);
_pilo setDir _dir+298;

_rug setPos(_b modelToWorld[-2.65,-6,3.3683]);
_rug setDir _dir+298;

_tire setPos(_b modelToWorld[-1.85,-10.145,3.819]);
_tire setDir _dir+268;
}