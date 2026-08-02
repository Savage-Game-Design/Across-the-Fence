//Land_VillageStore_01_F
isNil{params["_b"];_f=[];_dir=getDir _b;
_box=createSimpleObject["a3\structures_f_epa\mil\scrapyard\paperbox_closed_f.p3d",[0,0,0]];
_box1=createSimpleObject["a3\structures_f_epa\mil\scrapyard\paperbox_closed_f.p3d",[0,0,0]];
_box2=createSimpleObject["a3\structures_f_epa\mil\scrapyard\paperbox_closed_f.p3d",[0,0,0]];
_box3=createSimpleObject["a3\structures_f_epa\mil\scrapyard\paperbox_closed_f.p3d",[0,0,0]];
_cash=createSimpleObject["a3\structures_f\furniture\cashdesk_f.p3d",[0,0,0]];
_chair=createSimpleObject["a3\structures_f\furniture\chairwood_f.p3d",[0,0,0]];
_ice=createSimpleObject["a3\structures_f\furniture\icebox_f.p3d",[0,0,0]];
_pal=createSimpleObject["a3\structures_f_epa\civ\constructions\pallets_stack_f.p3d",[0,0,0]];
_rack=createSimpleObject["a3\structures_f\furniture\shelvesmetal_f.p3d",[0,0,0]];
_rack1=createSimpleObject["a3\structures_f\furniture\shelvesmetal_f.p3d",[0,0,0]];
_rack2=createSimpleObject["a3\structures_f\furniture\shelvesmetal_f.p3d",[0,0,0]];
_rack3=createSimpleObject["a3\structures_f\furniture\shelvesmetal_f.p3d",[0,0,0]];
_rack4=createSimpleObject["a3\structures_f\furniture\shelvesmetal_f.p3d",[0,0,0]];
_rack5=createSimpleObject["a3\structures_f\furniture\shelvesmetal_f.p3d",[0,0,0]];
{_f pushBack _x}forEach[_box,_box1,_box2,_box3,_cash,_chair,_ice,_pal,_rack,_rack1,_rack2,_rack3,_rack4,_rack5];
_b setVariable["PF",_f];

_box setPos(_b modelToWorld[6.95,6.26,-0.56]);
_box1 setPos(_b modelToWorld[6.97,6.24,0.45]);_box1 setDir(_dir+90);
_box2 setPos(_b modelToWorld[5.49,6.26,-0.56]);
_box3 setPos(_b modelToWorld[6.97,8.2,-0.56]);
_cash setPos(_b modelToWorld[6.87,3.7,-1.84]);
_chair setPos(_b modelToWorld[7.4,4.5,-1.84]);_chair setDir(_dir+30);
_ice setPos(_b modelToWorld[1.6,-.8,-.6]);_ice setDir(_dir-90);
_pal setPos(_b modelToWorld[6.97,8.18,0.236]);
_rack setPos(_b modelToWorld[1.11,1.6,-1.84]);
_rack1 setPos(_b modelToWorld[1.11,3.7,-1.84]);
_rack2 setPos(_b modelToWorld[7.08,3.323,-2.36]);_rack2 setDir(_dir+90);
_rack3 setPos(_b modelToWorld[5.7,-0.77,-1.84]);
_rack4 setPos(_b modelToWorld[5.08,3.323,-1.84]);_rack4 setDir(_dir+90);
_rack5 setPos(_b modelToWorld[4.07,2.335,-1.841]);
{_x setDir _dir}forEach[_box,_box2,_box3,_cash,_pal,_rack,_rack1,_rack3,_rack5];

if(PF_Loot)then{
if(isNil{_b getVariable"PFL"})then{
private _loot=[];
private["_i"];
for"_x"from 0 to(floor random 6)do{_i=createVehicle[(selectRandom(((PF_LootList)#0)#1)),[0,0,0],[],0,"can_collide"];_loot pushBack[_i]};
private _pos=[
(_b modelToWorld[1.3,0.7+random 1.7,-.94]),//rack (2nd Shelf)
(_b modelToWorld[1.3,2.8+random 1.6,-0.59]),//rack1 (Top Shelf)
(_b modelToWorld[6.3+random 1.1,3.1,-1.106])//rack2 (Top Shelf)
];

private _newArr=[];
{_newArr pushBack[_loot#_forEachIndex,_x]}forEach _pos;
{(_x#0)setPos(_x#1)}forEach _newArr;
_b setVariable["PFL",_newArr]}else{
private _newArr=(_b getVariable"PFL");
{(_x#0)setPos(_x#1)}forEach _newArr}}//NEED TO CHECK IF EACH ITEM IS STILL THERE (Example: isNull(_x#0) --- item is [item] and becomes [objNull] once looted
};





PF_Loot=true;
PF_LootList=[]; 
if(PF_Loot)then{ 
private _hats=["Headgear_H_Bandanna_blu","Headgear_H_Bandanna_cbr","Headgear_H_Bandanna_gry","Headgear_H_Bandanna_khk","Headgear_H_Bandanna_sand","Headgear_H_Bandanna_sgg","Headgear_H_Booniehat_khk","Headgear_H_Booniehat_mgrn","Headgear_H_Booniehat_oli","Headgear_H_Booniehat_tan"]; 
private _vests1=["Vest_V_Pocketed_black_F","Vest_V_Pocketed_coyote_F","Vest_V_Pocketed_olive_F","Vest_V_LegStrapBag_black_F","Vest_V_LegStrapBag_coyote_F","Vest_V_LegStrapBag_olive_F"]; 
private _clothes=["Item_U_C_Poloshirt_blue","Item_U_C_Poloshirt_burgundy","Item_U_C_Poloshirt_redwhite","Item_U_C_Poloshirt_salmon","Item_U_C_Poloshirt_stripped","Item_U_C_Poloshirt_tricolour","Item_U_Competitor","Item_U_BG_Guerilla2_2","Item_U_BG_Guerilla2_1","Item_U_BG_Guerilla2_3","Item_U_BG_Guerilla3_1","Item_U_C_HunterBody_grn","Item_U_OrestesBody","Item_U_C_Poor_1"]; 
PF_LootList=[ 
["com",_hats+_vests1+_clothes], 
["med",[]], 
["mil",[]], 
["ind",[]], 
[""],[]]; 
};

if(PF_Loot)then{ 
if(isNil{_b getVariable"PFL"})then{ 
private _loot=[]; 
private["_i"]; 
for"_x"from 0 to 2 do{_i=createVehicle[(selectRandom(((PF_LootList)#0)#1)),[0,0,0],[],0,"can_collide"];_loot pushBack[_i]};
private _pos=[
(_b modelToWorld[1.3,0.7+random 1.7,-.94]),
(_b modelToWorld[1.3,2.8+random 1.6,-0.59]),
(_b modelToWorld[6.3+random 1.1,3.1,-1.106])
];

private _newArr=[];
{_newArr pushBack[_loot#_forEachIndex,_x]}forEach _pos;hint format["%1",_newArr];
{((_x#0)#0)setPos(_x#1)}forEach _newArr;
_b setVariable["PFL",_newArr]}else{

private _newArr=(_b getVariable"PFL");
{(_x#0)setPos(_x#1)}forEach _newArr}};