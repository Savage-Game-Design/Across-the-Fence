//Land_vn_hut_village_01
isNil{params["_b"];
_dir=getDir _b;
private _bag=createSimpleObject["Land_vn_foodsacks_01_small_brown_f",[0,0,0]];
private _bed=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
private _bed2=createSimpleObject["vn\objects_f_vietnam\civ\furniture\bedrag\vn_bedrag_01.p3d",[0,0,0]];
private _bench=createSimpleObject["vn\vn_structures_f_exp_04\civilian\accessories\vn_bench_05_f.p3d",[0,0,0]];
private _cart=createSimpleObject["vn\vn_structures_f\civ\constructions\vn_wheelcart_f.p3d",[0,0,0]];
private _cage=createSimpleObject["A3\Structures_F\Civ\Market\Cages_F.p3d",[0,0,0]];
private _desk=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_table_ep1.p3d",[0,0,0]];
private _door=createSimpleObject["vn\vn_structures_f_exp\walls\wooden\vn_woodenwall_01_m_d_f.p3d",[0,0,0]];
private _door2=createSimpleObject["vn\vn_structures_f_exp\walls\wooden\vn_woodenwall_01_m_d_f.p3d",[0,0,0]];
private _food=createSimpleObject["\vn\vn_structures_f\civ\market\vn_sacks_goods_f.p3d",[0,0,0]];
private _junk=createSimpleObject["vn\vn_props_f_exp\civilian\garbage\vn_garbageheap_02_f.p3d",[0,0,0]];
private _junk2=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_square3_f.p3d",[0,0,0]];
private _junk3=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_line_f.p3d",[0,0,0]];
private _pan=createSimpleObject["vn\objects_f_vietnam\civ\baskets\vn_c_prop_basket_01.p3d",[0,0,0]];
private _pilo=createSimpleObject["A3\Structures_F\Civ\Camping\Pillow_old_F.p3d",[0,0,0]];
private _pilo2=createSimpleObject["A3\Structures_F\Civ\Camping\Pillow_old_F.p3d",[0,0,0]];
_b setVariable["PF",[_bag,_bed,_bed2,_bench,_cart,_cage,_desk,_door,_door2,_food,_junk,_junk2,_junk3,_pan,_pilo,_pilo2]];

_bag setPos(_b modelToWorld[0,3.03,-0.478]);
_bag setDir(_dir+204);

_bed setPos(_b modelToWorld[-4.7,1.4,-1.528]);
_bed setDir(_dir-15);

_bed2 setPos(_b modelToWorld[-3.4,2.8,-1.533]);
_bed2 setDir(_dir+33);

_bench setPos(_b modelToWorld[-2.5,0.46,-1.15]);
_bench setDir(_dir-2);

_cage setPos(_b modelToWorld[-5.02,-0.1,-0.143]);
_cage setDir(_dir+270);

_cart setPos(_b modelToWorld[0.3,2.9,-0.78]);
_cart setDir(_dir-65);

_desk setPos(_b modelToWorld[1.93,-1.88,-0.649]);
_desk setDir(_dir+270);

_door setPos(_b modelToWorld[-1.84,-2.27,0.29]);
_door setDir(_dir+215);

_door2 setPos(_b modelToWorld[4.21,-2.339,0.29]);
_door2 setDir(_dir+160);

_food setPos(_b modelToWorld[3.84,2.93,-1.52]);
_food setDir(_dir+329.659);

_junk setPos(_b modelToWorld[-2.9,-1.4,-1.178]);
_junk setDir(_dir+170);

_junk2 setPos(_b modelToWorld[2,0,-1.42]);
_junk2 setDir _dir;

_junk3 setPos(_b modelToWorld[1.6,1.3,-1.424]);
_junk3 setDir(_dir+90);

_pilo setPos(_b modelToWorld[-5.3,1.3,-1.447]);
_pilo setDir(_dir+65 );

_pilo2 setPos(_b modelToWorld[-3.9,3.2,-1.48]);
_pilo2 setDir(_dir+45);
if(floor random 11==5)then{[_b,"vill"]call PF_snd};
}