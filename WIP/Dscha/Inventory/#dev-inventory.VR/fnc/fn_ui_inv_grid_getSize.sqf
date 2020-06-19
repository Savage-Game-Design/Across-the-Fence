/*
	Placeholder function to determine the H size of the Grid!
	
*/

private _size = 10;
if(uniform player isEqualTo "U_B_CombatUniform_mcam")then{_size = _size + 8;};
if(vest player isEqualTo "V_PlateCarrier1_rgr")then{_size = _size + 12;};
systemchat str ["_size: ",_size];
_size