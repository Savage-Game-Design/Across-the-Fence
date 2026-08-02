PT_Region="Default";
if(toLowerANSI worldName in["altis","chernarus","livonia","malden","stratis"])then{PT_Region="Default"};
if(toLowerANSI worldName in["desert","kunduz","takistan","zargabad"])then{PT_Region="Arab"};
if(toLowerANSI worldName in["n'ziwasogo","tanoa"])then{PT_Region="Jungle"};
PT_Man=switch(PT_Region)do{
case"Default":{"C_Soldier_VR_F"};
case"Arab":{"O_Soldier_VR_F"};
case"Jungle":{"C_Man_formal_1_F_afro"};
};

PT_cCargo={
params["_c"];
if(round random 2==1)then{
private _seats=_c emptyPositions"cargo";
if(_seats>1)then{
private _seats=floor random _seats;
if(_seats>11)then{_seats=11};
for "_x" from 0 to _seats do {
private _a=createAgent[PT_Man,[0,0,0],[],0,"can_collide"];_a moveInCargo _c;_a disableAI"ALL";_a enableAI"ANIM";
if(PT_Region isEqualTo"Jungle")then{removeGoggles _a;removeAllAssignedItems _a};
_a call PT_initCiv;
}}else{
if(round(random 2)==1)then{
private _a=createAgent[PT_Man,[0,0,0],[],0,"can_collide"];_a moveInCargo _c;_a disableAI"ALL";_a enableAI"ANIM";
if(PT_Region isEqualTo"Jungle")then{removeGoggles _a;removeAllAssignedItems _a};
_a call PT_initCiv;
}}};
(objectParent _a)setEffectiveCommander(driver(objectParent _a));
};

PT_initCiv={
params["_a"];
if(PT_Region in["Arab","Jungle"])then{_a setCaptive true};
{_a call _x}forEach[civU,civV];
};