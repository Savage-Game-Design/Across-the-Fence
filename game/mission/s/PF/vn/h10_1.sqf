//Land_vn_hut_village_02
isNil{params["_b"];
_dir=getDir _b;
private _bag=createSimpleObject["Land_vn_foodsack_01_dmg_brown_f",[0,0,0]];
private _bench=createSimpleObject["vn\objects_f_vietnam\usarmy\furniture\vn_us_common_bench_01.p3d",[0,0,0]];
private _box=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_crates_ep1.p3d",[0,0,0]];
private _can=createSimpleObject["A3\Structures_F\Items\Vessels\CanisterPlastic_F.p3d",[0,0,0]];
private _cloth=createSimpleObject["vn\vn_structures_f_exp_04\civilian\accessories\vn_clothesline_01_short_f.p3d",[0,0,0]];
private _food=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_basket_ep1.p3d",[0,0,0]];
private _jug=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pot_02.p3d",[0,0,0]];
private _junk=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_square5_f.p3d",[0,0,0]];
private _junk2=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_square3_f.p3d",[0,0,0]];
private _junk3=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_line_f.p3d",[0,0,0]];
private _pan=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pan_02.p3d",[0,0,0]];
private _pot=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pot_01.p3d",[0,0,0]];
private _rack=createSimpleObject["vn\vn_structures_f_epb\furniture\vn_shelveswooden_f.p3d",[0,0,0]];
private _rice=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_wicker_basket_ep1.p3d",[0,0,0]];
private _sack=createSimpleObject["vn\vn_structures_f\civ\market\vn_sack_f.p3d",[0,0,0]];
private _tool=createSimpleObject["A3\Structures_F_EPA\Items\Tools\Shovel_F.p3d",[0,0,0]];
_b setVariable["PF",[_bag,_bench,_box,_can,_cloth,_food,_jug,_junk,_junk2,_junk3,_pan,_pot,_rack,_rice,_sack,_tool]];

_bag setPos(_b modelToWorld[2,-1.16,-1.25]);
_bag setDir(_dir+60);

_bench setPos(_b modelToWorld[-1.6,3.75,-1.4]);
_bench setDir(_dir+182);

_box setPos(_b modelToWorld[2.02,-1.148,0]);
_box setDir(_dir+5);

_can setPos(_b modelToWorld[1.3,-1,-0.748]);
_can setDir(_dir+80);

_cloth setPos(_b modelToWorld[-1.81,2.63,1.73]);
_cloth setDir(_dir+9.701);

_food setPos(_b modelToWorld[-2.67,3.65,-0.719]);
_food setDir(_dir+29);

_junk setPos(_b modelToWorld[2.4,1.6,-1.324]);
_junk setDir _dir;

_junk2 setPos(_b modelToWorld[2.3,-2.45,-1.343]);
_junk2 setDir _dir;

_junk3 setPos(_b modelToWorld[3.9,1.3,-1.307]);
_junk3 setDir _dir;

_pot setPos(_b modelToWorld[2.9,3.2,-1.413]);
_pot setDir(_dir+90);

_pan setPos(_b modelToWorld[-2.67,3,-1.408]);
_pan setDir(_dir+29);

_rack setPos(_b modelToWorld[2.03,-1.057,-1.42]);
_rack setDir(_dir+90);

_rack setPos(_b modelToWorld[2.03,-1.057,-1.42]);
_rack setDir(_dir+90);

_rice setPos(_b modelToWorld[-2.67,3,-2.237]);

_tool setPos(_b modelToWorld[2.03,-1.057,-0.766]);
_tool setDir(_dir+73);
if(floor random 11==5)then{[_b,"vill"]call PF_snd};
}