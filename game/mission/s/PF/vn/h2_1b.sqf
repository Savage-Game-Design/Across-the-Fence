//Land_vn_hut_02
isNil{params["_b"];
if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B","h2_1b"]};
private _dir = getDir _b;
private _bkt=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_basket_ep1.p3d",[0,0,0]];
private _bowl=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_bowl_ep1.p3d",[0,0,0]];
private _junk=createSimpleObject["vn\vn_structures_f\civ\garbage\vn_garbage_line_f.p3d",[0,0,0]];
private _pan=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pan_01.p3d",[0,0,0]];
private _pilo=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_pillow_ep1.p3d",[0,0,0]];
private _pilo2=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_pillowv2_ep1.p3d",[0,0,0]];
private _pot=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pot_02.p3d",[0,0,0]];
private _rug=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_carpet_ep1.p3d",[0,0,0]];
private _rugs=createSimpleObject["vn\vn_structures_e\misc\misc_interier\vn_blankets_ep1.p3d",[0,0,0]];
private _urn=createSimpleObject["vn\objects_f_vietnam\civ\pots\vn_c_prop_pot_04.p3d",[0,0,0]];
_b setVariable["PF",[_bkt,_bowl,_junk,_pan,_pilo,_pilo2,_pot,_rug,_rugs,_urn]];

_bkt setPos(_b modelToWorld[1.7,1,2.088]);
_bkt setDir (_dir+70);

_bowl setPos(_b modelToWorld[-1.55,3,1.563]);

_junk setPos(_b modelToWorld[0.63,1.3,1.5045]);
_junk setDir _dir;

_pan setPos(_b modelToWorld[-1.3,2.2,1.413]);
_pan setDir(_dir-20);

_pilo setPos(_b modelToWorld[1.66,2.915,1.33]);

_pilo2 setPos(_b modelToWorld[1.35,3.66,1.339]);
_pilo2 setDir(_dir-79);

_pot setPos(_b modelToWorld[-1.3,2.6,1.413]);
_pot setDir(_dir+99);

_rugs setPos(_b modelToWorld[1.35,-0.92,2.11]);
_rugs setDir _dir;

_rug setPos(_b modelToWorld[-0.4,-0.2,1.475]);
_rug setDir(_dir+8);

_urn setPos(_b modelToWorld[-0.42,3.8,1.413]);
_urn setDir(_dir+20);
if(floor random 11==5)then{[_b,"vill"]call PF_snd};
}