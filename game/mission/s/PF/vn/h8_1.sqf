//Land_vn_hut_08
isNil{params["_b"];
_dir=getDir _b;
private _box=createSimpleObject["A3\Props_F_Orange\Humanitarian\Supplies\PaperBox_01_small_ransacked_F.p3d",[0,0,0]];
private _bag=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_sack_ep1.p3d",[0,0,0]];
private _can=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_us_fort_common_can_01.p3d",[0,0,0]];
private _can2=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_us_fort_common_can_04.p3d",[0,0,0]];
private _can3=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_us_fort_common_can_03.p3d",[0,0,0]];
private _fak=createSimpleObject["vn\characters_f_vietnam\OPFOR\vests\items\vn_o_item_firstaid_01.p3d",[0,0,0]];
private _jug=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pot_02.p3d",[0,0,0]];
private _pot=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pot_04.p3d",[0,0,0]];
private _sack=createSimpleObject["vn\vn_structures_f\civ\market\vn_sack_f.p3d",[0,0,0]];
private _wall=createSimpleObject["vn\structures_f_vietnam\civ\fences\vn_fence_wooden_01_03.p3d",[0,0,0]];
_b setVariable["PF",[_box,_bag,_can,_can2,_can3,_fak,_jug,_pot,_sack,_wall]];

_bag setPos(_b modelToWorld[-0.07, 2.28, 1.1]);
_bag setDir(_dir-95);

_box setPos(_b modelToWorld[-0.2, 2.27, 1.46]);
_box setDir(_dir-5);

_can setPos(_b modelToWorld[-0.32, 2.35, 1.07]);

_can2 setPos(_b modelToWorld[-0.45, 2.327, 1.07]);

_can3 setPos(_b modelToWorld[-0.39, 2.4, 1.07]);

_fak setPos(_b modelToWorld[-0.37, 2.21, 1.08]);
_fak setDir(_dir+65);

_pot setPos(_b modelToWorld[0.3, -2.43, 1.3]);

_jug setPos(_b modelToWorld[0.76, -2.37, 1.32]);

_sack setPos(_b modelToWorld[2.6, -1.3, 1.42]);
_sack setDir _dir;

_wall setPos(_b modelToWorld[-0.6, -1.78, 2.1]);
_wall setDir(_dir+270);
if(floor random 11==5)then{[_b,"vill"]call PF_snd};
}