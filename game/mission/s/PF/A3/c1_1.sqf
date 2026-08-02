//Land_Church_01_V1_F
isNil{params["_b"];_f=[];_dir=getDir _b;
_a=createAgent["C_Soldier_VR_F",[0,0,0],[],0,"can_collide"];_a disableAI"ALL";_a allowDamage false;_b setVariable["PF",[_a]];
_a addUniform"U_C_FormalSuit_01_tshirt_black_F";

switch(typeOf _b)do{
case"Land_Church_01_V1_F":{_a setPos(_b modelToWorld[-4,2,-5.9]);_a setDir(_dir+220)};
case"Land_Church_01_V2_F":{_a setPos(_b modelToWorld[-4,2,-5.9]);_a setDir(_dir+220)};
case"Land_Chapel_V1_F":{_a setPos(_b modelToWorld[7,1.8,-2.6]);_a setDir(_dir+240)};
case"Land_Chapel_V2_F":{_a setPos(_b modelToWorld[7,1.8,-2.6]);_a setDir(_dir+240)};
case"Land_Chapel_Small_V1_F":{_a setPos(_b modelToWorld[3.7,-0.1,-0.8]);_a setDir(_dir+270)};
case"Land_Chapel_Small_V2_F":{_a setPos(_b modelToWorld[3.7,-0.1,-0.8]);_a setDir(_dir+270)};
};
[_a,"Acts_Grieving"]remoteExec["switchMove"];
}