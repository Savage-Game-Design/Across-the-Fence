//Land_vn_hut_07
isNil{params["_b"];
if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B","h7_1a"]};
_dir=getDir _b;
private _bag=createSimpleObject["Land_vn_foodsacks_01_small_brown_f",[0,0,0]];//Land_vn_foodsacks_01_small_brown_f
private _bed=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_carpet_ep1.p3d",[0,0,0]];
private _boot=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_boots_ep1.p3d",[0,0,0]];
private _box=createSimpleObject["vn\vn_structures_e\misc\misc_market\vn_crates_stack_ep1.p3d",[0,0,0]];
private _chair=createSimpleObject[(selectRandom["A3\Structures_F\Furniture\ChairWood_F.p3d","vn\vn_structures_f\furniture\vn_chairwood_f.p3d"]),[0,0,0]];
private _desk=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_table_ep1.p3d",[0,0,0]];
private _junk=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_line_f.p3d",[0,0,0]];
private _food=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_basket_ep1.p3d",[0,0,0]];
private _stool=createSimpleObject["vn\vn_structures_f\furniture\vn_bench_f.p3d",[0,0,0]];
private _pilo=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_pillow_ep1.p3d",[0,0,0]];
_b setVariable["PF",[_bag,_bed,_boot,_box,_chair,_desk,_junk,_food,_stool,_pilo]];

_bag setPos(_b modelToWorld[3.8,-1.39,1.38]);
_bag setDir(_dir+13);

_bed setPos(_b modelToWorld[-2,3.4,1.02]);
_bed setDir(_dir-20);

_boot setPos(_b modelToWorld[-0.09,1.3,1.087]);
_boot setDir _dir;

_box setPos(_b modelToWorld[0.116,5.16,0.95]);
_box setDir(_dir+90);

_chair setPos(_b modelToWorld[1.6,-1.5,0.991]);
_chair setDir(_dir+20);

_desk setPos(_b modelToWorld[3.4,4.7,1.81]);
_desk setDir(_dir+180);

_food setPos(_b modelToWorld[4,-0.23,1.58]);

_junk setPos(_b modelToWorld[0.8,0.91,1.085]);
_junk setDir _dir;

_stool setPos(_b modelToWorld[-0.09,1.3,1.43]);
_stool setDir _dir;

_pilo setPos(_b modelToWorld[-2.4,4.5,0.93]);
_pilo setDir(_dir-20);
if(floor random 11==5)then{[_b,"vill"]call PF_snd};
}