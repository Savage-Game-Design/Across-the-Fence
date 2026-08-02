//land_vn_hut_07
isNil{params["_b"];
if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B","h7_1b"]};
private _dir=getDir _b;
private _ash=createSimpleObject["vn\objects_f_vietnam\civ\ashtray\vn_prop_ashtray_02.p3d",[0,0,0]];
private _bag=createSimpleObject["Land_vn_foodsack_01_empty_brown_f",[0,0,0]];
private _bag2=createSimpleObject["Land_vn_foodsack_01_dmg_brown_f",[0,0,0]];
private _bag3=createSimpleObject["Land_vn_foodsack_01_full_brown_f",[0,0,0]];
private _box=createSimpleObject["vn\vn_misc\vn_drevena_bedna.p3d",[0,0,0]];
private _desk=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bar\vn_bar_01_table_01.p3d",[0,0,0]];
private _food=createSimpleObject["vn\vn_structures_f\civ\market\vn_sacks_goods_f.p3d",[0,0,0]];
private _junk=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_line_f.p3d",[0,0,0]];
private _leaf=createSimpleObject["vn\vn_vegetation_f_exp\clutter\red_dirt\vn_c_red_dirt_leaves.p3d",[0,0,0]];
private _leaf2=createSimpleObject["vn\vn_vegetation_f_enoch\clutter\vn_c_leaves_dead.p3d",[0,0,0]];
private _rice=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_wicker_basket_ep1.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_b_prop_rugs_01.p3d",[0,0,0]];
private _wood=createSimpleObject["vn\vn_plants_f\clutter\vn_c_rubble_clutter4.p3d",[0,0,0]];
_b setVariable["PF",[_ash,_bag,_bag2,_bag3,_box,_desk,_food,_junk,_leaf,_leaf2,_rice,_rug,_wood]];

_ash setPos(_b modelToWorld[-3,2.8,1.404]);

_bag setPos(_b modelToWorld[2.4,1.1,1.03]);
_bag setDir _dir+30.011;

_bag2 setPos(_b modelToWorld[2,1,1.125]);
_bag2 setDir _dir+354.739;

_bag3 setPos(_b modelToWorld[2,1,1.25]);
_bag3 setDir _dir+9.390;

_box setPos(_b modelToWorld[3.81,-0.5,1]);
_box setDir _dir;

_desk setPos(_b modelToWorld[-3.25,2.4,0.95]);
_desk setDir _dir;

_food setPos(_b modelToWorld[0.85,4.76,1]);
_food setDir _dir+283.849;

_junk setDir _dir+90;

_leaf setPos(_b modelToWorld[-1.4,-1,1]);
_leaf setDir _dir;

_leaf2 setPos(_b modelToWorld[-0.6,-1.1,1.03]);
_leaf2 setDir _dir;

_rug setPos(_b modelToWorld[-2.2,2.4,0.95]);
_rug setDir _dir;

_wood setPos(_b modelToWorld[0.5,-1.13,1]);
_wood setDir _dir+169.373;
}