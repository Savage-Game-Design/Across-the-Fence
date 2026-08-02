private["_u"];_u=[];
switch(civRegion)do{
case"Default":{_u=[];};
case"Jungle":{};
case"Arab":{if(isMaxW)then{_u=[
"Burqa1",
"Burqa2",
"Burqa3",
"Burqa4",
"Burqa5",
"Burqa6"]}else{_u=[]}}};
_this forceAddUniform(selectRandom _u)