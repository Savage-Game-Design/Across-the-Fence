private _g=selectRandom(switch(civRegion)do{
case"Viet":{["","vn_o_scarf_01_01","vn_o_scarf_01_02","vn_o_scarf_01_03","vn_b_squares","vn_g_spectacles_01"]};
case"Arab":{[""]};
default{[""]}});
if(_g isNotEqualTo"" &&{floor random 4==1})then{_this addGoggles _g};