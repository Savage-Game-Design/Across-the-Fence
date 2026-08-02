//Land_vn_hut_06
isNil{params["_b"];
_dir=getDir _b;
private _bag=createSimpleObject["Land_vn_foodsack_01_empty_brown_f",[0,0,0]];
private _box=createSimpleObject["vn\vn_structures_e\misc\misc_market\vn_crates_stack_ep1.p3d",[0,0,0]];
private _chair=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_us_common_bench_01.p3d",[0,0,0]];
private _desk=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bar\vn_bar_01_table_01.p3d",[0,0,0]];
private _junk=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_square3_f.p3d",[0,0,0]];
private _food=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_sack_ep1.p3d",[0,0,0]];
private _tea=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pot_03.p3d",[0,0,0]];
private _pot=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pan_03.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
_b setVariable["PF",[_bag,_box,_chair,_desk,_junk,_food,_tea,_pot,_rug]];

_bag setPos(_b modelToWorld[0.4,0.4,1.49]);
_bag setDir(_dir+20);

_box setPos(_b modelToWorld[3.12,-0.8,1.49]);
_box setDir _dir;

_chair setPos(_b modelToWorld[1.5,3.78,1.415]);
_chair setDir(_dir-5);

_desk setPos(_b modelToWorld[3.14,3.27,1.415]);
_desk setDir _dir;

_food setPos(_b modelToWorld[2.8,-1.55,1.49]);

_junk setPos(_b modelToWorld[1.9,2.4,1.51]);
_junk setDir _dir;

_pot setPos(_b modelToWorld[2.93,3.5,1.87]);
_pot setDir(_dir+145);

_rug setPos(_b modelToWorld[0.8, 2, 1.4]);
_rug setDir(_dir-5);

_tea setPos(_b modelToWorld[3.08,3,1.87]);
_tea setDir(_dir+265);
if(floor random 11==5)then{[_b,"vill"]call PF_snd};
}