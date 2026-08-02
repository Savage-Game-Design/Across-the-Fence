private _h=selectRandom(switch(civRegion)do{
case"Viet":{["vn_c_conehat_01","vn_c_conehat_02","vn_c_headband_01","vn_c_headband_02","vn_c_headband_03","vn_c_headband_04","H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_cbr","H_Bandanna_khk","H_Bandanna_sgg","H_Bandanna_sand"];};
default{["H_Shemag_olive","H_Shemag_khk","H_Shemag_tan","H_ShemagOpen_khk","H_ShemagOpen_tan","H_Bandanna_gry"]}});
if(_h isNotEqualTo"" &&{floor random 4==1})then{_this addHeadgear _h};